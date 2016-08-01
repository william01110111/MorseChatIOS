//
//  FriendSearchResultsCell.swift
//  MorseChat
//
//  Created by William Wold on 7/19/16.
//  Copyright © 2016 Widap. All rights reserved.
//


import UIKit

class FriendSearchResultsCell : UITableViewCell {
	
	var user: User?
	
	var updateResultsCallback: (() -> Void)?
	
	@IBOutlet weak var displayNameLabel: UILabel!
	@IBOutlet weak var userNameLabel: UILabel!
	@IBOutlet weak var friendStatusLabel: UILabel!
	@IBOutlet weak var actionButton: UIButton!
	
	var status = FriendStatus()
	
	func setUser(userIn: User, statusIn: FriendStatus) {
		
		status = statusIn
		
		user = userIn
		displayNameLabel.text = userIn.displayName
		userNameLabel.text = userIn.username
		
		actionButton.layer.cornerRadius = 12
		
		if status.isFriend {
			friendStatusLabel.text = "you are friends"
			actionButton.setTitle("  Unfriend  ", forState: .Normal)
			actionButton.backgroundColor = UIColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 1)
		}
		else if status.requestIn {
			friendStatusLabel.text = "has sent request"
			actionButton.setTitle("  Accept Request  ", forState: .Normal)
			actionButton.backgroundColor = UIColor(red: 0.0, green: 0.875, blue: 0.125, alpha: 1)
		}
		else if status.requestOut {
			friendStatusLabel.text = "request sent"
			actionButton.setTitle("  Cancel Request  ", forState: .Normal)
			actionButton.backgroundColor = UIColor(red: 1.0, green: 0.75, blue: 0.0, alpha: 1)
		}
		else {
			friendStatusLabel.text = "you are not friends"
			actionButton.setTitle("  Add Friend  ", forState: .Normal)
			actionButton.backgroundColor = UIColor(red: 0.0, green: 0.5, blue: 1.0, alpha: 1)
		}
		
		actionButton.updateConstraints()
	}
	
	@IBAction func buttonPressed(sender: AnyObject) {
		if status.isFriend {
			firebaseHelper.unfriend(user!.key)
			status.isFriend = false
		}
		else if status.requestIn {
			firebaseHelper.acceptFriendRequest(user!.key)
			status.isFriend = true
			status.requestIn = false
		}
		else if status.requestOut {
			firebaseHelper.takeBackFriendRequest(user!.key)
			status.requestOut = false
		}
		else {
			firebaseHelper.addFriendRequest(user!.key)
			status.requestOut = true
		}
		
		updateResultsCallback?()
		
		setUser(user!, statusIn: status)
	}
}

