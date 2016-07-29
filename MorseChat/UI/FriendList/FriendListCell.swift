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
	
	@IBOutlet weak var nameLabel: UILabel!
	@IBOutlet weak var buttonImage: UIImageView!
	
	let upSenderImage = UIImage.init(named: "upSender")
	let downSenderImage = UIImage.init(named: "downSender")
	
	func setFriend(friendIn: Friend) {
		
		friend = friendIn
		nameLabel.text = friendIn.displayName
		friendIn.lineInCallback=lineInChenaged
		firebaseHelper.setLineInListner(friend!, callback: lineInChenaged)
	}
	
	func setLineOut(state: Bool) {
		
		friend?.setOutLine(state)
		
		if state {
			buttonImage.image = downSenderImage
		}
		else {
			buttonImage.image = upSenderImage
		}
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

