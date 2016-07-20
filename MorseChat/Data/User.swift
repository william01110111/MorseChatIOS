//
//  User.swift
//  MorseChat
//
//  Created by William Wold on 7/11/16.
//  Copyright © 2016 Widap. All rights reserved.
//

import Foundation

var me = User()
var userDataDownloaded = false
var friends: [Friend] = []

class User {
	
	var displayName: String
	var userName: String
	var key: String
	
	init() {
		
		displayName = "nodisplayName"
		userName = "noUserNameProvided"
		key = "noKey"
	}
	
	init(userNameIn: String, displayNameIn: String, keyIn: String) {
		
		displayName = displayNameIn
		userName = userNameIn
		key = keyIn
	}
	
	func toFriend() -> Friend {
		
		return Friend(userNameIn: userName, displayNameIn: displayName, keyIn: key)
	}
}

class Friend : User {
	
	var inLineState = false;
	var outLineState = false;
	
	var UILineInCallback: ((state: Bool) -> Void)?
	
	func setOutLine(newState: Bool) {
		
		outLineState = newState
		
		print("line to \(displayName) (\(userName)) is \(outLineState)")
		
		//print("calling firebaseHelper.setLineToUserStatus() with key \(key)")
		
		firebaseHelper.setLineToUserStatus(key, lineOn: outLineState)
	}
	
	func setInLine(newState: Bool) {
		
		inLineState = newState
		
		print("line from \(displayName) (\(userName)) is \(inLineState)")
		
		UILineInCallback?(state: newState)
	}
}
