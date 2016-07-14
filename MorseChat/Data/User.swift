//
//  User.swift
//  MorseChat
//
//  Created by William Wold on 7/11/16.
//  Copyright © 2016 Widap. All rights reserved.
//

import Foundation

var me = User()
var friendsDownloaded = false
var friends: [Friend] = []

class User {
	
	var fullName: String
	//var name: (first: String, last: String)
	
	var key: String
	
	init() {
		
		fullName = "noName"
		key = "noKey"
	}
	
	init(nameIn: String, keyIn: String) {
		
		fullName = nameIn
		key = keyIn
	}
	
	func toFriend() -> Friend {
		
		return Friend(nameIn: fullName, keyIn: key)
	}
}

class Friend : User {
	
	var inLineState = false;
	var outLineState = false;
	
	var UILineInCallback: ((state: Bool) -> Void)?
	
	func setOutLine(newState: Bool) {
		
		outLineState = newState
		
		print("line to \(fullName) is \(outLineState)")
		
		//print("calling firebaseHelper.setLineToUserStatus() with key \(key)")
		
		firebaseHelper.setLineToUserStatus(key, lineOn: outLineState)
		
		setInLine(outLineState)
	}
	
	func setInLine(newState: Bool) {
		
		inLineState = newState
		
		print("line from \(fullName) is \(inLineState)")
		
		UILineInCallback?(state: newState)
	}
}
