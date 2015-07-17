//
//  FavoriteViewController.swift
//  1Again
//
//  Created by Nam Phong on 6/30/15.
//  Copyright (c) 2015 Phong Nguyen Nam. All rights reserved.
//

import UIKit

class FavoriteObject {
    var items: [ItemObject]!
    var sellers: [UserObject]!
    
    init() {
        self.items = [ItemObject]()
        self.sellers = [UserObject]()
    }
}

class FavoriteViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var menuBtn: UIBarButtonItem!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var tableview: UITableView!
    
    var refreshControl: UIRefreshControl!
    
    // DATA
    var items: [ItemObject]!
    var sellers: [UserObject]!
    
    var itemIsLoaded: Bool = false
    var sellerIsLoaded: Bool = false
    
    private let ItemListCellIdentifier = "ItemListCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.items = [ItemObject]()
        self.sellers = [UserObject]()
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
                self.items = responseData as! [ItemObject]
                self.tableview.reloadData()
                }) { (error) -> Void in
                    self.view.makeToast(error)
            }
        }
    }
    
    func reloadData() {
        if self.segmentControl.selectedSegmentIndex == 0 {
            FavoriteAPI.getFavoriteListWithType("I", completion: { (responseData) -> Void in
                self.items = responseData as! [ItemObject]
                self.tableview.reloadData()
                self.refreshControl.endRefreshing()
                }) { (error) -> Void in
                    self.view.makeToast(error)
                    self.refreshControl.endRefreshing()
            }
        } else {
            FavoriteAPI.getFavoriteListWithType("U", completion: { (responseData) -> Void in
                self.sellers = responseData as! [UserObject]
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
                    self.sellers = responseData as! [UserObject]
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
            cell.configCellWithItem(self.items[indexPath.row])
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
            itemDetailViewController.tmpItemID = self.items[indexPath.row].id
            self.navigationController?.pushViewController(itemDetailViewController, animated: true)
        }
    }
}
