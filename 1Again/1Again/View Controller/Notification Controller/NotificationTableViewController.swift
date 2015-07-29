//
//  NotificationTableViewController.swift
//  1Again
//
//  Created by Nam Phong on 6/28/15.
//  Copyright (c) 2015 Phong Nguyen Nam. All rights reserved.
//

import UIKit

class NotificationTableViewController: UITableViewController {

    @IBOutlet weak var menuBtn: UIBarButtonItem!
    
    let cellIdentifier = "NotificationCell"
    
    var notificationsArray =  [Notification]()
    var tempNnotifications = Notification()
    var imageCache = [String: UIImage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.revealViewController() != nil {
            menuBtn.target = self.revealViewController()
            menuBtn.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        self.refreshControl?.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.registerNib(UINib(nibName: cellIdentifier, bundle: nil), forCellReuseIdentifier: cellIdentifier)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if notificationsArray.count <= 0 {
            self.refresh("")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notificationsArray.count
    }
    
    func refresh(sender:AnyObject)
    {
        NotificationAPI.getNotificationListWithUser(User.sharedUser.userID, completion: { (result) -> Void in
            self.notificationsArray = result
            self.tableView.reloadData()
            self.refreshControl?.endRefreshing()
            }, failure: { (error) -> Void in
                self.view.makeToast(error)
                self.refreshControl?.endRefreshing()
        })
    }
    
    
    @IBAction func sortButtonTapped(sender: AnyObject) {
        let actionSheet = UIAlertController(title: "Select Sort Order", message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "User Name △", style: UIAlertActionStyle.Default, handler: { (alert:UIAlertAction!) -> Void in
            //    println("sort by item name tapped")
            self.sortList("name", order: "A")
        }))
        
        actionSheet.addAction(UIAlertAction(title: "User Name ▽", style: UIAlertActionStyle.Default, handler: { (alert:UIAlertAction!) -> Void in
            //        println("sort by item name tapped")
            self.sortList("name", order: "D")
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Item Name △", style: UIAlertActionStyle.Default, handler: { (alert:UIAlertAction!) -> Void in
            //  println("sort by item name tapped")
            self.sortList("title", order: "A")
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Item Name ▽", style: UIAlertActionStyle.Default, handler: { (alert:UIAlertAction!) -> Void in
            //   println("sort by item name tapped")
            self.sortList("title", order: "D")
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Category △", style: UIAlertActionStyle.Default, handler: { (alert:UIAlertAction!) -> Void in
            //  println("sort by item name tapped")
            self.sortList("category", order: "A")
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Category ▽", style: UIAlertActionStyle.Default, handler: { (alert:UIAlertAction!) -> Void in
            //  println("sort by item name tapped")
            self.sortList("category", order: "D")
        }))
        //        actionSheet.addAction(UIAlertAction(title: "Response △", style: UIAlertActionStyle.Default, handler: { (alert:UIAlertAction!) -> Void in
        //            //  println("sort by item name tapped")
        //            self.sortList("response", order: "A")
        //        }))
        //
        //        actionSheet.addAction(UIAlertAction(title: "Response ▽", style: UIAlertActionStyle.Default, handler: { (alert:UIAlertAction!) -> Void in
        //            //  println("sort by item name tapped")
        //            self.sortList("response", order: "D")
        //        }))
        
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
        
        self.presentViewController(actionSheet, animated: true, completion: nil)
    }
    
    func sortList(field:String, order:String) { // should probably be called sort and not filter
        
        switch (field, order) {
        case ("name", "A"):
            notificationsArray.sort() { $0.displayName < $1.displayName } // sort the fruit by name ASC
        case ("name","D"):
            notificationsArray.sort() { $0.displayName > $1.displayName } // sort the fruit by name DESC
        case ("title", "A"):
            notificationsArray.sort() { $0.title < $1.title } // sort the fruit by title ASC
        case ("title","D"):
            notificationsArray.sort() { $0.title > $1.title } // sort the fruit by title DESC
        case ("category", "A"):
            notificationsArray.sort() { $0.category < $1.category } // sort the fruit by distance ASC
        case ("category","D"):
            notificationsArray.sort() { $0.category > $1.category } // sort the fruit by distance DESC
        case ("response", "A"):
            notificationsArray.sort() { $0.status < $1.status } // sort the fruit by distance ASC
        case ("response","D"):
            notificationsArray.sort() { $0.status > $1.status } // sort the fruit by distance DESC
        default:
            break;
        }
        
        tableView.reloadData(); // notify the table view the data has changed
        
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as! NotificationCell
        
        var notification = notificationsArray[indexPath.row]
        cell.configCellWithNotification(notification)
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let notificationDetailController = NotificationDetailViewController()
        notificationDetailController.IID = self.notificationsArray[indexPath.row].iid
        notificationDetailController.itemID = self.notificationsArray[indexPath.row].itemId
        self.navigationController?.pushViewController(notificationDetailController, animated: true)
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 220
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            notificationsArray.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }
    
    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [AnyObject]? {
        
        var moreRowAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "More", handler:{action, indexpath in
            self.tempNnotifications = self.notificationsArray[indexPath.row]
            let notificationDetailController = NotificationDetailViewController()
            notificationDetailController.IID = self.notificationsArray[indexPath.row].iid
            notificationDetailController.itemID = self.notificationsArray[indexPath.row].itemId
            self.navigationController?.pushViewController(notificationDetailController, animated: true)
            
        });
        moreRowAction.backgroundColor = UIColor(red: 0.298, green: 0.851, blue: 0.3922, alpha: 1.0);
        
        var deleteRowAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "No Thanks!", handler:{action, indexpath in
            //   println("DELETE•ACTION");
            var notifications = Notification()
            notifications = self.notificationsArray[indexPath.row]
            NotificationAPI.deleteNotification(notifications.iid!, completion: { () -> Void in
                self.notificationsArray.removeAtIndex(indexPath.row)
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            }, failure: { (error) -> Void in
                self.view.makeToast(error)
            })
            
        });
        
        return [deleteRowAction, moreRowAction];
    }

}
