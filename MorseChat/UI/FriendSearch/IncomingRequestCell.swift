//
//  FriendSearchResultsCell.swift
//  MorseChat
//
//  Created by William Wold on 7/19/16.
//  Copyright © 2016 Widap. All rights reserved.
//


import UIKit

class IncomingRequestCell : UITableViewCell {
	
	var user: User?
	
	@IBOutlet weak var displayNameLabel: UILabel!
	@IBOutlet weak var userNameLabel: UILabel!
	@IBOutlet weak var rejectButton: UIButton!
	@IBOutlet weak var acceptButton: UIButton!
	
	func setUser(userIn: User) {
		
		user = userIn
		displayNameLabel.text = userIn.displayName
		userNameLabel.text = userIn.username
		
		rejectButton.layer.cornerRadius = 12
		acceptButton.layer.cornerRadius = 12
	}
	
	@IBAction func rejectPressed(sender: AnyObject) {
		firebaseHelper.rejectFriendRequest(user!.key)
	}
	
	@IBAction func acceptPressed(sender: AnyObject) {
		firebaseHelper.acceptFriendRequest(user!.key)
	}
}

