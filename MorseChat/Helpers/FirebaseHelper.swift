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

let firebaseHelper = FirebaseHelper()

class FirebaseHelper {
	
	var user: FIRUser?
	
	init() {
		
		//callback is used so user is not requested while internal state is changing or some BS like that
		
		FIRAuth.auth()?.addAuthStateDidChangeListener { auth, user in
			
			self.user = user
		}
	}
}
