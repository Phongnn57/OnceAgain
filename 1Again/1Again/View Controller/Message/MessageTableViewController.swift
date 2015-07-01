//
//  MessageTableViewController.swift
//  1Again
//
//  Created by Nam Phong on 7/1/15.
//  Copyright (c) 2015 Phong Nguyen Nam. All rights reserved.
//

import UIKit

class MessageTableViewController: UITableViewController {

    
    @IBOutlet weak var menuBtn: UIBarButtonItem!
    
    var messagesArray =  [MessageObject]()
    var tempMessages = MessageObject()
    private let cellIdentifier = "MessageCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if self.revealViewController() != nil {
            menuBtn.target = self.revealViewController()
            menuBtn.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        tableView.registerNib(UINib(nibName: cellIdentifier, bundle: nil), forCellReuseIdentifier: cellIdentifier)
        self.refreshControl?.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        MessageObject.getListOfMessages("\(NSUserDefaults.standardUserDefaults().integerForKey(Constant.UserDefaultKey.activeUserId))", completionClosure: { (msgObjects) -> () in
            self.messagesArray = msgObjects
            self.tableView.reloadData()
        })

    }
    
    func refresh(sender:AnyObject)
    {
        // Updating your data here...
        MessageObject.getListOfMessages("\(NSUserDefaults.standardUserDefaults().integerForKey(Constant.UserDefaultKey.activeUserId))", completionClosure: { (msgObjects) -> () in
            self.messagesArray = msgObjects
            self.tableView.reloadData()
        })
        self.refreshControl?.endRefreshing()
    }

    // MARK: - Table view data source

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messagesArray.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as! MessageCell
        
        let msg = messagesArray[indexPath.row]
        
        cell.timestamp.text = msg.timestamp
        cell.user.text = msg.name
        cell.title.text = msg.title
        
        switch (msg.status) {
        case ("X"):
            cell.imageview.image = UIImage(named: "red.x.png")
        case ("Y"):
            cell.imageview.image =  UIImage(named: "green.check.png")
        case ("F"):
            cell.imageview.image =  UIImage(named: "favorite.png")
        case ("O"):
            cell.imageview.image =  UIImage(named: "offer.jpeg")
        case ("I"):
            cell.imageview.image =  UIImage(named: "dollar_sign1.jpg")
        case ("N"):
            cell.imageview.image =  UIImage(named: "new2.jpeg")
        default:
            break;
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 75
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            messagesArray.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }
    
    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [AnyObject]? {
        
        var moreRowAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "More", handler:{action, indexpath in
            self.tempMessages = self.messagesArray[indexPath.row]
            self.performSegueWithIdentifier("goto_notification_detail", sender: self)
            println("MORE•ACTION");
            
        });
        moreRowAction.backgroundColor = UIColor(red: 0.298, green: 0.851, blue: 0.3922, alpha: 1.0);
        
        var deleteRowAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Delete", handler:{action, indexpath in
            //   println("DELETE•ACTION");
            var message = MessageObject()
            message  = self.messagesArray[indexPath.row]
            MessageObject.deleteMessage(message.iid)
            self.messagesArray.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        });
        
        return [deleteRowAction, moreRowAction];
    }


}
