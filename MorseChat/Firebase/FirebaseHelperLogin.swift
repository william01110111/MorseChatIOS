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
	
	
	func loginStateChanged(user: FIRUser?) {
		
		initialLoginAttemptDone = true
		firebaseUser = user
		loginChangedCallback?()
		
		if let user = user {
			self.getUserfromKey(user.uid,
				callback: {	(userIn: User?) -> Void in
					if userIn != nil {
						self.downloadData()
					}
					else { //user is not in the auth database but not in the realtime database, so add it
						
						self.initialAccountSetupDone = false
						
						User.getUniqueUserName(user.displayName ?? "no user name",
							callback: { (userName) in
								
								let newMe = User(userNameIn: userName, displayNameIn: user.displayName ?? "No Display Name", keyIn: user.uid)
								
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
				}
			)
		}
		else {
			self.invalidateData()
		}
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

