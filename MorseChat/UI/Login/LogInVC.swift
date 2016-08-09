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
	
	override func viewDidLoad() {
		super.viewDidLoad()
	}
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		
		showGood()
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
		
		self.performSegueWithIdentifier("exitToWelcome", sender: self)
	}
	
	@IBAction func signInPressed(sender: AnyObject) {
		
		if emailField.text == nil || emailField.text!.isEmpty {
			showError("email required")
			return
		}
		
		if passwordField.text == nil || passwordField.text!.isEmpty {
			showError("password required")
			return
		}
		
		showSpinner()
		
		firebaseHelper.signInWithEmail(emailField.text!, password: passwordField.text!,
			callback: { (error: String?) in
				if let error = error {
					self.showError(error)
				}
				else {
					self.performSegueWithIdentifier("exitToWelcome", sender: self)
				}
			}
		)
	}
	
}
