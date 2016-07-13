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

let firebaseHelper = FirebaseHelper()

class FirebaseHelper {
	
	var firebaseUser: FIRUser?
	let auth: FIRAuth
	let root: FIRDatabaseReference
	
	init() {
		
		//callback is used so user is not requested while internal state is changing or some BS like that
		
		FIRApp.configure()
		
		auth = FIRAuth.auth()!
		
		root = FIRDatabase.database().reference()
		
		FIRAuth.auth()?.addAuthStateDidChangeListener(
			{ auth, user in
				self.firebaseUser = user
			}
		);
	}
	
	func signInWithDefaultUser() {
		signInWithEmail("widap@mailinator.com", password: "password", successCallback: {}, failCallback: {})
	}
	
	func signInWithEmail(email: String, password: String, successCallback: ()->Void, failCallback: ()->Void) {
		auth.signInWithEmail(email, password: password,
			completion: { FIRAuthResultCallback in
				//sign in worked
				
				self.root.child("users/\(self.firebaseUser?.uid ?? "noUser")").observeSingleEventOfType(.Value,
					
					withBlock: { (data: FIRDataSnapshot) in
						
						me = User(nameIn: data.value?["name"] as? String ?? "[no name]", keyIn: self.firebaseUser?.uid ?? "[no user key]")
						
						print("logged in as \(me.fullName)")
						
						successCallback()
					},
					
					withCancelBlock: { (error) in
						
						print("Error in FirebaseHelper: \(error.localizedDescription)")
						failCallback()
					}
				);
			}
		)
	}
	
	func setLineToUserStatus(otherUserKey: String, lineOn: Bool) {
		
		root.child("lines/ldvmelmee").updateChildValues([otherUserKey : lineOn])
			///\(otherUserKey)")
		
	}
}
