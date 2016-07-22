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
	
	@IBOutlet weak var displayNameLabel: UILabel!
	@IBOutlet weak var userNameLabel: UILabel!
	
	func setUser(userIn: User) {
		
		user = userIn
		displayNameLabel.text = userIn.displayName
		userNameLabel.text = userIn.userName
	}
	
	
	@IBAction func buttonPressed(sender: AnyObject) {
		
		firebaseHelper.requestFriend(user!.key)
	}
}

