//
//  FirebaseHelperUpload.swift
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
	
	func uploadMe(newMe: User, success: () -> Void, fail: (errMsg: String) -> Void) {
		
		let error=User.checkUsername(newMe.username)
		
		if let error = error {
			
			fail(errMsg: error)
			return
		}
		
		if newMe.displayName.isEmpty {
			
			fail(errMsg: "Display name required")
			return
		}
		
		checkIfUsernameAvailable(newMe.username, ignoreMe: true,
			 callback: { (available) in
				if available {
					self.root!.child("users").child(newMe.key).updateChildValues(["displayName": newMe.displayName, "userName": newMe.username, "lowercase": newMe.username.lowercaseString])
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
	
	
	func requestFriend(key: String) {
		
		root!.child("friendsByUser").child(me.key).updateChildValues([key: false])
		root!.child("friendsByUser").child(key).updateChildValues([me.key: false])
	}
}

