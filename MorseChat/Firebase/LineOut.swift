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

let maxBlockTime = 1.5
let minGapTime = 10.0

class LineOut {
	
	let friend: Friend
	private var state = false
	var delayer = Delayer()
	let timekeeper = Timekeeper()
	let ref: FIRDatabaseReference
	
	let timekeeper2 = Timekeeper()
	
	init(friendIn: Friend) {
		
		friend=friendIn
		ref = firebaseHelper.root!.child("chatsByReceiver").child(friend.key).child(me.key)
	}
	
	func setState(stateIn: Bool) {
		
		if stateIn==state {
			return
		}
		
		var time = timekeeper.check()
		
		if (!state && stateIn && time > minGapTime) {
			time = 0
		}
		
		pushBlock(stateIn, time: time)
		
		state = stateIn
		timekeeper.reset()
		delayer.stop()
		
		if (stateIn) {
			
			timekeeper2.reset()
			
			delayer = Delayer(seconds: maxBlockTime, repeats: true,
				callback: {
					self.pushBlock(true, time: maxBlockTime)
					self.timekeeper.reset()
				}
			)
		}
	}
	
	func pushBlock(stateIn: Bool, time: Double) {
		
		ref.childByAutoId().setValue(Float(time*(stateIn ? 1 : -1)))
	}
}
