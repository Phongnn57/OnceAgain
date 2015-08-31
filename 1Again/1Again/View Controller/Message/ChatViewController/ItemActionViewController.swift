//
//  ItemActionViewController.swift
//  1Again
//
//  Created by Nam Phong Nguyen on 8/22/15.
//  Copyright (c) 2015 Phong Nguyen Nam. All rights reserved.
//

import UIKit

class ItemActionViewController: BaseSubViewController, UIActionSheetDelegate {

    @IBOutlet weak var itemImage: UIImageView!
    @IBOutlet weak var seller: UILabel!
    @IBOutlet weak var buyer: UILabel!
    @IBOutlet weak var itemName: UILabel!
    @IBOutlet weak var addedTime: UILabel!
    @IBOutlet weak var btnAction: UIButton!
    @IBOutlet weak var commentTextView: UITextView!
    @IBOutlet weak var btnSubmit: UIButton!

    var actionID: String!
    var IMD: String!
    var firstLoad: Bool = true
    var receiverId: String!
    var itemID: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.btnAction.imageEdgeInsets = UIEdgeInsetsMake(0, SCREEN_SIZE.width - 130, 0, 0)
        self.navigationController?.navigationBar.translucent = false
        if self.firstLoad {
            self.firstLoad = false
            MRProgressOverlayView.showOverlayAddedTo(self.view, title: "Loading..", mode: MRProgressOverlayViewMode.IndeterminateSmall, animated: true)
            ItemAPI.itemActionInfo(self.IMD, completion: { (profileImage, sellerName, buyerName, title, image1, ownerID, buyerID, status, itemID, date) -> Void in
                MRProgressOverlayView.dismissOverlayForView(self.view, animated: true)
                
                self.itemImage.sd_setImageWithURL(NSURL(string: Constant.MyUrl.ImageURL + image1))
                self.seller.text = sellerName
                self.buyer.text = buyerName
                self.itemName.text = title
                if status == "A" || status == "a" {
                    self.btnAction.setTitle("Offered", forState: .Normal)
                } else if status == "C" || status == "c" {
                    self.btnAction.setTitle("Consigned", forState: .Normal)
                } else if status == "S" || status == "s" {
                    self.btnAction.setTitle("Sold", forState: .Normal)
                }
                self.itemID = itemID
                self.receiverId = buyerID
                self.addedTime.text = "Added: " + date
                
            }, failure: { (error) -> Void in
                self.view.makeToast(error)
                MRProgressOverlayView.dismissOverlayForView(self.view, animated: true)
            })
        }
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "hideKeyboard"))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
    }
    
    func hideKeyboard() {
        self.commentTextView.resignFirstResponder()
    }
    
    @IBAction func submitAction(sender: AnyObject) {
        self.commentTextView.resignFirstResponder()
        MRProgressOverlayView.showOverlayAddedTo(self.view, title: "", mode: MRProgressOverlayViewMode.IndeterminateSmall, animated: true)
        ItemAPI.updateItemStatus(self.actionID, imd: self.IMD, receivedID: self.receiverId, itemID: self.itemID, comment: self.commentTextView.text, completion: { () -> Void in
            
            MRProgressOverlayView.dismissOverlayForView(self.view, animated: true)
            self.view.makeToast("Success", duration: 2, position: CSToastPositionTop)
        }) { (error) -> Void in
            MRProgressOverlayView.dismissOverlayForView(self.view, animated: true)
            self.view.makeToast(error, duration: 2, position: CSToastPositionTop)
        }
    }
    
    @IBAction func didSelectActionButton(sender: AnyObject) {
        let actionSheet = UIActionSheet(title: "Select action", delegate: self, cancelButtonTitle: "Cancel", destructiveButtonTitle: nil, otherButtonTitles: "Offered", "Consigned", "Sold")
        actionSheet.showInView(self.view)
    }
    
    func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int) {
        if buttonIndex == 1 {
            self.actionID = "A"
            self.btnAction.setTitle("Offered", forState: .Normal)
        } else if buttonIndex == 2 {
            self.actionID = "C"
            self.btnAction.setTitle("Consigned", forState: .Normal)
        } else if buttonIndex == 3 {
            self.actionID = "S"
            self.btnAction.setTitle("Sold", forState: .Normal)
        }
    }
    
    // MARK: KEYBOARD HANDLE
    func keyboardWillShow(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            if let keyboardSize = (userInfo[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
                
                if self.btnSubmit.frame.origin.y + self.btnSubmit.frame.size.height + keyboardSize.height > SCREEN_SIZE.height {
                    let offset = self.btnSubmit.frame.origin.y + self.btnSubmit.frame.size.height + keyboardSize.height - SCREEN_SIZE.height
                    UIView.animateWithDuration(0.3, animations: { () -> Void in
                        self.view.frame.origin.y = -offset
                    })
                }
            }
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.view.frame.origin.y = 64
        })
    }
}
