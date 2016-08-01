//
//  HardwareHelper.swift
//  MorseChat
//
//  Created by William Wold on 7/29/16.
//  Copyright © 2016 Widap. All rights reserved.
//

import Foundation
import AudioToolbox

func vibrate(state: Bool) {
	
	AudioServicesPlayAlertSound(kSystemSoundID_Vibrate)
	//AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
	
}
