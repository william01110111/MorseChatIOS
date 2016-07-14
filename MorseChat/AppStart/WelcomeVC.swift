//
//  WelcomeVC.swift
//  MorseChat
//
//  Created by William Wold on 7/14/16.
//  Copyright © 2016 Widap. All rights reserved.
//

import UIKit

class WelcomeVC : UIViewController {
	
	@IBAction func defaultAccountBtn(sender: AnyObject) {
		
		performSegueWithIdentifier("useDefaultAccountSegue", sender: self)
	}
	
	@IBAction func signInBtn(sender: AnyObject) {
		presentViewController(firebaseHelper.authViewController!, animated: true, completion: nil)
	}
	
}

