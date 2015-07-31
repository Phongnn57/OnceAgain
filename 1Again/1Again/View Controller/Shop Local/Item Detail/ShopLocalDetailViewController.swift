//
//  ShopLocalDetailViewController.swift
//  1Again
//
//  Created by Nam Phong on 7/2/15.
//  Copyright (c) 2015 Phong Nguyen Nam. All rights reserved.
//

import UIKit

class ShopLocalDetailViewController: BaseSubViewController, UITableViewDelegate, UITableViewDataSource, MBProgressHUDDelegate, ShopLocalFirstCellDelegate, AddNewCommentCellDelegate, ShopLocalSecondCellDelegate, UITextFieldDelegate , ShopLocalThirdCellDelegate{
    
    @IBOutlet weak var tableview: UITableView!
    
    private let firstCellIdentifier = "ShopLocalFirstCell"
    private let secondCellIdentifier = "ShopLocalSecondCell"
    private let thirdCellIdentifier = "ShopLocalThirdCell"
    private let commentCellIdentifier = "CommentCell"
    private let addnewComment = "AddNewCommentCell"
    private let collectionCellIdentifier = "MyCollectionViewCell"
    
    var toolBar: UIToolbar!
    var tmpItemID: String!
    var item: Item!
    var comments: [CommentObject]!
    var shouldShowPriceCell: Bool = false
    var imageURLs:[String]! = []
    var tmpPrice: String! = ""

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
        self.initializeToolbar()
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
    
