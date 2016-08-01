//
//  FirebaseHelperUsers.swift
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

	
	func getUserfromKey(key: String, callback: (usr: User?) -> Void) {
		
		root!.child("users/\(key)").observeSingleEventOfType(.Value,
			 withBlock: { (data: FIRDataSnapshot) in
				
				if (data.exists()) {
					
					let usr = User()
					
					if let val = data.value {
						usr.displayName = (val["displayName"] as? String) ?? "Error In Download"
						usr.username = (val["username"] as? String) ?? "error_in_download"
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
	
	func forAllUsersInQuery(query: FIRDatabaseQuery, forUser: (User) -> Void, whenDone: () -> Void) {
		
		query.observeSingleEventOfType(.Value,
		   withBlock: { (data: FIRDataSnapshot) in
				self.forAllUsersInSnapshot(data, forUser: forUser, whenDone: whenDone)
			}
		)
	}
	
	func forAllUsersInSnapshot(data: FIRDataSnapshot, forUser: (User) -> Void, whenDone: () -> Void) {
		
		var elemLeft = data.childrenCount
		
		//if there are no friends it has to be handeled differently
		if elemLeft == 0 {
			
			whenDone()
		}
		else {
			for i in data.children {
				self.getUserfromKey(i.key,
					callback: { (userIn: User?) -> Void in
						
						if let userIn = userIn {
							forUser(userIn)
						}
						
						elemLeft -= 1
						
						if elemLeft == 0 {
							whenDone()
						}
					}
				)
			}
		}
	}
	
	func checkIfUsernameAvailable(name: String, ignoreMe: Bool, callback: (available: Bool) -> Void) {
		
		if (ignoreMe && name.lowercaseString == me.username.lowercaseString) {
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
	
	func searchUsers(queryStr: String, ignoreMe: Bool, callback: (users: [User]) -> Void) {
		
		//let query = root?.child("usersByUserName").queryOrderedByKey().queryStartingAtValue(queryStr).queryLimitedToFirst(24)
		
		let query = root!.child("users").queryOrderedByChild("lowercase").queryStartingAtValue(queryStr.lowercaseString).queryLimitedToFirst(24)
		
		var ary = [User]()
		
		forAllUsersInQuery(query,
			forUser: { (user: User) in
				let matches = user.username.lowercaseString.hasPrefix(queryStr.lowercaseString)
				if matches && (!ignoreMe || user.key != me.key) {
					ary.append(user)
				}
			}, whenDone: { () in
				callback(users: ary)
			}
		)
	}
}
