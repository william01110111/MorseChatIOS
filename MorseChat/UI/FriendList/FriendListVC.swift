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
	@IBOutlet weak var cheatSheet0: UILabel!
	@IBOutlet weak var cheatSheet1: UILabel!
	@IBOutlet weak var cheatSheet2: UILabel!
	@IBOutlet weak var showCheatSheetBtn: UIButton!
	
	@IBOutlet weak var cheatSheetView: UIView!
	@IBOutlet weak var addFriendsButton: UIBarButtonItem!
	
	var selectedCell: FriendCell?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		cheatSheet0.text="A •－\nB －•••\nC －•－•\nD －••\nE •\nF ••－•\nG －－•\nH ••••\nI ••"
		cheatSheet1.text="J •－－－\nK －•－\nL •－••\nM －－\nN －•\nO －－－\nP•－－•\nQ－－•－\nR －•－"
		cheatSheet2.text="S •••\nT －\nU ••－\nV •••－\nW •－－\nX －••－\nY －•－－\nZ －－••\n. •－•－•－"
		
		cheatSheetView.hidden=true
		showCheatSheetBtn.hidden=false
	}
	
	@IBAction func showCheatSheet(sender: AnyObject) {
		cheatSheetView.hidden=false
		showCheatSheetBtn.hidden=true
	}
	
	@IBAction func hideCheatSheet(sender: AnyObject) {
		cheatSheetView.hidden=true
		showCheatSheetBtn.hidden=false
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		
		reload()
		
		firebaseHelper.userDataChangedCallback = { () in
			self.reload()
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
	
	func reload() {
		
		if (requestsInDownloaded && requestsIn.count>0) {
			addFriendsButton.tintColor=UIColor(colorLiteralRed: 1.0, green: 0.0, blue: 0.0, alpha: 1.0)
			addFriendsButton.title = "Add (\(requestsIn.count))"
		}
		else {
			
			addFriendsButton.tintColor=UIColor(colorLiteralRed: 0.0, green: 0.5, blue: 1.0, alpha: 1.0)
			addFriendsButton.title = "Add"
		}
		
		tableView.reloadData()
	}
}

extension FriendsListViewController: UITableViewDataSource {
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		
		if (friendsDownloaded && friends.count>0) {
			return friends.count
		}
		else {
			return 1
		}
	}
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
		
		var cell: UITableViewCell
		
		if (friendsDownloaded && friends.count>0) {
			cell = tableView.dequeueReusableCellWithIdentifier("friendCell")!
			
			if indexPath.row<friends.count {
				(cell as! FriendCell).setFriend(friends[indexPath.row])
			}
		}
		else {
			cell = tableView.dequeueReusableCellWithIdentifier("noFriendsCell")!
		}
		
		return cell
	}
}
