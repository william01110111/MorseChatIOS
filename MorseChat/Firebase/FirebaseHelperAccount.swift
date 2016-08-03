//
//  FirebaseHelperLogin.swift
//  MorseChat
//
//  Created by William Wold on 7/22/16.
//  Copyright © 2016 Widap. All rights reserved.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseDatabase
import FirebaseAuthUI

extension FirebaseHelper {
	
	func isLoggedIn() -> Bool {
		
		return firebaseUser != nil
	}
	
	func loginUI(vc: UIViewController) {
		
		let authUIOp = FIRAuthUI.authUI()
		
		guard let authUI = authUIOp else {
			print("error: authUI was not created")
			return
		}
		
		authUI.delegate = self
		let authViewController = authUI.authViewController()
		vc.presentViewController(authViewController, animated: true, completion: nil)
	}
	
	/*func reauthUI(vc: UIViewController) {
		
		let authUI = FIRAuthUI.authUI()
		authUI.delegate = self
		let authViewController = authUI.authViewController()
		vc.presentViewController(authViewController, animated: true, completion: nil)
	}*/
	
	func loginStateChanged(userInFB: FIRUser?) {
		
		initialLoginAttemptDone = true
		firebaseUser = userInFB
		loginChangedCallback?()
		
		if let userFB = userInFB {
			
			self.getUserfromKey(userFB.uid,
			                    callback: {	(user: User?) -> Void in
									
					if user != nil {
						self.setObservers()
					}
					else { //user is not in the auth database but not in the realtime database, so add it
						
						self.initialAccountSetupDone = false
						self.createUser()
					}
				}
			)
		}
		else {
			self.invalidateData()
		}
	}
	
	func createUser() {
		
		func upload() {
			User.getUniqueUsername(firebaseUser?.displayName ?? "no user name",
				   callback: { (username) in
					
					let newMe = User(usernameIn: username, displayNameIn: self.firebaseUser?.displayName ?? "No Display Name", keyIn: self.firebaseUser?.uid ?? "noUID")
					
					self.uploadMe(newMe,
						success: { () in
							self.setObservers()
						},
						fail: { (errMsg: String) in
							self.invalidateData()
							self.firebaseErrorCallback?(msg: errMsg)
						}
					)
				}
			)
		}
		
		func wait(iters: Int) {
			
			if self.firebaseUser?.displayName != nil || iters > 12 {
				
				upload()
			}
			else {
				_ = Delayer(seconds: 0.25, repeats: false,
				      callback: {
						wait(iters+1)
					}
				)
			}
		}
		
		wait(0)
	}
	
	func signOut() {
		
		removeObservers()
		invalidateData()
		
		if ((try? FIRAuth.auth()!.signOut()) == nil) {
			firebaseErrorCallback?(msg: "sign out error")
		}
	}
	
	func deleteAccount(success: () -> Void, fail: (String) -> Void) {
		
		if let firebaseUser = firebaseUser {
			
			self.deleteAccountData(
				{ () in
					firebaseUser.deleteWithCompletion(
						{ (error:NSError?) in
							if let error = error {
								fail(error.localizedDescription)
							}
							else {
								self.signOut()
								success()
							}
						}
					)
				}
			)
		}
	}
	
	func deleteAccountData(callback: () -> Void) {
		
		func deleteCounterparts(query1: FIRDatabaseReference, child: String, query2: FIRDatabaseReference) {
			query1.child(child).observeSingleEventOfType(.Value,
				withBlock: { (data: FIRDataSnapshot) in
					
					for i in data.children {
						query2.child(i.key).child(child).removeValue()
					}
					
					query1.child(child).removeValue()
				}
			)
		}
		
		deleteCounterparts(root!.child("friendsByUser"), child: me.key, query2: root!.child("friendsByUser"))
		
		deleteCounterparts(root!.child("requestsBySender"), child: me.key, query2: root!.child("requestsByReceiver"))
		
		deleteCounterparts(root!.child("requestsByReceiver"), child: me.key, query2: root!.child("requestsBySender"))
		
		root!.child("users").child(me.key).removeValueWithCompletionBlock(
			{ (error: NSError?, ref: FIRDatabaseReference) in
				if let error = error {
					print(error.localizedDescription)
				}
				
				callback()
			}
		)
	}
}


extension FirebaseHelper : FIRAuthUIDelegate {
	
	@objc func authUI(authUI: FIRAuthUI, didSignInWithUser user: FIRUser?, error: NSError?) {
		
		if let error = error {
			
			print("login error: \(error.localizedDescription)")
		}
	}
}

