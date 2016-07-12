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
	
	@IBOutlet weak var sendButton: UIButton!
	@IBOutlet weak var nameLabel: UILabel!
	
	func setFriend(friendIn: User) {
		
		friend = friendIn
		nameLabel.text = friend?.fullName
	}
}

