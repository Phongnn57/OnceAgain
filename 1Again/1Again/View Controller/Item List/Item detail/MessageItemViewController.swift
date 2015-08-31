//
//  MessageItemViewController.swift
//  1Again
//
//  Created by Nam Phong Nguyen on 8/27/15.
//  Copyright (c) 2015 Phong Nguyen Nam. All rights reserved.
//

import UIKit

class MessageItemViewController: BaseSubViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableview: UITableView!
    var refreshControl: UIRefreshControl!
    var messagesArray =  [Message]()
    var tempMessages = Message()
    private let cellIdentifier = "MessageCell"
    var firstLoad: Bool = true
    
    var itemID: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableview.registerNib(UINib(nibName: cellIdentifier, bundle: nil), forCellReuseIdentifier: cellIdentifier)
        self.refreshControl = UIRefreshControl()
        self.refreshControl?.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        self.tableview.addSubview(self.refreshControl)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if self.firstLoad {
            self.firstLoad = false
            MRProgressOverlayView.showOverlayAddedTo(self.view, title: "Loading...", mode: MRProgressOverlayViewMode.IndeterminateSmall, animated: true)
            self.loadData()
        }
        self.tableview.reloadData()
    }

    func loadData() {
        MessageAPI.getMessageOfItem(self.itemID, completion: { (result) -> Void in
            self.messagesArray = result
            self.tableview.reloadData()
            self.tableview.alpha = 1
            MRProgressOverlayView.dismissOverlayForView(self.view, animated: true)
            self.refreshControl?.endRefreshing()
            }, failure: { (error) -> Void in
                self.view.makeToast(error)
                self.refreshControl?.endRefreshing()
                MRProgressOverlayView.dismissOverlayForView(self.view, animated: true)
        })
    }
    
    func refresh(sender:AnyObject)
    {
        self.loadData()
    }
    
    // MARK: - Table view data source
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messagesArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
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
    
     func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let chatViewController = ChatViewController()
        chatViewController.imd = self.messagesArray[indexPath.row].iid
        chatViewController.receiverID = self.messagesArray[indexPath.row].entityId
        chatViewController.displayName = self.messagesArray[indexPath.row].displayName
        chatViewController.senderID = self.messagesArray[indexPath.row].id
        chatViewController.itemID = self.messagesArray[indexPath.row].itemId
        self.messagesArray[indexPath.row].newIndicator = 0
        self.navigationController?.pushViewController(chatViewController, animated: true)
    }
    
     func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 75
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
            messagesArray.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }
    
     func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [AnyObject]? {
        
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
                self.tableview.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
                }, failure: { (error) -> Void in
                    self.view.makeToast(error)
            })
        });
        
        return [deleteRowAction, moreRowAction];
    }

}
