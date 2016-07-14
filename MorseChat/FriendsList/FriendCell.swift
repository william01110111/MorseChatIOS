//
//  FriendCell.swift
//  MorseChat
//
//  Created by William Wold on 7/12/16.
//  Copyright © 2016 Widap. All rights reserved.
//

import UIKit

class FriendCell : UITableViewCell {
	
	var friend: Friend?
	
	var buttonState = false
	
	@IBOutlet weak var sendButton: UIButton!
	@IBOutlet weak var nameLabel: UILabel!
	
	func setFriend(friendIn: Friend) {
		
		friend = friendIn
		nameLabel.text = friend!.fullName
		friend!.UILineInCallback=lineInChenaged
		firebaseHelper.setLineInListner(friend!, callback: lineInChenaged)
	}
	
	
	@IBAction func buttonPressed(sender: AnyObject) {
		
		friend?.setOutLine(true)
		//backgroundColor = UIColor(red: 0.0, green: 1.0, blue: 1.0, alpha: 0.5)
	}
	
	@IBAction func buttonReleased(sender: AnyObject) {
		
		friend?.setOutLine(false)
	}
	
	func lineInChenaged(state: Bool) {
		
		if state {
			
			backgroundColor = UIColor(red: 0.0, green: 1.0, blue: 1.0, alpha: 0.5)
		}
		else {
			
			backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.5)
		}
	}
}

