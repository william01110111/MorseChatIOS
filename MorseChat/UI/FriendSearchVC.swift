//
//  FriendSearchVC.swift
//  MorseChat
//
//  Created by William Wold on 7/18/16.
//  Copyright © 2016 Widap. All rights reserved.
//


import UIKit

class FriendSearchVC: UIViewController {
	
	let searchController = UISearchController(searchResultsController: nil)
	
	//@IBOutlet weak var tableView: UITableView!
	@IBOutlet var rootView: UIView!
	@IBOutlet weak var stackView: UIStackView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		
		searchController.searchResultsUpdater = self
		searchController.hidesNavigationBarDuringPresentation = true
		searchController.dimsBackgroundDuringPresentation = true
		definesPresentationContext = true
		stackView.addSubview(searchController.searchBar)
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	override func viewDidAppear(animated: Bool) {
		super.viewDidAppear(animated)
		
	}
}

extension FriendSearchVC: UITableViewDataSource {
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		
		return 3;//friends.count
	}
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
		
		var cell: UITableViewCell
		
		cell = tableView.dequeueReusableCellWithIdentifier("searchCellID")!
		
		//(cell as! FriendCell).setFriend(friends[indexPath.row])
		
		return cell
	}
}

extension FriendSearchVC : UISearchResultsUpdating {
	
	func updateSearchResultsForSearchController(searchController: UISearchController) {
		
		print("search results updated")
	}
}

