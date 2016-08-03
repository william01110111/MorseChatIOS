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
let minGapTime = 3.0
let maxLatency = 2.0

class LineOut {
	
	let friend: Friend
	private var lastState = false
	private var hasSentBlock = false
	var delayer = Delayer()
	let timekeeper = Timekeeper()
	let ref: FIRDatabaseReference
	
	init(friendIn: Friend) {
		
		friend=friendIn
		ref = firebaseHelper.root!.child("chatsByReceiver").child(friend.key).child(me.key)
	}
	
	func setState(stateIn: Bool) {
		
		if stateIn==lastState {
			return
		}
		lastState = stateIn
		
		delayer.stop()
		
		var time = timekeeper.check()
		
		if stateIn && time > minGapTime {
			time = 0
		}
		
		if !hasSentBlock {
			time = 0
			hasSentBlock = true
		}
		
		pushBlock(stateIn, time: time)
		
		if (stateIn) {
			
			delayer = Delayer(seconds: maxBlockTime, repeats: true,
				callback: {
					self.pushBlock(true, time: maxBlockTime)
				}
			)
		}
	}
	
	func pushBlock(stateIn: Bool, time: Double) {
		
		ref.childByAutoId().setValue(Float(time*(stateIn ? 1 : -1)))
		timekeeper.reset()
	}
}
