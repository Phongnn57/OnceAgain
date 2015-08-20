//
//  MenuController.swift
//  1Again
//
//  Created by Nam Phong on 6/26/15.
//  Copyright (c) 2015 Phong Nguyen Nam. All rights reserved.
//

import UIKit

class MenuController: UITableViewController {

    var hideNotification: Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBarHidden = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if User.sharedUser.userType == "P" {
            hideNotification = true
        } else {
            hideNotification = false
        }
        tableView.reloadData()
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if hideNotification == true {return 10}
        else {return 11}
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if hideNotification == true {
            if indexPath.row <= 2 {
                return super.tableView(tableView, cellForRowAtIndexPath: indexPath)
            } else {
                return super.tableView(tableView, cellForRowAtIndexPath: NSIndexPath(forRow: indexPath.row + 1, inSection: 0))
            }
        } else {
            return super.tableView(tableView, cellForRowAtIndexPath: indexPath)
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if (hideNotification == true && indexPath.row == 9) || (hideNotification == false && indexPath.row == 10){
            User.sharedUser.userID = ""
            User.sharedUser.saveOffline()
            SDWebImageManager.sharedManager().imageCache.clearDisk()
            SDWebImageManager.sharedManager().imageCache.clearMemory()
        }
    }
}
