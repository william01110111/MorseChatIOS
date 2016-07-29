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
	
	var selectedCell: FriendCell?
	
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
	
	@IBAction func buttonTouchDown(sender: AnyObject, forEvent event: UIEvent) {
		var pt = CGPoint()
		
		for touch in event.touchesForView(sender as! UIView)! {
			pt = touch.locationInView(tableView)
		}
		
		let visableCells = tableView.visibleCells
		
		for cell in visableCells {
			if cell.frame.contains(pt) {
				selectedCell = cell as? FriendCell
				selectedCell?.setLineOut(true)
			}
		}
	}
	
	@IBAction func buttonReleased(sender: AnyObject) {
		selectedCell?.setLineOut(false)
		selectedCell = nil
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
