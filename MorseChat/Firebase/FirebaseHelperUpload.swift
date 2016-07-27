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
					self.root!.child("users").child(newMe.key).updateChildValues(["displayName": newMe.displayName, "username": newMe.username, "lowercase": newMe.username.lowercaseString])
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
	
	func addFriendRequest(other: String) {
		
		root!.child("requestsBySender").child(me.key).updateChildValues([other: true])
		root!.child("requestsByReceiver").child(other).updateChildValues([me.key: true])
	}
	
	func acceptFriendRequest(other: String) {
		
		rejectFriendRequest(other)
		
		root!.child("friendsByUser").child(me.key).updateChildValues([other: false])
		root!.child("friendsByUser").child(other).updateChildValues([me.key: false])
		
		downloadFriends()
	}
	
	func rejectFriendRequest(other: String) {
		
		root!.child("requestsBySender").child(other).child(me.key).removeValue()
		root!.child("requestsByReceiver").child(me.key).child(other).removeValue()
		
		downloadRequestsIn()
	}
	
	func takeBackFriendRequest(other: String) {
		root!.child("requestsBySender").child(me.key).child(other).removeValue()
		root!.child("requestsByReceiver").child(other).child(me.key).removeValue()
	}
	
	func unfriend(other: String) {
		
		root!.child("friendsByUser").child(me.key).child(other).removeValue()
		root!.child("friendsByUser").child(other).child(me.key).removeValue()
		
		downloadFriends()
	}
}

