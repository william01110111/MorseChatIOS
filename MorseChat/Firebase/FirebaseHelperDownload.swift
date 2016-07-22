//
//  FirebaseHelperDownload.swift
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
	
	//downloads various data including friend array and me User
	func downloadUserData(success: () -> Void, fail: () -> Void) {
		
		if userDataDownloading {
			fail()
			return
		}
		
		userDataDownloading = true
		
		var error = false
		var downloadsLeft = 2;
		
		userDataDownloaded = false
		
		if (firebaseUser == nil) {fail()}
		let user = firebaseUser!
		
		func downloadDone() {
			
			downloadsLeft -= 1;
			
			if downloadsLeft==0 {
				if error {
					userDataDownloading = false
					fail()
				}
				else {
					userDataDownloading = false
					userDataDownloaded = true
					success()
				}
			}
			else if downloadsLeft < 0 {
				print("downloadsLeft dropped below 0")
				fail()
			}
		}
		
		self.getUserfromKey(user.uid,
			callback: { (usr) in
				if let usr = usr {
					me = usr
					downloadDone()
				}
				else {
					error = true
					downloadDone()
				}
			}
		)
		
		friends.removeAll();
		
		root!.child("friendsByUser/\(user.uid)").queryOrderedByChild("lowercase").observeEventType(.Value,
			   withBlock: { (data: FIRDataSnapshot) in
				
				var elemLeft = data.childrenCount
				
				//if there are no friends it has to be handeled differently
				if elemLeft == 0 {
					downloadDone()
				}
				
				for i in data.children {
					self.getUserfromKey(i.key,
						callback: { (userIn: User?) -> Void in
							
							if let userIn = userIn {
								friends.append(userIn.toFriend())
							}
							else {
								friends.append(Friend(userNameIn: "error", displayNameIn: "error downloading friend", keyIn: "errorKey"))
							}
							
							elemLeft -= 1
							
							if elemLeft == 0 {
								downloadDone()
							}
						}
					)
				}
			}
		)
	}
}
