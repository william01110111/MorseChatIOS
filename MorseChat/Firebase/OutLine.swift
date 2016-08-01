//
//  OutLine.swift
//  MorseChat
//
//  Created by William Wold on 7/29/16.
//  Copyright © 2016 Widap. All rights reserved.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseDatabase

class OutLine {
	
	let friend: Friend
	
	var ready = false
	
	init(friendIn: Friend) {
		
		friend=friendIn
	}
	
	func turnOn() {
		
		
	}
	
	func pushBlock(state: Bool, time: Double) {
		
		firebaseHelper.root!.child("chatsByReceiver").child(friend.key).child(me.key).childByAutoId().setValue("aaa")
	}
}
