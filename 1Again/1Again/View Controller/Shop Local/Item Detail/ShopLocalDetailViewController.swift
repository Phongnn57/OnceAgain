//
//  ShopLocalDetailViewController.swift
//  1Again
//
//  Created by Nam Phong on 7/2/15.
//  Copyright (c) 2015 Phong Nguyen Nam. All rights reserved.
//

import UIKit

class ShopLocalDetailViewController: BaseSubViewController, UITableViewDelegate, UITableViewDataSource, MBProgressHUDDelegate {
    
    @IBOutlet weak var tableview: UITableView!
    
    private let firstCellIdentifier = "ShopLocalFirstCell"
    private let secondCellIdentifier = "ShopLocalSecondCell"
    private let thirdCellIdentifier = "ShopLocalThirdCell"
    private let commentCellIdentifier = "CommentCell"
    private let addnewComment = "AddNewCommentCell"
    
    var hud: MBProgressHUD!
    var tmpItemID: String!
    var item: ItemObject!
    var comments: [CommentObject]!
    var shouldShowPrice: Bool = false

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableview.registerNib(UINib(nibName: firstCellIdentifier, bundle: nil), forCellReuseIdentifier: firstCellIdentifier)
        self.tableview.registerNib(UINib(nibName: secondCellIdentifier, bundle: nil), forCellReuseIdentifier: secondCellIdentifier)
        self.tableview.registerNib(UINib(nibName: thirdCellIdentifier, bundle: nil), forCellReuseIdentifier: thirdCellIdentifier)
        self.tableview.registerNib(UINib(nibName: commentCellIdentifier, bundle: nil), forCellReuseIdentifier: commentCellIdentifier)
        self.tableview.registerNib(UINib(nibName: addnewComment, bundle: nil), forCellReuseIdentifier: addnewComment)
        self.tableview.alpha = 0
        
        self.comments = [CommentObject]()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.showHUD()
        ItemAPI.getItem("480", completion: { (item) -> Void in
            self.item = item
            self.tableview.alpha = 1
            self.tableview.reloadData()
            self.hideHUD()
        }) { (error) -> Void in
            print(error)
            self.hideHUD()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func showHUD() {
        self.hud = MBProgressHUD(view: self.view)
        self.hud.delegate = self
        self.hud.labelText = "Loading"
        self.view.addSubview(self.hud)
        self.hud.show(true)
    }
    
    func hideHUD() {
        self.hud.hide(true)
        self.hud.removeFromSuperview()
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 5
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section != 3 {
            return 1
        }
        return self.comments.count + 5
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier(firstCellIdentifier) as! ShopLocalFirstCell
            if self.item != nil { cell.showDataFromItem(self.item)}
            return cell
        } else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCellWithIdentifier(secondCellIdentifier) as! ShopLocalSecondCell
            
            return cell
        } else if indexPath.section == 2 {
            let cell = tableView.dequeueReusableCellWithIdentifier(thirdCellIdentifier) as! ShopLocalThirdCell
            if self.item != nil {cell.showDataFromItem(self.item)}
            return cell
        } else if indexPath.section == 3 {
            let cell = tableView.dequeueReusableCellWithIdentifier(commentCellIdentifier) as! CommentCell
            
            return cell
        } else if indexPath.section == 4 {
            let cell = tableView.dequeueReusableCellWithIdentifier(addnewComment) as! AddNewCommentCell
            
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0 {return UIScreen.mainScreen().bounds.width * 3/4 + 300}
        else if indexPath.section == 1 {
//            if shouldShowPrice {
//                return 55
//            } else {
//                return 0
//            }
            return 55
        }
        else if indexPath.section == 2 {return 220}
        else if indexPath.section == 3 || indexPath.section == 4 {return 60}
        
        return 0
    }
}