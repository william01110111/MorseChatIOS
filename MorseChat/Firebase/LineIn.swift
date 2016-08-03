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
	
	init(friendIn: Friend) {
		
		friend = friendIn
		
		ref = firebaseHelper.root!.child("chatsByReceiver").child(me.key).child(friend.key)
		
		firebaseHelper.root!.child("chatsByReceiver").child(me.key).child(friendIn.key).removeAllObservers()
		
		firebaseHelper.root!.child("chatsByReceiver").child(me.key).child(friendIn.key).observeEventType(.ChildAdded, withBlock: self.childAdded)
	}
	
	func childAdded(data: FIRDataSnapshot) {
		
		let val = (data.value as? Float ?? 0.0)
		
		addBlock(Double(val))
		
		ref.child(data.key).removeValue()
	}
	
	func addBlock(val: Double) {
		
		let newState = (val >= 0)
		let time = abs(val)
		
		timeTilOver -= timekeeper.check()
		timekeeper.reset()
		timeTilOver += time
		
		if time == 0 && timeTilOver < minGapTime {
			timeTilOver = minGapTime
		}
		
		if timeTilOver < 0 {
			timeTilOver = 0
		}
		
		_ = Delayer(seconds: timeTilOver, repeats: false,
			callback: { () in
				self.stateChangedCallback?(newState)
			}
		)
	}
	
	/*func addBlockToEnd(val: Double) {
		
		let newState = val > 0
		let time = abs(val)
		
		if let cancelCallback = cancelCallback {
			cancelCallback()
			self.cancelCallback = nil
		}
		
		timeTilOver -= timekeeper.check()
		
		print("timeTilOver: \(timeTilOver)")
		
		if (timeTilOver<0) {
			timeTilOver = 0
		}
		
		if (val == 0) {
			
			if (timeTilOver < minGapTime) {
				timeTilOver = minGapTime
			}
			
		}
		
		timekeeper.reset()
		
		if state != newState {
			_ = Timekeeper.delay(timeTilOver,
				callback: { () in
					self.stateChangedCallback?(newState)
				}
			)
			
			state = newState
		}
		
		timeTilOver += time
		
		if (newState) {
			
			cancelCallback = Timekeeper.delay(timeTilOver,
				 callback: { () in
					self.state = false
					self.stateChangedCallback?(false)
				}
			)
		}
	}*/
	
	func abort() {
		
		
	}
}
