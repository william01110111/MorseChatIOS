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
	
	func copy() -> User {
		
		return User(userNameIn: userName, displayNameIn: displayName, keyIn: key)
	}
	
	static func getUniqueUserName(seedName: String, callback: (userName: String) -> Void) {
		
		var name = ""
		
		for c in seedName.characters {
			
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
			
			firebaseHelper.checkIfUserNameAvailable(attempt, ignoreMe: false,
				callback: { (available) in
					if available {
						callback(userName: attempt)
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
	static func checkUserName(name: String) -> String? {
		
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
		
		print("line to \(displayName) (\(userName)) is \(outLineState)")
		
		//print("calling firebaseHelper.setLineToUserStatus() with key \(key)")
		
		firebaseHelper.setLineToUserStatus(key, lineOn: outLineState)
	}
	
	func setInLine(newState: Bool) {
		
		inLineState = newState
		
		print("line from \(displayName) (\(userName)) is \(inLineState)")
		
		lineInCallback?(state: newState)
	}
}
