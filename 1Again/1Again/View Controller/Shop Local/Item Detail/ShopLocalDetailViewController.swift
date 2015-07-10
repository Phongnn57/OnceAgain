//
//  ShopLocalDetailViewController.swift
//  1Again
//
//  Created by Nam Phong on 7/2/15.
//  Copyright (c) 2015 Phong Nguyen Nam. All rights reserved.
//

import UIKit

class ShopLocalDetailViewController: BaseSubViewController, UITableViewDelegate, UITableViewDataSource, MBProgressHUDDelegate, ShopLocalFirstCellDelegate, AddNewCommentCellDelegate, UIScrollViewDelegate {
    
    @IBOutlet weak var tableview: UITableView!
    
    private let firstCellIdentifier = "ShopLocalFirstCell"
    private let secondCellIdentifier = "ShopLocalSecondCell"
    private let thirdCellIdentifier = "ShopLocalThirdCell"
    private let commentCellIdentifier = "CommentCell"
    private let addnewComment = "AddNewCommentCell"
    private let collectionCellIdentifier = "MyCollectionViewCell"
    
    var hud: MBProgressHUD!
    var tmpItemID: String!
    var item: ItemObject!
    var comments: [CommentObject]!
    var shouldShowPriceCell: Bool = false
    var imageURLs:[String]! = []

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableview.registerNib(UINib(nibName: firstCellIdentifier, bundle: nil), forCellReuseIdentifier: firstCellIdentifier)
        self.tableview.registerNib(UINib(nibName: secondCellIdentifier, bundle: nil), forCellReuseIdentifier: secondCellIdentifier)
        self.tableview.registerNib(UINib(nibName: thirdCellIdentifier, bundle: nil), forCellReuseIdentifier: thirdCellIdentifier)
        self.tableview.registerNib(UINib(nibName: commentCellIdentifier, bundle: nil), forCellReuseIdentifier: commentCellIdentifier)
        self.tableview.registerNib(UINib(nibName: addnewComment, bundle: nil), forCellReuseIdentifier: addnewComment)
        self.tableview.alpha = 0
        self.tableview.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "endEditing"))
        self.comments = [CommentObject]()
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.showHUD()
        ItemAPI.getItem(self.tmpItemID, completion: { (item) -> Void in
            self.item = item
            self.getImageURLs(item)
            self.tableview.alpha = 1
            self.tableview.reloadData()
            self.hideHUD()
        }) { (error) -> Void in
            self.hideHUD()
        }
        
        self.updateComment()
    }
    
    func getImageURLs(item: ItemObject) {
        if item.imageStr1 != nil && item.imageStr1 != "" {
            self.imageURLs.append(item.imageStr1)
        }
        if item.imageStr2 != nil && item.imageStr2 != "" {
            self.imageURLs.append(item.imageStr2)
        }
        if item.imageStr3 != nil && item.imageStr3 != "" {
            self.imageURLs.append(item.imageStr3)
        }
        if item.imageStr4 != nil && item.imageStr4 != "" {
            self.imageURLs.append(item.imageStr4)
        }
        if item.imageStr5 != nil && item.imageStr5 != "" {
            self.imageURLs.append(item.imageStr5)
        }
    }

    func endEditing() {
        self.tableview.endEditing(true)
    }
    
    func updateComment() {
        CommentAPI.getAllComment(self.tmpItemID, completion: { (comments) -> Void in
            print("Success get comment: \(comments.count)")
            self.tableview.alpha = 1
            self.comments = comments
            self.tableview.reloadSections(NSIndexSet(index: 2), withRowAnimation: .None)
            }) { (error) -> Void in
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
        return 3
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            if self.shouldShowPriceCell {
                return 2
            } else {
                return 1
            }
        }
        if section == 1 {
            return 1
        }
        return self.comments.count + 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCellWithIdentifier(firstCellIdentifier) as! ShopLocalFirstCell
                cell.delegate = self
                cell.imageURLs = self.imageURLs
                cell.collectionview.reloadData()
                if self.item != nil { cell.showDataFromItem(self.item)}
                return cell
            } else if indexPath.row == 1 {
                let cell = tableView.dequeueReusableCellWithIdentifier(secondCellIdentifier) as! ShopLocalSecondCell
                
                return cell
            }
        } else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCellWithIdentifier(thirdCellIdentifier) as! ShopLocalThirdCell
            if self.item != nil {cell.showDataFromItem(self.item)}
            return cell
        } else if indexPath.section == 2 {
            if indexPath.row == self.comments.count {
                let cell = tableView.dequeueReusableCellWithIdentifier(addnewComment) as! AddNewCommentCell
                cell.delegate = self
                return cell
            } else {
                let cell = tableView.dequeueReusableCellWithIdentifier(commentCellIdentifier) as! CommentCell
                cell.setupCellWithComment(self.comments[indexPath.row])
                return cell
            }
        }
        return UITableViewCell()
    }

    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                return UIScreen.mainScreen().bounds.width + 240
            } else {return 66}
        }
        else if indexPath.section == 1 {return 220}
        else if indexPath.section == 2 {return 60}
        return 0
    }
    
    //DELEGATE
    func didChangeFavorite(cell: ShopLocalFirstCell) {
        var params: Dictionary<String, String> = Dictionary<String, String>()
        if cell.like {
            params["action"] = "1"
        } else {
            params["action"] = "0"
        }
        params["itemId"] = self.item.id
        params["userId"] = "\(USER_ID)"
        params["type"] = "I"
        
        self.postToServer("V5.favorite_item_insert_ac.php", params: params)
    }
    
    func didSelectMakeOfferButton(cell: ShopLocalFirstCell) {
        self.shouldShowPriceCell = !self.shouldShowPriceCell
        self.tableview.beginUpdates()
        self.tableview.reloadSections(NSIndexSet(index: 0), withRowAnimation: .None)
        self.tableview.endUpdates()
    }
    
    func doPostComment(cell: AddNewCommentCell) {
        CommentAPI.postComment(self.tmpItemID, displayName:self.item.displayName, comment: cell.comment.text, completion: { (object) -> Void in
            self.updateComment()
            cell.comment.text = nil
            }) { (error) -> Void in
                print(error)
        }
    }
    
    func didSelectIWillTakeItButton(cell: ShopLocalFirstCell) {
        
        var params: Dictionary<String, String> = Dictionary<String, String>()
        params["userId"] = "\(USER_ID)"
        params["itemId"] = self.item.id
        params["ownerId"] = "\(item.ownerId)"
        params["action"] = "I"
        params["distance"] = self.item.miles
        
        self.postToServer("V5.notification_insert_ac.php", params: params)
        
    }
    
    func postToServer(url: String, params: Dictionary<String, String>) {
        ModelManager.shareManager.postRequest(url, params: params , success: { (responseData) -> Void in
            let alertView = UIAlertView(title: "Submitted", message: "Your offer was made. You should hear back shortly.", delegate: self, cancelButtonTitle: "OK")
            alertView.show()
            }) { (error) -> Void in
                print(error)
        }
    }
    
    //KEYBOARD HANDLE
    func keyboardWillShow(notification: NSNotification) {
        let userInfo = notification.userInfo!
        let keyboardSize = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
        
        let contentInsets = UIEdgeInsetsMake(0, 0, keyboardSize.size.height, 0)
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.tableview.contentInset = contentInsets
            self.tableview.scrollIndicatorInsets = contentInsets
        })
    }
    
    func keyboardWillHide(notification: NSNotification!) {
        let contentInsets = UIEdgeInsetsZero
        
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.tableview.contentInset = contentInsets
            self.tableview.scrollIndicatorInsets = contentInsets
        })
    }
    
//    //MARK: COLLECTION VIEW
//    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        if self.imageURLs != nil {
//            return self.imageURLs.count
//        }
//        return 0
//    }
//    
//    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
//        let cell: MyCollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier(collectionCellIdentifier, forIndexPath: indexPath) as! MyCollectionViewCell
//        cell.imageview.sd_setImageWithURL(NSURL(string: self.imageURLs[indexPath.row]), placeholderImage: UIImage(named: "image:add-item-camera"))
//        return cell
//    }
}