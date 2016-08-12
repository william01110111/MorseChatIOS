//
//  LogInVC.swift
//  MorseChat
//
//  Created by William Wold on 8/9/16.
//  Copyright © 2016 Widap. All rights reserved.
//

import UIKit

class LogInVC : UIViewController {
	
	@IBOutlet weak var emailField: UITextField!
	@IBOutlet weak var passwordField: UITextField!
	@IBOutlet weak var errorMsg: UILabel!
	@IBOutlet weak var spinnerView: UIView!
	@IBOutlet weak var signInBtn: UIButton!
	@IBOutlet weak var displayNameLabel: UILabel!
	@IBOutlet weak var displayNameField: UITextField!
	
	static var createAccount = false
	static var exitSegueStr = ""
	
	override func viewDidLoad() {
		super.viewDidLoad()
	}
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		
		showGood()
		
		if LogInVC.createAccount {
			signInBtn.setTitle("Create Account", forState: .Normal)
			displayNameField.hidden = false
			displayNameLabel.hidden = false
		}
		else {
			signInBtn.setTitle("Sign In", forState: .Normal)
			displayNameField.hidden = true
			displayNameLabel.hidden = true
		}
	}
	
	override func viewDidAppear(animated: Bool) {
		super.viewDidAppear(animated)
		
	}
	
	func showGood() {
		
		errorMsg.hidden = true
		spinnerView.hidden = true
	}
	
	func showError(msg: String) {
		
		errorMsg.text = msg
		errorMsg.hidden = false
		spinnerView.hidden = true
	}
	
	func showSpinner() {
		
		errorMsg.hidden = true
		spinnerView.hidden = false
	}
	
	
	@IBAction func backPressed(sender: AnyObject) {
		
		self.performSegueWithIdentifier(LogInVC.exitSegueStr, sender: self)
	}
	
	@IBAction func signInPressed(sender: AnyObject) {
		
		if emailField.text == nil || emailField.text!.isEmpty {
			showError("Email required")
			return
		}
		
		if passwordField.text == nil || passwordField.text!.isEmpty {
			showError("Password required")
			return
		}
		
		if LogInVC.createAccount && (displayNameField.text == nil || displayNameField.text!.isEmpty) {
			showError("Display name required")
			return
		}
		
		showSpinner()
		
		if LogInVC.createAccount {
			firebaseHelper.createAccountWithEmail(emailField.text!, displayName: displayNameField.text!, password: passwordField.text!,
				callback: { (error: String?) in
					if let error = error {
						self.showError(error)
					}
					else {
						self.performSegueWithIdentifier(LogInVC.exitSegueStr, sender: self)
					}
				}
			)
		}
		else {
			firebaseHelper.signInWithEmail(emailField.text!, password: passwordField.text!,
				callback: { (error: String?) in
					if let error = error {
						self.showError(error)
					}
					else {
						self.performSegueWithIdentifier(LogInVC.exitSegueStr, sender: self)
					}
				}
			)
		}
	}
	
}
