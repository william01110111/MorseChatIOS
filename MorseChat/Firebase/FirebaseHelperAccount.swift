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
		
		let authUI = FIRAuthUI.authUI()!
		authUI.delegate = self
		let authViewController = authUI.authViewController()
		vc.presentViewController(authViewController, animated: true, completion: nil)
	}
	
	
	func loginStateChanged(userInFB: FIRUser?) {
		
		initialLoginAttemptDone = true
		firebaseUser = userInFB
		loginChangedCallback?()
		
		if let userFB = userInFB {
			
			self.getUserfromKey(userFB.uid,
			                    callback: {	(user: User?) -> Void in
									
									if user != nil {
										self.downloadData()
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
											self.downloadData()
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
				delay(0.25,
				      callback: {
						wait(iters+1)
					}
				)
			}
		}
		
		wait(0)
	}
	
	func signOut() {
		
		if ((try? FIRAuth.auth()!.signOut()) == nil) {
			print("sign out error")
		}
	}
}


extension FirebaseHelper : FIRAuthUIDelegate {
	
	@objc func authUI(authUI: FIRAuthUI, didSignInWithUser user: FIRUser?, error: NSError?) {
		
		if let error = error {
			
			print("login error: \(error.localizedDescription)")
		}
	}
}

