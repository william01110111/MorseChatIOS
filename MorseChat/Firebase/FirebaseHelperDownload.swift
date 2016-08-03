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
	
	func invalidateData() {
		
		meDownloaded = false
		friendsDownloaded = false
		userDataChangedCallback?()
	}
	
	func setObservers() {
		
		removeObservers()
		
		setMeObserver()
		setFriendsObserver()
		setRequestsInObserver()
	}
	
	func removeObservers() {
		
		for i in observers {
			i.removeAllObservers()
		}
		
		observers.removeAll()
	}
	
	func setFriendsObserver() {
		
		guard let userFB = firebaseUser else
		{
			friendsDownloaded = false
			firebaseErrorCallback?(msg: "Tried to download frinds without a signed in user")
			return
		}
		
		let query = root!.child("friendsByUser").child(userFB.uid)
		
		query.removeAllObservers()
		
		query.observeEventType(.Value,
			withBlock: { (data: FIRDataSnapshot) in
				var ary = [Friend]()
				
				self.forAllUsersInSnapshot(data,
					forUser: { (user: User) in
						ary.append(user.toFriend())
						
						//sort
						var i = ary.count - 1
						while (i > 0 && ary[i-1].displayName>ary[i].displayName) {
							let tmp = ary[i-1]
							ary[i-1] = ary[i]
							ary[i] = tmp
							i -= 1
						}
					},
					whenDone: {
						friends = ary
						friendsDownloaded = true
						self.userDataChangedCallback?()
					}
				)
			}
		)
		
		observers.append(query)
	}
	
	func setMeObserver() {
		
		guard let userFB = firebaseUser else
		{
			meDownloaded = true
			firebaseErrorCallback?(msg: "Tried to download me without a signed in user")
			return
		}
		
		let query = root!.child("users").child(userFB.uid)
		
		query.removeAllObservers()
		
		query.observeEventType(.Value,
			withBlock: { (data: FIRDataSnapshot) in
				self.getUserfromKey(userFB.uid,
					callback: { (usr) in
						if let usr = usr {
							me = usr
							meDownloaded = true
							self.userDataChangedCallback?()
						}
						else {
							meDownloaded = false
							//self.firebaseErrorCallback?(msg: "Error downloading me")
						}
					}
				)
			}
		)
		
		observers.append(query)
	}
	
	func setRequestsInObserver() {
		
		guard let userFB = firebaseUser else
		{
			requestsInDownloaded = false
			firebaseErrorCallback?(msg: "Tried to download friend requests without a signed in user")
			return
		}
		
		let query = root!.child("requestsByReceiver").child(userFB.uid)
		
		query.removeAllObservers()
		
		query.observeEventType(.Value,
			withBlock: { (data: FIRDataSnapshot) in
				var ary = [User]()
				
				self.forAllUsersInSnapshot(data,
					forUser: { (user: User) in
						ary.append(user)
					},
					whenDone: {
						requestsIn = ary
						requestsInDownloaded = true
						self.userDataChangedCallback?()
					}
				)
			}
		)
	}
	
	func getFriendStatusOfUser(other: String, callback: (FriendStatus) -> Void) {
		
		var out = FriendStatus()
		var isFriendDone = false, requestOutDone = false, requestInDone = false
		
		func downloadDone() {
			
			if isFriendDone && requestOutDone && requestInDone {
				callback(out)
			}
		}
		
		root!.child("friendsByUser").child(me.key).child(other).observeSingleEventOfType(.Value,
		    withBlock: { (data: FIRDataSnapshot) in
				out.isFriend = data.exists()
				isFriendDone = true
				downloadDone()
			}
		)
		
		root!.child("requestsBySender").child(me.key).child(other).observeSingleEventOfType(.Value,
			 withBlock: { (data: FIRDataSnapshot) in
				out.requestOut = data.exists()
				requestOutDone = true
				downloadDone()
			}
		)
		
		root!.child("requestsByReceiver").child(me.key).child(other).observeSingleEventOfType(.Value,
			 withBlock: { (data: FIRDataSnapshot) in
				out.requestIn = data.exists()
				requestInDone = true
				downloadDone()
			}
		)
	}
}
