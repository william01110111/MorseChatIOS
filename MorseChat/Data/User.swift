//
//  User.swift
//  MorseChat
//
//  Created by William Wold on 7/11/16.
//  Copyright © 2016 Widap. All rights reserved.
//

import Foundation

var me: User?

class User {
	
	var fullName: String
	//var name: (first: String, last: String)
	
	var key: String
	
	init(nameIn: String, keyIn: String) {
		
		fullName = nameIn
		key = keyIn
	}
}
