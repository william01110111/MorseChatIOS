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
	
	var user: FIRUser?
	let auth: FIRAuth
	let root: FIRDatabaseReference
	
	init() {
		
		//callback is used so user is not requested while internal state is changing or some BS like that
		
		FIRApp.configure()
		
		auth = FIRAuth.auth()!
		
		root = FIRDatabase.database().reference()
		
		FIRAuth.auth()?.addAuthStateDidChangeListener(
			{ auth, user in
				self.user = user
			}
		);
	}
	
	func signInWithDefaultUser() {
		signInWithEmail("widap@mailinator.com", password: "password")
	}
	
	func signInWithEmail(email: String, password: String) {
		auth.signInWithEmail(email, password: password,
			completion: { FIRAuthResultCallback in
				//sign in worked
				
				self.root.child("users/\(self.user?.uid ?? "")").observeSingleEventOfType(.Value,
					
					withBlock: { (data: FIRDataSnapshot) in
						
						me = User(nameIn: data.value?["name"] as? String ?? "[no name]", keyIn: self.user?.uid ?? "[no user key]")
						
						print("logged in as \(me?.fullName ?? "[login failed]")")
					},
					
					withCancelBlock: { (error) in
						
						print("Error in FirebaseHelper: \(error.localizedDescription)")
					}
				);
			}
		)
	}
}
