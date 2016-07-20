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
	
	var firebaseUser: FIRUser?
	var auth: FIRAuth?
	var root: FIRDatabaseReference?
	
	override init() {
		
		super.init()
		
		//callback is used so user is not requested while internal state is changing or some BS like that
		
		FIRApp.configure()
		
		auth = FIRAuth.auth()!
		
		root = FIRDatabase.database().reference()
		
		FIRAuth.auth()?.addAuthStateDidChangeListener(
			{ auth, user in
				print("\n\n\nlogin state changed, user: \(user?.displayName)\n\n\n")
				self.firebaseUser = user
			}
		);
	}
	
	func loginUI(vc: UIViewController) {
		
		let authUI = FIRAuthUI.authUI()!
		authUI.delegate = self
		let authViewController = authUI.authViewController()
		vc.presentViewController(authViewController, animated: true, completion: nil)
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
					
					usr.displayName = data.value!["displayName"] as! String
					usr.userName = data.value!["userName"] as! String
					usr.key = key
					
					callback(usr: usr)
				}
				else {
					callback(usr: nil)
				}
			}
		)
	}
	
	func searchUsers(queryStr: String, callback: (users: [User]) -> Void) {
		
		//let query = root?.child("usersByUserName").queryOrderedByKey().queryStartingAtValue(queryStr).queryLimitedToFirst(24)
		
		let query = root!.child("users").queryOrderedByChild("userName").queryStartingAtValue(queryStr)
		
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
								ary.append(usr)
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
	
	func requestFriend(key: String) {
		
		root!.child("friendsByUser").child(me.key).updateChildValues([key: false])
		root!.child("friendsByUser").child(key).updateChildValues([me.key: false])
	}
	
	func updateMe(newMe: User, success: () -> Void, fail: (errMsg: String) -> Void) {
		
		/*for c in newMe.userName.characters {
			
			if c==" " {
				fail(errMsg: "User name can not contain spaces")
				return
			}
			else if !((c>="a" && c<"z") || (c>="0" && c<="9")) {
				
			}
		}*/
		
		let error=User.checkUserName(newMe.userName)
		
		if let error = error {
			
			fail(errMsg: error)
			print("error: \(error)")
			return
		}
		
		root!.child("users").child(newMe.key).updateChildValues(["displayName": newMe.displayName])
		root!.child("users").child(newMe.key).updateChildValues(["userName": newMe.userName])
		//root!.child("usersByUserName").updateChildValues([newMe.userName: newMe.key])
	}
}

extension FirebaseHelper : FIRAuthUIDelegate {
	
	@objc func authUI(authUI: FIRAuthUI, didSignInWithUser user: FIRUser?, error: NSError?) {
		
		//this shpuld be done by the listener I set in the init method
		//firebaseUser = user
		
		//create a new user if it doesn't already exist
		if let user = user {
			getUserfromKey(user.uid,
				callback: { (userIn: User?) -> Void in
					if let userIn = userIn {
						me = userIn
					}
					else
					{
						let newMe = User(userNameIn: "aa aa", displayNameIn: user.displayName ?? "No Display Name", keyIn: user.uid)
						self.updateMe(newMe,
							success: { () in
							
							},
							fail: { (errMsg: String) in
								print(error)
							}
						)
					}
				}
			)
		}
		
		if let error = error {
			
			print("login error: \(error.localizedDescription)")
		}
	}
}