    func initializeToolbar() {
        toolBar = UIToolbar(frame: CGRectMake(0, 0, self.view.frame.size.width, 50))
        toolBar.barStyle = UIBarStyle.BlackTranslucent
        var doneBtn = UIBarButtonItem(title: "Done", style: .Bordered, target: self, action: "endEditing")
        toolBar.items = NSArray(objects: UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil),doneBtn) as [AnyObject]
    }

    func getImageURLs(item: Item) {
        if item.imageStr1 != nil && item.imageStr1 != "" {
            self.imageURLs.append(item.imageStr1!)
        }
        if item.imageStr2 != nil && item.imageStr2 != "" {
            self.imageURLs.append(item.imageStr2!)
        }
        if item.imageStr3 != nil && item.imageStr3 != "" {
            self.imageURLs.append(item.imageStr3!)
        }
        if item.imageStr4 != nil && item.imageStr4 != "" {
            self.imageURLs.append(item.imageStr4!)
        }
        if item.imageStr5 != nil && item.imageStr5 != "" {
            self.imageURLs.append(item.imageStr5!)
        }
    }

    func endEditing() {
        self.tableview.endEditing(true)
        self.keyboardWillHide(nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    //MARK: HANDLE DATA
    func updateComment() {
        CommentAPI.getAllComment(self.tmpItemID, completion: { (comments) -> Void in
            print("Success get comment: \(comments.count)")
            self.tableview.alpha = 1
            self.comments = comments
            self.tableview.reloadSections(NSIndexSet(index: 2), withRowAnimation: .None)
            }) { (error) -> Void in
        }
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
                cell.price.inputAccessoryView = self.toolBar
                cell.delegate = self
                cell.price.delegate = self
                return cell
            }
        } else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCellWithIdentifier(thirdCellIdentifier) as! ShopLocalThirdCell
            cell.delegate = self
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

    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "ITEM INFORMATIONS"
        } else if section == 1 {
            return "DETAILS"
        } else {
            return "REVIEWS"
        }
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
                return UIScreen.mainScreen().bounds.width * 0.75 + 240
            } else {return 66}
        }
        else if indexPath.section == 1 {return 220}
        else if indexPath.section == 2 {return 44}
        return 0
    }
    
    //DELEGATE
    
    func didSelectFavorite(cell: ShopLocalThirdCell) {
        if self.item.favOwner == "1" {
            self.item.favOwner = "0"
        } else {
            self.item.favOwner = "1"
        }
        cell.showDataFromItem(self.item)
        var params: Dictionary<String, AnyObject> = Dictionary<String, AnyObject>()
        params = ["action": self.item.favOwner ?? "0", "itemId": self.item.ownerID ?? "", "userId": User.sharedUser.userID, "type": "U"]
        
        ItemAPI.postItemWithParams(params, completion: { (object) -> Void in
            self.view.makeToast("Success")
        }) { (error) -> Void in
            self.view.makeToast(error)
        }
    }
    
    func didSelectOfferBtn(cell: ShopLocalSecondCell) {
        var params: Dictionary<String, String> = Dictionary<String, String>()
        params["userId"] = User.sharedUser.userID
        params["itemId"] = self.item.itemID ?? ""
        params["ownerId"] = self.item.ownerID ?? ""
        params["action"] = "O"
        params["distance"] = self.item.miles
        params["price"] = "\(formatCurrency(self.tmpPrice))"

        
        ItemAPI.takeItem(params, completion: { (object) -> Void in
            let alert = UIAlertView(title: "Success", message: "Your offer was made. You should hear back shortly.", delegate: self, cancelButtonTitle: "OK")
            self.shouldShowPriceCell = false
            self.tableview.reloadData()
            alert.show()
            }) { (error) -> Void in
                self.view.makeToast(error)
        }
    }
    
    func didChangeFavorite(cell: ShopLocalFirstCell) {
        
        if self.item.favItem == "1" {
            self.item.favItem = "0"
        } else {
            self.item.favItem = "1"
        }
        
        cell.showDataFromItem(self.item)
        
        var params: Dictionary<String, AnyObject> = Dictionary<String, AnyObject>()

        params = ["action": self.item.favItem ?? "0", "itemId": self.item.itemID ?? "", "userId": User.sharedUser.userID, "type": "I"]

        ItemAPI.postItemWithParams(params, completion: { (object) -> Void in
            self.view.makeToast("SUCCESS")
        }) { (error) -> Void in
            self.view.makeToast(error)
        }
    }
    
    func didSelectMakeOfferButton(cell: ShopLocalFirstCell) {
        self.shouldShowPriceCell = !self.shouldShowPriceCell
        self.tableview.beginUpdates()
        self.tableview.reloadSections(NSIndexSet(index: 0), withRowAnimation: .None)
        self.tableview.endUpdates()
    }
    
    func doPostComment(cell: AddNewCommentCell) {
        CommentAPI.postComment(self.item.itemID!, displayName:self.item.displayName!, comment: cell.comment.text, completion: { (object) -> Void in
            print("SUCCESS")
            self.updateComment()
            cell.comment.text = nil
            }) { (error) -> Void in
                print("ERROR: \(error)")
        }
    }
    
    func didSelectIWillTakeItButton(cell: ShopLocalFirstCell) {
        var params: Dictionary<String, String> = Dictionary<String, String>()
        params["userId"] = User.sharedUser.userID
        params["itemId"] = self.item.itemID ?? ""
        params["ownerId"] = self.item.ownerID ?? ""
        params["action"] = "I"
        params["distance"] = self.item.miles
        println(params)
        
        ItemAPI.takeItem(params, completion: { (object) -> Void in
            let alert = UIAlertView(title: "Success", message: "Your offer was made. You should hear back shortly.", delegate: self, cancelButtonTitle: "OK")
            alert.show()
        }) { (error) -> Void in
            self.view.makeToast(error)
        }
    }
    
    //TEXTFIELD
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        if string == "\n" {
            textField.resignFirstResponder()
            return false
        }
        if textField.tag == Constant.TextFieldTag.ItemDetailPriceTextField {
            switch string {
            case "0","1","2","3","4","5","6","7","8","9":
                
                self.tmpPrice  = self.tmpPrice.stringByAppendingString(string)
                println("CURRENT STRING: \(self.tmpPrice)")
                textField.text =  "\(getFormatCurrency(self.tmpPrice))"
            default:
                var array = Array(string)
                var currentStringarray = Array(self.tmpPrice)
                if array.count == 0 && currentStringarray.count != 0 {
                    currentStringarray.removeLast()
                    self.tmpPrice = ""
                    for character in currentStringarray {
                        self.tmpPrice = self.tmpPrice.stringByAppendingString(String(character))
                    }
                    textField.text =  "\(getFormatCurrency(self.tmpPrice))"
                }
            }
            println("The string: \(formatCurrency(self.tmpPrice))")
            return false
        }
        return true
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
}