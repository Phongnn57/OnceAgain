//
//  FavoriteViewController.swift
//  1Again
//
//  Created by Nam Phong on 6/30/15.
//  Copyright (c) 2015 Phong Nguyen Nam. All rights reserved.
//

import UIKit


class FavoriteViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var menuBtn: UIBarButtonItem!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var tableview: UITableView!
    
    var refreshControl: UIRefreshControl!
    
    // DATA
    var items: [Item]!
    var sellers: [User]!
    
    var itemIsLoaded: Bool = false
    var sellerIsLoaded: Bool = false
    
    private let ItemListCellIdentifier = "ItemListCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.items = [Item]()
        self.sellers = [User]()
        setMenuButtonAction(menuBtn)
        self.refreshControl = UIRefreshControl()
        self.refreshControl.addTarget(self, action: "reloadData", forControlEvents: UIControlEvents.ValueChanged)
        self.tableview.addSubview(self.refreshControl)
        self.tableview.registerNib(UINib(nibName: ItemListCellIdentifier, bundle: nil), forCellReuseIdentifier: ItemListCellIdentifier)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if !self.itemIsLoaded {
            self.itemIsLoaded = true
            FavoriteAPI.getFavoriteListWithType("I", completion: { (responseData) -> Void in
                self.items = responseData as! [Item]
                self.tableview.reloadData()
                }) { (error) -> Void in
                    self.view.makeToast(error)
            }
        }
    }
    
    func reloadData() {
        if self.segmentControl.selectedSegmentIndex == 0 {
            FavoriteAPI.getFavoriteListWithType("I", completion: { (responseData) -> Void in
                self.items = responseData as! [Item]
                self.tableview.reloadData()
                self.refreshControl.endRefreshing()
                }) { (error) -> Void in
                    self.view.makeToast(error)
                    self.refreshControl.endRefreshing()
            }
        } else {
            FavoriteAPI.getFavoriteListWithType("U", completion: { (responseData) -> Void in
                self.sellers = responseData as! [User]
                self.tableview.reloadData()
                self.refreshControl.endRefreshing()
                }) { (error) -> Void in
                    self.view.makeToast(error)
                    self.refreshControl.endRefreshing()
            }
        }
    }
    
    @IBAction func segmentDidChangeIndex(sender: AnyObject) {
        if self.segmentControl.selectedSegmentIndex == 0 {
            self.tableview.reloadData()
        } else {
            if !self.sellerIsLoaded {
                self.sellerIsLoaded = true
                FavoriteAPI.getFavoriteListWithType("U", completion: { (responseData) -> Void in
                    self.sellers = responseData as! [User]
                    self.tableview.reloadData()
                    }) { (error) -> Void in
                        self.view.makeToast(error)
                }
            } else {
                self.tableview.reloadData()
            }
        }
    }
    
    // MARK: TABLE VIEW METHODS
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.segmentControl.selectedSegmentIndex == 0 {
            return self.items.count
        }
        return self.sellers.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if self.segmentControl.selectedSegmentIndex == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier(ItemListCellIdentifier) as! ItemListCell
            cell.configCellByItem(self.items[indexPath.row])
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.001
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if self.segmentControl.selectedSegmentIndex == 0 {
            let itemDetailViewController = ShopLocalDetailViewController()
            itemDetailViewController.tmpItemID = self.items[indexPath.row].itemID
            self.navigationController?.pushViewController(itemDetailViewController, animated: true)
        }
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            self.items.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [AnyObject]? {
        
        var moreRowAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "More", handler:{action, indexpath in
            let itemDetailViewController = ShopLocalDetailViewController()
            itemDetailViewController.tmpItemID = self.items[indexPath.row].itemID
            self.navigationController?.pushViewController(itemDetailViewController, animated: true)
            
        });
        moreRowAction.backgroundColor = UIColor(red: 0.298, green: 0.851, blue: 0.3922, alpha: 1.0);
        
        var deleteRowAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Delete", handler:{action, indexpath in
            
            var params: Dictionary<String, AnyObject> = Dictionary<String, AnyObject>()
            
            params = ["action": "0", "itemId": self.items[indexPath.row].itemID ?? "", "userId": User.sharedUser.userID, "type": "I"]
            
            ItemAPI.postItemWithParams(params, completion: { (object) -> Void in
                self.view.makeToast("SUCCESS")
                self.items.removeAtIndex(indexPath.row)
                self.tableview.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
                }) { (error) -> Void in
                    self.view.makeToast(error)
            }

            
        });
        
        return [deleteRowAction, moreRowAction];
    }
}
