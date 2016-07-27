//
//  FriendSearchResultsVC.swift
//  MorseChat
//
//  Created by William Wold on 7/19/16.
//  Copyright © 2016 Widap. All rights reserved.
//


import UIKit

class FriendSearchResultsVC: UIViewController {
	
	var results = [User]()
	
	@IBOutlet weak var tableView: UITableView!
	@IBOutlet weak var spinnerView: UIView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.spinnerView.hidden = true
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
		
		return results.count
	}
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
		
		let cell = tableView.dequeueReusableCellWithIdentifier("friendSearchResultsCell")! as! FriendSearchResultsCell
		
		cell.setUser(results[indexPath.row])
		
		return cell
	}
}

extension FriendSearchResultsVC : UISearchResultsUpdating {
	
	func updateSearchResultsForSearchController(searchController: UISearchController) {
		
		spinnerView.hidden = false
		
		let text = searchController.searchBar.text ?? ""
		
		firebaseHelper.searchUsers(text,
			callback: { (users) in
				
				self.results = users
				
				self.tableView.reloadData()
				self.spinnerView.hidden = true
			}
		)
	}
}

