//
//  ViewController.swift
//  MorseChat
//
//  Created by William Wold on 7/11/16.
//  Copyright © 2016 Widap. All rights reserved.
//

import UIKit

class FriendsListViewController: UIViewController {

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	override func viewDidAppear(animated: Bool) {
		super.viewDidAppear(animated)
		
		
	}
}

extension FriendsListViewController: UITableViewDataSource {
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		
		return 2
	}
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
		
		/*//maybe It works as lazy load
		if indexPath.row >= postList.count {
			//self.tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: self.comments.count-1, inSection: 1)], withRowAnimation: UITableViewRowAnimation.Automatic)
		}
		
		//maybe It works as lazy load
		let cell = tableView.dequeueReusableCellWithIdentifier("cell") as! MainTableViewCell
		
		let post = postList[postList.count-indexPath.row-1]
		if post.picture == nil{
			FirebaseHelper.downloadImage(post) { (productImage) in
				//            print(productImage)
				//            cell.imageViewProduct.image = productImage
				post.picture = productImage
				tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
			}
		}
		cell.populate(post)
		*/
		let cell = tableView.dequeueReusableCellWithIdentifier("friendCell")!
		return cell
	}
}
