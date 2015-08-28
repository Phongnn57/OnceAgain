//
//  MessageTableViewController.swift
//  1Again
//
//  Created by Nam Phong on 7/1/15.
//  Copyright (c) 2015 Phong Nguyen Nam. All rights reserved.
//

import UIKit

class MessageTableViewController: UITableViewController, MBProgressHUDDelegate {

    @IBOutlet weak var menuBtn: UIBarButtonItem!
    
    var messagesArray =  [Message]()
    var tempMessages = Message()
    private let cellIdentifier = "MessageCell"
    var hud: MBProgressHUD!
    var firstLoad: Bool = true
    
    var itemID: String!
    var oneItem: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.registerNib(UINib(nibName: cellIdentifier, bundle: nil), forCellReuseIdentifier: cellIdentifier)
        self.refreshControl?.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidAppear(animated: Bool) {
        if self.revealViewController() != nil {
            menuBtn.target = self.revealViewController()
            menuBtn.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        super.viewDidAppear(animated)
        if self.firstLoad {
            self.firstLoad = false
//            self.tableView.alpha = 0
            
            MRProgressOverlayView.showOverlayAddedTo(self.view, title: "Loading...", mode: MRProgressOverlayViewMode.IndeterminateSmall, animated: true)
            self.loadData()
        }
        self.tableView.reloadData()
    }
    
    func loadData() {
        if self.oneItem {
            MessageAPI.getMessageOfItem(self.itemID, completion: { (result) -> Void in
                self.messagesArray = result
                self.tableView.reloadData()
                self.tableView.alpha = 1
                MRProgressOverlayView.dismissOverlayForView(self.view, animated: true)
                self.refreshControl?.endRefreshing()
            }, failure: { (error) -> Void in
                self.view.makeToast(error)
                self.refreshControl?.endRefreshing()
                MRProgressOverlayView.dismissOverlayForView(self.view, animated: true)
            })
        } else {
            MessageAPI.getMessages({ (result) -> Void in
                self.messagesArray = result
                self.tableView.reloadData()
                self.tableView.alpha = 1
                MRProgressOverlayView.dismissOverlayForView(self.view, animated: true)
                self.refreshControl?.endRefreshing()
                }, failure: { (error) -> Void in
                    self.view.makeToast(error)
                    self.refreshControl?.endRefreshing()
                    MRProgressOverlayView.dismissOverlayForView(self.view, animated: true)
            })
        }
    }
    
    func refresh(sender:AnyObject)
    {
        self.loadData()
    }

    // MARK: - Table view data source

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messagesArray.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as! MessageCell
        
        let msg = messagesArray[indexPath.row]
        
        cell.timestamp.text = msg.timestamp
        cell.user.text = msg.displayName
        cell.title.text = msg.title
        
        cell.image1.sd_setImageWithURL(NSURL(string: Constant.MyUrl.ImageURL + msg.image1!), placeholderImage: UIImage(named: "demo_avatar"))
        
        if msg.newIndicator == 1 {
            cell.newLB.hidden = false
        } else {
            cell.newLB.hidden = true
        }
        
        let status: String = msg.status  ?? ""
        switch (status) {
        case ("X"):
            cell.imageview.image = UIImage(named: "image:message-red-delete")
        case ("Y"):
            cell.imageview.image =  UIImage(named: "image:message-green-check")
        case ("F"):
            cell.imageview.image =  UIImage(named: "image:message-favorite")
        case ("O"):
            cell.imageview.image =  UIImage(named: "image:message-offer")
        case ("I"):
            cell.imageview.image =  UIImage(named: "image:message-dollar")
        case ("N"):
            cell.imageview.image =  UIImage(named: "image:message-new")
        default:
            break;
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let chatViewController = ChatViewController()
        chatViewController.imd = self.messagesArray[indexPath.row].iid
        chatViewController.receiverID = self.messagesArray[indexPath.row].entityId
        chatViewController.displayName = self.messagesArray[indexPath.row].displayName
        chatViewController.senderID = self.messagesArray[indexPath.row].id
        chatViewController.itemID = self.messagesArray[indexPath.row].itemId
        self.messagesArray[indexPath.row].newIndicator = 0
        self.navigationController?.pushViewController(chatViewController, animated: true)
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 75
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.001
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
            let chatViewController = ChatViewController()
            chatViewController.imd = self.messagesArray[indexPath.row].iid
            chatViewController.receiverID = self.messagesArray[indexPath.row].entityId
            chatViewController.displayName = self.messagesArray[indexPath.row].displayName
            chatViewController.senderID = self.messagesArray[indexPath.row].id
            chatViewController.itemID = self.messagesArray[indexPath.row].itemId
            self.messagesArray[indexPath.row].newIndicator = 0
            self.navigationController?.pushViewController(chatViewController, animated: true)
        });
        moreRowAction.backgroundColor = UIColor(red: 0.298, green: 0.851, blue: 0.3922, alpha: 1.0);
        
        var deleteRowAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Delete", handler:{action, indexpath in
            //   println("DELETE•ACTION");
            var message = Message()
            message  = self.messagesArray[indexPath.row]
            
            MessageAPI.deleteMessage(message.iid!, completion: { (result) -> Void in
                self.messagesArray.removeAtIndex(indexPath.row)
                self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            }, failure: { (error) -> Void in
                self.view.makeToast(error)
            })
        });
        
        return [deleteRowAction, moreRowAction];
    }
}