//
//  FriendSearchVC.swift
//  MorseChat
//
//  Created by William Wold on 7/18/16.
//  Copyright © 2016 Widap. All rights reserved.
//


import UIKit

class FriendSearchVC: UIViewController {
	
	var searchUI: UISearchController?
	
	@IBOutlet weak var tableView: UITableView!
	
	//@IBOutlet weak var tableView: UITableView!
	@IBOutlet var rootView: UIView!
	@IBOutlet weak var stackView: UIStackView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		
		let searchResultsVC = storyboard?.instantiateViewControllerWithIdentifier("friendSearchResultsVC")
		//searchResultsVC?.get
		searchUI = UISearchController(searchResultsController: searchResultsVC)
		
		if let searchUI = searchUI {
			searchUI.searchResultsUpdater = searchResultsVC as? UISearchResultsUpdating
			searchUI.hidesNavigationBarDuringPresentation = false
			searchUI.dimsBackgroundDuringPresentation = true
			definesPresentationContext = true
			stackView.addSubview(searchUI.searchBar)
		}
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		
		tableView.reloadData()
		
		firebaseHelper.userDataChangedCallback = { () in
			self.tableView.reloadData()
		}
	}
	
	override func viewDidAppear(animated: Bool) {
		super.viewDidAppear(animated)
		
	}
}


extension FriendSearchVC: UITableViewDataSource {
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		
		return requestsIn.count
	}
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
		
		let cell = tableView.dequeueReusableCellWithIdentifier("incomingRequestCell")! as! IncomingRequestCell
		
		if indexPath.row < requestsIn.count {
			
			cell.setUser(requestsIn[indexPath.row])
			
		}
		else {
			
			print("indexPath.row bigger then search array")
		}
		
		return cell
	}
}

