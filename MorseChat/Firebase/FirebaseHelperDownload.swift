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
	
	func downloadData() {
		
		downloadMe()
		downloadFriends()
	}
	
	func invalidateData() {
		
		meDownloaded = false
		friendsDownloaded = false
		userDataChangedCallback?()
	}
	
	func downloadFriends() {
		
		guard let user = firebaseUser else
		{
			friendsDownloaded = false
			firebaseErrorCallback?(msg: "Tried to download frinds without a signed in user")
			return
		}
		
		var ary = [Friend]()
		
		let query = root!.child("friendsByUser/\(user.uid)").queryOrderedByChild("lowercase")
		
		query.observeSingleEventOfType(.Value,
			withBlock: { (data: FIRDataSnapshot) in

				var elemLeft = data.childrenCount

				print("elem left: \(elemLeft)")
				
				//if there are no friends it has to be handeled differently
				if elemLeft == 0 {
					friends.removeAll()
					friendsDownloaded = true
					self.userDataChangedCallback?()
				}

				for i in data.children {
					self.getUserfromKey(i.key,
						callback: { (userIn: User?) -> Void in
							
							if let userIn = userIn {
								ary.append(userIn.toFriend())
							}
							else {
								ary.append(Friend(usernameIn: "error", displayNameIn: "error downloading friend", keyIn: "errorKey"))
							}
							
							elemLeft -= 1
							
							if elemLeft == 0 {
								friends = ary
								friendsDownloaded = true
								self.userDataChangedCallback?()
							}
						}
					)
				}
			}
		)
	}
	
	func downloadMe() {
		
		guard let user = firebaseUser else
		{
			meDownloaded = true
			firebaseErrorCallback?(msg: "Tried to download me without a signed in user")
			return
		}
		
		self.getUserfromKey(user.uid,
			callback: { (usr) in
				if let usr = usr {
					me = usr
					meDownloaded = true
					self.userDataChangedCallback?()
				}
				else {
					meDownloaded = false
					self.firebaseErrorCallback?(msg: "Error downloading me")
				}
			}
		)
	}
}
