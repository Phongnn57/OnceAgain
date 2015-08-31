//
//  NotificationItemViewController.swift
//  1Again
//
//  Created by Nguyen Nam Phong on 8/28/15.
//  Copyright (c) 2015 Phong Nguyen Nam. All rights reserved.
//

import UIKit

class NotificationItemViewController: BaseSubViewController, UITableViewDelegate, UITableViewDataSource, NotificationDetailViewControllerDelegate {
    
    let cellIdentifier = "NotificationCell"
    var refreshControl: UIRefreshControl!
    var notifications:[Notification]!
    var itemID: String!

    @IBOutlet weak var tableview: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.notifications = [Notification]()
        self.refreshControl = UIRefreshControl()
        self.refreshControl?.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        self.tableview.addSubview(self.refreshControl)
        self.tableview.registerNib(UINib(nibName: cellIdentifier, bundle: nil), forCellReuseIdentifier: cellIdentifier)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if self.notifications.count <= 0 {
            self.refresh("")
        }
    }
    
    // MARK: DELEGATE
    func didSelectButton(select: Bool, iid: String) {
        if select {
            for var i = 0; i < self.notifications.count; i++ {
                let noti = self.notifications[i]
                if noti.iid == iid {
                    self.notifications.removeAtIndex(i)
                    self.tableview.reloadData()
                    break
                }
            }
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.notifications.count
    }
    
    func refresh(sender:AnyObject){
        MRProgressOverlayView.showOverlayAddedTo(self.view, title: "", mode: MRProgressOverlayViewMode.IndeterminateSmall, animated: true)
        ItemAPI.getNotificationOfItem(self.itemID, completion: { (notifications) -> Void in
            MRProgressOverlayView.dismissOverlayForView(self.view, animated: true)
            self.notifications = notifications
            self.refreshControl?.endRefreshing()
            self.tableview.reloadData()
        }) { (error) -> Void in
            MRProgressOverlayView.dismissOverlayForView(self.view, animated: true)
            self.view.makeToast(error)
            self.refreshControl?.endRefreshing()
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as! NotificationCell
        
        var notification = self.notifications[indexPath.row]
        cell.configCellWithNotification(notification)
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let notificationDetailController = NotificationDetailViewController()
        notificationDetailController.IID = self.notifications[indexPath.row].iid
        notificationDetailController.itemID = self.notifications[indexPath.row].itemId
        notificationDetailController.delegate = self
        self.navigationController?.pushViewController(notificationDetailController, animated: true)
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 220
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.001
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            self.notifications.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [AnyObject]? {
        
        var moreRowAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "More", handler:{action, indexpath in
            let notificationDetailController = NotificationDetailViewController()
            notificationDetailController.IID = self.notifications[indexPath.row].iid
            notificationDetailController.itemID = self.notifications[indexPath.row].itemId
            notificationDetailController.delegate = self
            self.navigationController?.pushViewController(notificationDetailController, animated: true)
            
        });
        moreRowAction.backgroundColor = UIColor(red: 0.298, green: 0.851, blue: 0.3922, alpha: 1.0);
        
        var deleteRowAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "No Thanks!", handler:{action, indexpath in
            //   println("DELETE•ACTION");
            var notifications = Notification()
            notifications = self.notifications[indexPath.row]
            NotificationAPI.deleteNotification(notifications.iid!, completion: { () -> Void in
                self.notifications.removeAtIndex(indexPath.row)
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
                }, failure: { (error) -> Void in
                    self.view.makeToast(error)
            })
            
        });
        
        return [deleteRowAction, moreRowAction];
    }

}
