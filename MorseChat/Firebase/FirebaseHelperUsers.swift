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
						usr.userName = (val["userName"] as? String) ?? "error_in_download"
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
	
	func checkIfUserNameAvailable(name: String, ignoreMe: Bool, callback: (available: Bool) -> Void) {
		
		if (ignoreMe && name.lowercaseString == me.userName.lowercaseString) {
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
	
	func searchUsers(queryStr: String, callback: (users: [User]) -> Void) {
		
		//let query = root?.child("usersByUserName").queryOrderedByKey().queryStartingAtValue(queryStr).queryLimitedToFirst(24)
		
		let query = root!.child("users").queryOrderedByChild("lowercase").queryStartingAtValue(queryStr.lowercaseString).queryLimitedToFirst(24)
		
		var ary = [User]()
		
		query.observeSingleEventOfType(.Value,
			   withBlock: { (data: FIRDataSnapshot) in
				
				var elemLeft = data.childrenCount
				
				if elemLeft <= 0 {
					callback(users: ary)
				}
				
				for i in data.children {
					self.getUserfromKey(i.key,
						callback: { (usr: User?) in
							
							if let usr = usr {
								if usr.userName.lowercaseString.hasPrefix(queryStr.lowercaseString) {
									ary.append(usr)
								}
							}
							
							elemLeft-=1;
							
							if elemLeft == 0 {
								callback(users: ary)
							}
							else if elemLeft < 0 {
								print("elemLeft dropped below 0")
							}
						}
					)
				}
			}
		)
	}
}
