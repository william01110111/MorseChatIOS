//
//  MyProfileCell.swift
//  MorseChat
//
//  Created by William Wold on 7/21/16.
//  Copyright © 2016 Widap. All rights reserved.
//

import Foundation


import UIKit

class MyProfileSettingsCell : UITableViewCell {
	
	@IBOutlet weak var displayNameLabel: UILabel!
	@IBOutlet weak var usernameLabel: UILabel!
	
	func setup() {
		
		displayNameLabel.text = me.displayName
		usernameLabel.text = me.userName
	}
}

