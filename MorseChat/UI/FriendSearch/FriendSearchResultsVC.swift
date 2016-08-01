//
//  FriendSearchResultsVC.swift
//  MorseChat
//
//  Created by William Wold on 7/19/16.
//  Copyright © 2016 Widap. All rights reserved.
//


import UIKit

class FriendSearchResultsVC: UIViewController {
	
	var resultsUsers = [User]()
	var resultsStatus = [FriendStatus]()
	var searchText = ""
	
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
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		
		firebaseHelper.userDataChangedCallback = { () in
			self.updateResults()
		}
	}
	
	func updateResults() {
		
		spinnerView.hidden = false
		
		firebaseHelper.searchUsers(searchText, ignoreMe: true,
			callback: { (users) in
				
				self.resultsUsers = users
				//self.resultsStatus.reserveCapacity(users.count)
				self.resultsStatus = [FriendStatus](count: users.count, repeatedValue: FriendStatus())
				var left = users.count
				
				if left == 0 {
					
					self.tableView.reloadData()
					self.spinnerView.hidden = true
				}
				
				for i in 0..<users.count {
					firebaseHelper.getFriendStatusOfUser(users[i].key,
						callback: { (statusIn: FriendStatus) in
							if (self.resultsStatus.count>i) {
								self.resultsStatus[i] = statusIn
							}
							left -= 1
							if left == 0 {
								self.tableView.reloadData()
								self.spinnerView.hidden = true
							}
						}
					)
				}
			}
		)
	}
	
}

extension FriendSearchResultsVC: UITableViewDataSource {
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		
		return resultsUsers.count
	}
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
		
		let cell = tableView.dequeueReusableCellWithIdentifier("friendSearchResultsCell")! as! FriendSearchResultsCell
		
		if indexPath.row < resultsUsers.count && indexPath.row < resultsUsers.count {
			
			cell.setUser(resultsUsers[indexPath.row], statusIn: resultsStatus[indexPath.row])
			
			cell.updateResultsCallback = updateResults
		
		}
		else {
			
			print("indexPath.row bigger then search array")
		}
		
		return cell
	}
}

extension FriendSearchResultsVC : UISearchResultsUpdating {
	
	func updateSearchResultsForSearchController(searchController: UISearchController) {
		
		searchText = searchController.searchBar.text ?? ""
		
		updateResults()
	}
}

