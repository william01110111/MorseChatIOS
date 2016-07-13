//
//  SimpSignInVC.swift
//  MorseChat
//
//  Created by William Wold on 7/13/16.
//  Copyright © 2016 Widap. All rights reserved.
//

import UIKit

class SimpSignInVC : UIViewController {
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
	}
	
	override func viewDidAppear(animated: Bool) {
		super.viewDidAppear(animated)
		
		
	}
	
	@IBAction func signInBtn0(sender: AnyObject) {
		
		firebaseHelper.signInWithEmail("widap@mailinator.com", password: "password",
			successCallback: {
				self.performSegueWithIdentifier("logInSegue", sender: self)
			},
			failCallback: {
				print("login failed")
			}
		)
	}
	
}
