//
//  FriendCell.swift
//  MorseChat
//
//  Created by William Wold on 7/12/16.
//  Copyright © 2016 Widap. All rights reserved.
//

import UIKit

class FriendCell : UITableViewCell {
	
	var friend: User?
	
	var buttonState = false
	
	@IBOutlet weak var sendButton: UIButton!
	@IBOutlet weak var nameLabel: UILabel!
	
	func setFriend(friendIn: User) {
		
		friend = friendIn
		nameLabel.text = friend?.fullName
	}
	
	
	@IBAction func buttonPressed(sender: AnyObject) {
		
		setButton(true)
	}
	
	@IBAction func buttonReleased(sender: AnyObject) {
		
		setButton(false)
	}
	
	func setButton(newState: Bool) {
		
		buttonState = newState
		
		if buttonState {
			backgroundColor = UIColor(red: 0.0, green: 1.0, blue: 1.0, alpha: 0.5)
		}
		else {
			backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.5)
		}
		
		print(buttonState)
		
		if friend != nil {
			print("calling firebaseHelper.setLineToUserStatus() with key \(friend!.key)")
			firebaseHelper.setLineToUserStatus(friend!.key, lineOn: buttonState)
		}
	}
}

