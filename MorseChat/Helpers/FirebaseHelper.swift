//
//  FirebaseHelper.swift
//  MorseChat
//
//  Created by William Wold on 7/11/16.
//  Copyright © 2016 Widap. All rights reserved.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseDatabase
import FirebaseAuthUI

let firebaseHelper = FirebaseHelper()

class FirebaseHelper : NSObject {
	
	private var firebaseUser: FIRUser?
	private var auth: FIRAuth?
	private var root: FIRDatabaseReference?
	var isLoggedIn = false
	var initialLoginAttemptDone = false
	var loginChangedCallback: (() -> Void)?
	
	override init() {
		
		super.init()
		
		//callback is used so user is not requested while internal state is changing or some BS like that
		
		auth = FIRAuth.auth()!
		
		root = FIRDatabase.database().reference()
		
		FIRAuth.auth()?.addAuthStateDidChangeListener(
			{ auth, user in
				self.loginStateChanged(user)
			}
		);
	}
	
	func loginUI(vc: UIViewController) {
		
		let authUI = FIRAuthUI.authUI()!
		authUI.delegate = self
		let authViewController = authUI.authViewController()
		vc.presentViewController(authViewController, animated: true, completion: nil)
	}
	
	func updateMe(newMe: User, success: () -> Void, fail: (errMsg: String) -> Void) {
		
		let error=User.checkUserName(newMe.userName)
		
		if let error = error {
			
			fail(errMsg: error)
			print("error: \(error)")
			return
		}
		
		root!.child("users").child(newMe.key).updateChildValues(["displayName": newMe.displayName, "userName": newMe.userName, "lowercase": newMe.userName.lowercaseString])
	}
	
	func loginStateChanged(user: FIRUser?) {
		
		func loginDone(newMe: User?) {
			
			me = newMe ?? User()
			isLoggedIn = (newMe != nil)
			self.firebaseUser = user
			if !isLoggedIn {
				userDataDownloaded = false
			}
			
			if let loginChangedCallback = loginChangedCallback {
				loginChangedCallback()
			}
		}
		
		initialLoginAttemptDone = true
		
		if let user = user {
			self.getUserfromKey(user.uid,
				callback: { (userIn: User?) -> Void in
					if let userIn = userIn {
						loginDone(userIn)
					}
					else { //user is not in the auth database but not in the realtime database, so add it
						User.getUniqueUserName(user.displayName ?? "no user name",
							callback: { (userName) in
								
								let newMe = User(userNameIn: userName, displayNameIn: user.displayName ?? "No Display Name", keyIn: user.uid)
								
								self.updateMe(newMe,
									success: { () in
										loginDone(newMe)
									},
									fail: { (errMsg: String) in
										print(errMsg)
									}
								)
							}
						)
					}
				}
			)
		}
		else {
			loginDone(nil)
		}
	}
	
	//downloads various data including friend array and me User
	func downloadUserData(success: () -> Void, fail: () -> Void) {
		
		var error = false
		var downloadsLeft = 2;
		
		userDataDownloaded = false
		
		if (firebaseUser == nil) {fail()}
		let user = firebaseUser!
		
		func downloadDone() {
			
			downloadsLeft -= 1;
			
			if downloadsLeft==0 {
				if error {
					fail()
				}
				else {
					success()
				}
			}
			else if downloadsLeft < 0 {
				print("downloadsLeft dropped below 0")
				fail()
			}
		}
		
		self.getUserfromKey(user.uid,
			callback: { (usr) in
				if let usr = usr {
					me = usr
					downloadDone()
				}
				else {
					error = true
					downloadDone()
				}
			}
		)
		
		friends.removeAll();
		
		root!.child("friendsByUser/\(user.uid)").observeEventType(.Value,
			withBlock: { (data: FIRDataSnapshot) in
				
				var elemLeft = data.childrenCount
				
				//if there are no friends it has to be handeled differently
				if elemLeft == 0 {
					downloadDone()
				}
				
				for i in data.children {
					self.getUserfromKey(i.key,
						callback: { (userIn: User?) -> Void in
							
							if let userIn = userIn {
								friends.append(userIn.toFriend())
							}
							else {
								friends.append(Friend(userNameIn: "error", displayNameIn: "error downloading friend", keyIn: "errorKey"))
							}
							
							elemLeft -= 1
							
							if elemLeft == 0 {
								downloadDone()
							}
						}
					)
				}
			}
		)
	}
	
