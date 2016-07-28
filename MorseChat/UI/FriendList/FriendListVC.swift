//
//  ViewController.swift
//  MorseChat
//
//  Created by William Wold on 7/11/16.
//  Copyright © 2016 Widap. All rights reserved.
//

import UIKit

class FriendsListViewController: UIViewController {
	
	@IBOutlet var tableView: UITableView!
	
	@IBOutlet weak var addFriendsButton: UIBarButtonItem!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		
		firebaseHelper.downloadFriends()
		
		tableView.reloadData()
		
		firebaseHelper.userDataChangedCallback = { () in
			self.tableView.reloadData()
		}
	}
	
	override func viewDidAppear(animated: Bool) {
		super.viewDidAppear(animated)
		
		
	}
}

extension FriendsListViewController: UITableViewDataSource {
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		
		return friends.count
	}
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
		
		var cell: UITableViewCell
		
		cell = tableView.dequeueReusableCellWithIdentifier("friendCell")!
		
		(cell as! FriendCell).setFriend(friends[indexPath.row])
		
		return cell
	}
}
