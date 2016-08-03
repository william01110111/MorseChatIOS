//
//  TimeFuncs.swift
//  MorseChat
//
//  Created by William Wold on 7/26/16.
//  Copyright © 2016 Widap. All rights reserved.
//

import Foundation

class Delayer {
	
	let clbk: (() -> Void)?
	var nsTimer: NSTimer?
	
	init() {
		
		clbk = nil
	}
	
	init(seconds: Double, repeats: Bool, callback: () -> Void) {
		
		clbk = callback
		
		nsTimer = NSTimer.scheduledTimerWithTimeInterval(seconds, target: self, selector: #selector(Delayer.callClbk), userInfo: nil, repeats: repeats)
	}
	
	@objc func callClbk() {
		
		clbk?()
	}
	
	func stop() {
		
		nsTimer?.invalidate()
	}
}

class Timekeeper {
	
	private var baseTime = CFAbsoluteTime()
	
	init() {
		reset()
	}
	
	//reset the 'base' time to the current time
	func reset() {
		baseTime = CFAbsoluteTimeGetCurrent()
	}
	
	//get the current time
	func check() -> Double {
		
		return CFAbsoluteTimeGetCurrent() - baseTime
	}
	
	/*static func accurateDelay(seconds: Double, callback: () -> Void) -> (() -> Void) {
		
		var isRunning = true
		
		let timekeeper = Timekeeper()
		
		timekeeper.reset()
		
		let timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue())
		
		dispatch_source_set_timer(
			timer,
			DISPATCH_TIME_NOW,
			UInt64(seconds * Double(NSEC_PER_SEC)),
			0
		)
		
		dispatch_source_set_event_handler(timer,
			{
				if isRunning {
					isRunning = false
					print("accurate delay was suposed to take \(seconds) sec and actually took \(timekeeper.check()) sec")
					callback()
				}
			}
		)
		
		dispatch_resume(timer)
		
		//print("timer should go off in \(seconds) sec")
		
		return { () in
			if (isRunning) {
				isRunning = false
			}
		}
	}*/
	
	//wait for the input seconds and then do the callback, calling the returned closure will cancel
	/*static func delay2(seconds: Double, callback: () -> Void) -> (() -> Void) {
		
		var isRunning = true
		
		let timekeeper = Timekeeper()
		
		timekeeper.reset()
		
		dispatch_after(
			dispatch_time(
				DISPATCH_TIME_NOW,
				Int64(seconds * Double(NSEC_PER_SEC))
			),
			dispatch_get_main_queue(),
			{
				if isRunning {
					isRunning = false
					print("delay was suposed to take \(seconds) sec and actually took \(timekeeper.check()) sec")
					callback()
				}
			}
		)
		
		return { () in
			if (isRunning) {
				isRunning = false
			}
		}
	}*/
}