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
	var initialAccountSetupDone = true
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
	
	func setLineInListner(friend: Friend, callback: (lineOn: Bool) -> Void) {
		
		root!.child("friendsByUser/\(me.key)/\(friend.key)").observeEventType(.Value,
			withBlock: { (data: FIRDataSnapshot) -> Void in
				
				if let val = (data.value as? Bool) {
					callback(lineOn: val)
				}
			}
		)
	}
	
	func setLineToUserStatus(otherUserKey: String, lineOn: Bool) {
		
		root!.child("friendsByUser/\(otherUserKey)").updateChildValues([me.key : lineOn])
			///\(otherUserKey)")
		
	}
}


