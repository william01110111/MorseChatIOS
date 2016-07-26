//
//  User.swift
//  MorseChat
//
//  Created by William Wold on 7/11/16.
//  Copyright © 2016 Widap. All rights reserved.
//

import Foundation

var me = User()
var friends: [Friend] = []

var meDownloaded = false
var friendsDownloaded = false

func allDownloaded() -> Bool {
	
	return (meDownloaded && friendsDownloaded)
}

class User {
	
	var displayName: String
	var username: String
	var key: String
	
	init() {
		displayName = "nodisplayName"
		username = "noUsernameProvided"
		key = "noKey"
	}
	
	init(usernameIn: String, displayNameIn: String, keyIn: String) {
		
		displayName = displayNameIn
		username = usernameIn
		key = keyIn
	}
	
	func toFriend() -> Friend {
		
		return Friend(usernameIn: username, displayNameIn: displayName, keyIn: key)
	}
	
	func copy() -> User {
		
		return User(usernameIn: username, displayNameIn: displayName, keyIn: key)
	}
	
	static func getUniqueUsername(seedName: String, callback: (username: String) -> Void) {
		
		var name = ""
		
		for c in seedName.lowercaseString.characters {
			
			if ((c>="a" && c<="z") || (c>="A" && c<="Z") || (c>="0" && c<="9") || c=="_" || c=="." || c=="-") {
				name.append(c)
			}
		}
		
		if name.characters.count < 3 {
			name = "user"
		}
		
		func nextNum(iter: Int) {
			
			var attempt = name
			
			if iter > 0 {
				attempt += String(iter)
			}
			
			firebaseHelper.checkIfUsernameAvailable(attempt, ignoreMe: false,
				callback: { (available) in
					if available {
						callback(username: attempt)
					}
					else
					{
						nextNum(iter+1)
					}
				}
			)
		}
		
		nextNum(0)
	}
	
	//returns nil if there is no error, otherwise returns error message
	static func checkUsername(name: String) -> String? {
		
		if name.isEmpty {
			return "username required"
		}
		if name.characters.count<3 {
			return "Username too short"
		}
		
		for c in name.characters {
			
			if c==" " {
				return "user name may not contain spaces"
			}
			
			if !((c>="a" && c<="z") || (c>="A" && c<="Z") || (c>="0" && c<="9") || c=="_" || c=="." || c=="-") {
				return "username may only contain letters, numbers and these characters: .-_"
			}
		}
		
		return nil
	}
}

class Friend : User {
	
	var inLineState = false;
	var outLineState = false;
	
	var lineInCallback: ((state: Bool) -> Void)?
	
	func setOutLine(newState: Bool) {
		
		outLineState = newState
		
		print("line to \(displayName) (\(username)) is \(outLineState)")
		
		//print("calling firebaseHelper.setLineToUserStatus() with key \(key)")
		
		firebaseHelper.setLineToUserStatus(key, lineOn: outLineState)
	}
	
	func setInLine(newState: Bool) {
		
		inLineState = newState
		
		print("line from \(displayName) (\(username)) is \(inLineState)")
		
		lineInCallback?(state: newState)
	}
}
