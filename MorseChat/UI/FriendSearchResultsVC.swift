//
//  FriendSearchResultsVC.swift
//  MorseChat
//
//  Created by William Wold on 7/19/16.
//  Copyright © 2016 Widap. All rights reserved.
//


import UIKit

class FriendSearchResultsVC: UIViewController {
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	override func viewDidAppear(animated: Bool) {
		super.viewDidAppear(animated)
		
	}
}

extension FriendSearchResultsVC: UITableViewDataSource {
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		
		return 3;//friends.count
	}
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
		
		var cell: UITableViewCell
		
		cell = tableView.dequeueReusableCellWithIdentifier("friendSearchResultsCell")!
		
		//(cell as! FriendCell).setFriend(friends[indexPath.row])
		
		return cell
	}
}

extension FriendSearchResultsVC : UISearchResultsUpdating {
	
	func updateSearchResultsForSearchController(searchController: UISearchController) {
		
		print("search results updated")
	}
}

