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
			spinner.hidden = false
		}
	}
	
	func showBtn() {
		if viewIfLoaded != nil {
			signInBtn.hidden = false
			spinner.hidden = true
		}
	}
	
	func showError(msg: String) {
		
		errorMsgLabel.text = msg;
		errorMsgLabel.hidden = false;
	}
	
	func startLoginUI() {
		if viewHasAppeared {
			firebaseHelper.loginUI(self)
		}
	}
	
	func segueAway() {
		if viewHasAppeared {
			self.performSegueWithIdentifier("logInFromWelcomeSegue", sender: self)
		}
	}
	
	@IBAction func signInBtnPressed(sender: AnyObject) {
		startLoginUI()
	}
	
	func updateLoginState() {
		
		if viewIfLoaded != nil {
			if firebaseHelper.isLoggedIn {
				if userDataDownloaded {
					segueAway()
				}
				else {
					showSpinner()
					
					if !userDataDownloading {
						firebaseHelper.downloadUserData({
								self.segueAway()
							},
							fail: {
								self.showBtn()
								self.showError("user data download failed")
							}
						)
					}
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
		
		/*if (firebaseHelper.firebaseUser != nil) {
			
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
		}*/
	}
}

