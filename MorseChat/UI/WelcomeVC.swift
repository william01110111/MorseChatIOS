//
//  WelcomeVC.swift
//  MorseChat
//
//  Created by William Wold on 7/14/16.
//  Copyright © 2016 Widap. All rights reserved.
//

import UIKit

class WelcomeVC : UIViewController {
	
	@IBOutlet weak var errorMsgLabel: UILabel!
	
	@IBOutlet weak var spinnerView: UIView!
	
	override func viewDidLoad() {
		
		super.viewDidLoad()
		
		errorMsgLabel.hidden = true
		spinnerView.hidden = true
	}
	
	override func viewWillAppear(animated: Bool) {
		
		super.viewWillAppear(animated)
		
		
	}
	
	override func viewDidAppear(animated: Bool) {
		
		super.viewDidAppear(animated)
		
		if (!userDataDownloaded) {
			loginStateChanged()
		}
		if (userDataDownloaded) {
			
			self.performSegueWithIdentifier("logInFromWelcomeSegue", sender: self)
			
		}
	}
	
	func loginStateChanged() {
		if (firebaseHelper.firebaseUser != nil) {
			
			spinnerView.hidden = false
			
			firebaseHelper.downloadUserData(
				{ () -> Void in
					self.performSegueWithIdentifier("logInFromWelcomeSegue", sender: self)
				},
				fail: { () -> Void in
					self.spinnerView.hidden = true
					self.errorMsgLabel.hidden = false
				}
			)
		}
		else {
			errorMsgLabel.hidden = true
			spinnerView.hidden = true
		}
	}
	
	@IBAction func signInBtn(sender: AnyObject) {
		firebaseHelper.loginUI(self)
	}
}

