//
//  LineIn.swift
//  MorseChat
//
//  Created by William Wold on 8/2/16.
//  Copyright © 2016 Widap. All rights reserved.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseDatabase

class LineIn {
	
	var stateChangedCallback: ((Bool) -> Void)?
	let friend: Friend
	var timeTilOver = 0.0
	var state = false
	//var cancelCallback: (() -> Void)?
	let timekeeper = Timekeeper()
	let ref: FIRDatabaseReference
	var delayer = Delayer()
	
	init(friendIn: Friend) {
		
		friend = friendIn
		
		ref = firebaseHelper.root!.child("chatsByReceiver").child(me.key).child(friend.key)
		
		ref.removeAllObservers()
		
		ref.observeEventType(.ChildAdded, withBlock: self.childAdded)
	}
	
	func childAdded(data: FIRDataSnapshot) {
		
		let val = (data.value as? Float ?? 0.0)
		
		addBlock(val >= 0, time: Double(abs(val)))
		
		ref.child(data.key).removeValue()
	}
	
	func addBlock(newState: Bool, time: Double) {
		
		timeTilOver += time
		timeTilOver -= timekeeper.check()
		
		timekeeper.reset()
		
		if time == 0 {
			
			timeTilOver += minGapTime
			
			if timeTilOver < maxLatency {
				timeTilOver = maxLatency
			}
		}
		
		if timeTilOver < 0 {
			timeTilOver = 0
		}
		
		_ = Delayer(seconds: timeTilOver, repeats: false,
			callback: { () in
				
				self.stateChangedCallback?(newState)
				
				self.delayer.stop()
				
				if newState {
					
					self.delayer = Delayer(seconds: maxBlockTime, repeats: false,
						callback: {
							self.stateChangedCallback?(false)
						}
					)
				}
			}
		)
	}
	
	func abort() {
		
		
	}
}
