//
//  SettingsVC.swift
//  MorseChat
//
//  Created by William Wold on 7/21/16.
//  Copyright © 2016 Widap. All rights reserved.
//


import UIKit

class SettingsVC: UIViewController {
	
	@IBOutlet weak var tableView: UITableView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		
		tableView.reloadData()
	}
	
	override func viewDidAppear(animated: Bool) {
		super.viewDidAppear(animated)
		
	}
	
	@IBAction func exitToSettings(segue:UIStoryboardSegue) {
		
	}
}


extension SettingsVC: UITableViewDataSource {
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		
		return 1
	}
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
		
		var cell: UITableViewCell
		
		switch indexPath.row {
		case 0:
			cell = tableView.dequeueReusableCellWithIdentifier("myProfileSettingsCell")!
			(cell as! MyProfileSettingsCell).setup()
		default:
			cell = tableView.dequeueReusableCellWithIdentifier("myProfileSettingsCell")!
		}
		
		return cell
	}
}

