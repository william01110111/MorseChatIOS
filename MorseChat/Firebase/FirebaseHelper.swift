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
	var initialLoginAttemptDone = false
	var loginChangedCallback: (() -> Void)?
	var userDataChangedCallback: (() -> Void)?
	var firebaseErrorCallback: ((msg: String) -> Void)?
	
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
		
		firebaseErrorCallback = { (msg: String) in
			
			print("firebase error: \(msg)")
		}
	}
	
	func isLoggedIn() -> Bool {
		
		return firebaseUser != nil
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
			return
		}
		
		if newMe.displayName.isEmpty {
			
			fail(errMsg: "Display name required")
			return
		}
		
		checkIfUserNameAvailable(newMe.userName, ignoreMe: true,
			callback: { (available) in
				if available {
					self.root!.child("users").child(newMe.key).updateChildValues(["displayName": newMe.displayName, "userName": newMe.userName, "lowercase": newMe.userName.lowercaseString])
					me = newMe
					self.userDataChangedCallback?()
					success()
				}
				else {
					fail(errMsg: "Username already taken")
				}
			}
		)
	}
	
	func loginStateChanged(user: FIRUser?) {
		
		meDownloaded = false
		friendsDownloaded = false
		userDataChangedCallback?()
		
		initialLoginAttemptDone = true
		firebaseUser = user
		loginChangedCallback?()
		
		if let user = user {
			self.getUserfromKey(user.uid,
				callback: {	(userIn: User?) -> Void in
					if userIn != nil {
						self.downloadMe()
						self.downloadFriends()
					}
					else { //user is not in the auth database but not in the realtime database, so add it
						User.getUniqueUserName(user.displayName ?? "no user name",
							callback: { (userName) in
								
								let newMe = User(userNameIn: userName, displayNameIn: user.displayName ?? "No Display Name", keyIn: user.uid)
								
								self.updateMe(newMe,
									success: { () in},
									fail: { (errMsg: String) in
										self.firebaseErrorCallback?(msg: errMsg)
									}
								)
							}
						)
					}
				}
			)
		}
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
	
	func checkIfUserNameAvailable(name: String, ignoreMe: Bool, callback: (available: Bool) -> Void) {
		
		if (ignoreMe && name.lowercaseString == me.userName.lowercaseString) {
			callback(available: true)
			return;
		}
		
		let query = root!.child("users").queryOrderedByChild("lowercase").queryEqualToValue(name.lowercaseString)
		
		query.observeSingleEventOfType(.Value,
			withBlock: { (data: FIRDataSnapshot) in
				
				callback(available: !data.exists())
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
							
							if elemLeft == 0 {
								callback(users: ary)
							}
							else if elemLeft < 0 {
								print("elemLeft dropped below 0")
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
				
				if let val = (data.value as? Bool) {
					let state = val
					callback(lineOn: state)
				}
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


