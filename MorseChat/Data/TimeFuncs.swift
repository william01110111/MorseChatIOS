//
//  TimeFuncs.swift
//  MorseChat
//
//  Created by William Wold on 7/26/16.
//  Copyright © 2016 Widap. All rights reserved.
//

import Foundation

func delay(delay:Double, callback:()->()) {
	dispatch_after(
		dispatch_time(
			DISPATCH_TIME_NOW,
			Int64(delay * Double(NSEC_PER_SEC))
		),
		dispatch_get_main_queue(), callback)
}
