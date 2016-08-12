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
	@IBOutlet weak var spinner: UIActivityIndicatorView!
	@IBOutlet weak var signInBtn: UIButton!
	@IBOutlet weak var createAccountBtn: UIButton!
	
	
	private var viewHasAppeared = false
	
	override func loadView() {
		super.loadView()
		
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		errorMsgLabel.hidden = true
		viewHasAppeared = false
		
		firebaseHelper.loginChangedCallback = updateLoginState
	}
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		
		firebaseHelper.userDataChangedCallback = updateLoginState
		firebaseHelper.loginChangedCallback = updateLoginState
		updateLoginState()
	}
	
	override func viewDidAppear(animated: Bool) {
		super.viewDidAppear(animated)
		
		viewHasAppeared = true
		
		updateLoginState()
	}
	
	override func viewWillDisappear(animated: Bool) {
		super.viewWillDisappear(animated)
		viewHasAppeared = false
	}
	
	override func viewDidDisappear(animated: Bool) {
		super.viewDidDisappear(animated)
	}
	
	func showSpinner() {
		if viewIfLoaded != nil {
			signInBtn.hidden = true
			createAccountBtn.hidden = true
			spinner.hidden = false
		}
	}
	
	func showBtn() {
		if viewIfLoaded != nil {
			signInBtn.hidden = false
			createAccountBtn.hidden = false
			spinner.hidden = true
		}
	}
	
	func showError(msg: String) {
		
		errorMsgLabel.text = msg;
		errorMsgLabel.hidden = false;
	}
	
	/*func startLoginUI() {
		if viewHasAppeared {
			firebaseHelper.loginUI(self)
		}
	}*/
	
	func segueAway() {
		if viewHasAppeared {
			if (firebaseHelper.initialAccountSetupDone) {
				self.performSegueWithIdentifier("logInFromWelcomeSegue", sender: self)
			}
			else {
				self.performSegueWithIdentifier("setupAccountSegue", sender: self)
			}
		}
	}
	
	@IBAction func createAccountBtnPressed(sender: AnyObject) {
		LogInVC.createAccount = true
		LogInVC.exitSegueStr = "exitToWelcomeSegue"
		performSegueWithIdentifier("signInFromWelcomeSegue", sender: self)
	}
	
	@IBAction func signInBtnPressed(sender: AnyObject) {
		//startLoginUI()
		LogInVC.createAccount = false
		LogInVC.exitSegueStr = "exitToWelcomeSegue"
		performSegueWithIdentifier("signInFromWelcomeSegue", sender: self)
	}
	
	@IBAction func exitToWelcome(segue:UIStoryboardSegue) {
		
	}
	
	func updateLoginState() {
		
		if viewIfLoaded != nil {
			if firebaseHelper.isLoggedIn() {
				if allDownloaded() {
					segueAway()
				}
				else {
					showSpinner()
				}
			}
			else {
				if firebaseHelper.initialLoginAttemptDone {
					showBtn()
				}
				else {
					showSpinner()
				}
			}
		}
	}
}