	func getUserfromKey(key: String, callback: (usr: User?) -> Void) {
		
		root!.child("users/\(key)").observeEventType(.Value,
			withBlock: { (data: FIRDataSnapshot) in
				
				if (data.exists()) {
					
					let usr = User()
					
					if let val = data.value {
						usr.displayName = (val["displayName"] as? String) ?? "Error In Download"
						usr.userName = (val["userName"] as? String) ?? "error_in_download"
					}
					
					usr.key = key
					
					callback(usr: usr)
				}
				else {
					callback(usr: nil)
				}
			}
		)
	}
	
	func checkIfUserNameAvailable(name: String, callback: (available: Bool) -> Void) {
		
		let query = root!.child("users").queryOrderedByChild("lowercase").queryEqualToValue(name.lowercaseString)
		
		query.observeSingleEventOfType(.Value,
			withBlock: { (data: FIRDataSnapshot) in
				
				callback(available: data.childrenCount==0)
			}
		)
	}
	
	func searchUsers(queryStr: String, callback: (users: [User]) -> Void) {
		
		//let query = root?.child("usersByUserName").queryOrderedByKey().queryStartingAtValue(queryStr).queryLimitedToFirst(24)
		
		let query = root!.child("users").queryOrderedByChild("lowercase").queryStartingAtValue(queryStr.lowercaseString).queryLimitedToFirst(24)
		
		var ary = [User]()
		
		query.observeSingleEventOfType(.Value,
			withBlock: { (data: FIRDataSnapshot) in
				
				var elemLeft = data.childrenCount
				
				print("elemLeft: \(elemLeft)")
				
				if elemLeft <= 0 {
					callback(users: ary)
				}
				
				for i in data.children {
					self.getUserfromKey(i.key,
						callback: { (usr: User?) in
							
							if let usr = usr {
								if usr.userName.lowercaseString.hasPrefix(queryStr.lowercaseString) {
									ary.append(usr)
								}
							}
							
							elemLeft-=1;
							
							if elemLeft <= 0 {
								callback(users: ary)
							}
						}
					)
				}
			}
		)
	}
	
	func requestFriend(key: String) {
		
		root!.child("friendsByUser").child(me.key).updateChildValues([key: false])
		root!.child("friendsByUser").child(key).updateChildValues([me.key: false])
	}
	
	func signInWithEmail(email: String, password: String, successCallback: ()->Void, failCallback: ()->Void) {
		auth!.signInWithEmail(email, password: password,
			completion: { FIRAuthResultCallback in
				//sign in worked
				
				
			}
		)
	}
	
	func setLineInListner(friend: Friend, callback: (lineOn: Bool) -> Void) {
		
		root!.child("friendsByUser/\(me.key)/\(friend.key)").observeEventType(.Value,
			withBlock: { (data: FIRDataSnapshot) -> Void in
				
				let state = data.value as! Bool
				
				callback(lineOn: state)
			}
		)
	}
	
	func setLineToUserStatus(otherUserKey: String, lineOn: Bool) {
		
		root!.child("friendsByUser/\(otherUserKey)").updateChildValues([me.key : lineOn])
			///\(otherUserKey)")
		
	}
}

extension FirebaseHelper : FIRAuthUIDelegate {
	
	@objc func authUI(authUI: FIRAuthUI, didSignInWithUser user: FIRUser?, error: NSError?) {
		
		if let error = error {
			
			print("login error: \(error.localizedDescription)")
		}
	}
}
