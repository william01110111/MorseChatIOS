//
//  SettingsVC.swift
//  MorseChat
//
//  Created by William Wold on 7/21/16.
//  Copyright © 2016 Widap. All rights reserved.
//


import UIKit

class DeleteAccountConfirmVC: UIViewController {
	
	@IBOutlet weak var backgroundView: UIView!
	
	var tryToDelete = false
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		tryToDelete = false
		backgroundView.layer.cornerRadius = 15
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		
	}
	
	override func viewDidAppear(animated: Bool) {
		super.viewDidAppear(animated)
		
		if tryToDelete {
			deleteButtonPressed(self)
		}
	}
	
	@IBAction func cancelButtonPressed(sender: AnyObject) {
		
		performSegueWithIdentifier("exitToProfileSegue", sender: self)
	}
	
	@IBAction func deleteButtonPressed(sender: AnyObject) {
		
		firebaseHelper.deleteAccount(
			{
				self.performSegueWithIdentifier("exitToWelcomeSegue", sender: self)
			},
			fail: { (msg: String) in
				firebaseHelper.loginUI(self)
				self.tryToDelete = true
				//print(msg)
				//self.showError(msg)
			}
		)
	}
}
