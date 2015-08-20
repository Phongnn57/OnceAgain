//
//  NotificationDetailViewController.swift
//  1Again
//
//  Created by Nam Phong on 6/30/15.
//  Copyright (c) 2015 Phong Nguyen Nam. All rights reserved.
//

import UIKit

protocol NotificationDetailViewControllerDelegate {
    func didSelectButton(select: Bool, iid: String)
}

class NotificationDetailViewController: BaseSubViewController, UITableViewDelegate, UITableViewDataSource, NotificationDetailFirstCellDelegate, UITextFieldDelegate {

    private let NotificationDetailFirstCellIdentifier = "NotificationDetailFirstCell"
    private let NotificationDetailMessageCellIdentifier = "NotificationDetailMessageCell"
    private let NotificationDetailDescriptionCellIdentifier = "NotificationDetailDescriptionCell"
    private let NotificationDetailLastCellIdentifier = "NotificationDetailLastCell"
    
    var shouldShowMessageCell: Bool = false
    var item: Item!
    var IID: String!
    var itemID: String!
    
    var delegate: NotificationDetailViewControllerDelegate?
    
    @IBOutlet weak var tableview: UITableView!

    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.item = Item()
        self.tableview.alpha = 0
        self.tableview.registerNib(UINib(nibName: NotificationDetailFirstCellIdentifier, bundle: nil), forCellReuseIdentifier: NotificationDetailFirstCellIdentifier)
        self.tableview.registerNib(UINib(nibName: NotificationDetailMessageCellIdentifier, bundle: nil), forCellReuseIdentifier: NotificationDetailMessageCellIdentifier)
        self.tableview.registerNib(UINib(nibName: NotificationDetailDescriptionCellIdentifier, bundle: nil), forCellReuseIdentifier: NotificationDetailDescriptionCellIdentifier)
        self.tableview.registerNib(UINib(nibName: NotificationDetailLastCellIdentifier, bundle: nil), forCellReuseIdentifier: NotificationDetailLastCellIdentifier)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
        MRProgressOverlayView.showOverlayAddedTo(self.view, title: "Loading...", mode: MRProgressOverlayViewMode.IndeterminateSmall, animated: true)
        NotificationAPI.getNotificationDetailWithItem(self.itemID, completion: { (result) -> Void in
            self.item = result as! Item
            self.tableview.reloadData()
            self.tableview.alpha = 1
            MRProgressOverlayView.dismissOverlayForView(self.view, animated: true)
        }) { (error) -> Void in
            print(error)
            MRProgressOverlayView.dismissOverlayForView(self.view, animated: true)
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 && self.shouldShowMessageCell {
            return 2
        }
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCellWithIdentifier(NotificationDetailFirstCellIdentifier) as! NotificationDetailFirstCell
                cell.delegate = self
                cell.configCellWithItem(self.item)
                return cell
            } else if indexPath.row == 1 {
                let cell = tableView.dequeueReusableCellWithIdentifier(NotificationDetailMessageCellIdentifier) as! NotificationDetailMessageCell
                cell.messageTF.delegate = self
                return cell
            }
        } else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCellWithIdentifier(NotificationDetailDescriptionCellIdentifier) as! NotificationDetailDescriptionCell
            cell.configCellWithItem(self.item)
            return cell
        } else if indexPath.section == 2 {
            let cell = tableView.dequeueReusableCellWithIdentifier(NotificationDetailLastCellIdentifier) as! NotificationDetailLastCell
            cell.configCellWithItem(self.item)
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.view.endEditing(true)
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                let screenWidth = UIScreen.mainScreen().bounds.size.width
                return screenWidth * 5/6  + 20
            } else {
                return 50
            }
        } else if indexPath.section == 1{
            return 100
        } else if indexPath.section == 2 {
            return 250
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 1 {
            return "DESCRIPTION"
        } else if section == 2 {
            return "DETAILS"
        }
        return nil
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0
        } else {
            return 44
        }
    }
    
    // MARK: DELEGATE METHODS
    func clickButtonAtIndex(index: Int) {
        if index == 0 {
            MRProgressOverlayView.showOverlayAddedTo(self.view, title: "Loading...", mode: MRProgressOverlayViewMode.IndeterminateSmall, animated: true)
            NotificationAPI.submitWithID(self.IID, status: "X", comment: "", completion: { (result) -> Void in
                MRProgressOverlayView.dismissOverlayForView(self.view, animated: true)
                self.view.makeToast("Success")
                self.delegate?.didSelectButton(true, iid: self.IID)
            }, failure: { (error) -> Void in
                self.view.makeToast(error)
                MRProgressOverlayView.dismissOverlayForView(self.view, animated: true)
            })
        } else if index == 1 {
            MRProgressOverlayView.showOverlayAddedTo(self.view, title: "Loading...", mode: MRProgressOverlayViewMode.IndeterminateSmall, animated: true)
            NotificationAPI.submitWithID(self.IID, status: "S", comment: "", completion: { (result) -> Void in
                MRProgressOverlayView.dismissOverlayForView(self.view, animated: true)
                self.view.makeToast("Success")
                self.delegate?.didSelectButton(true, iid: self.IID)
                }, failure: { (error) -> Void in
                    self.view.makeToast(error)
                    MRProgressOverlayView.dismissOverlayForView(self.view, animated: true)
            })
        } else if index == 2 {
            self.shouldShowMessageCell = !self.shouldShowMessageCell
            self.tableview.beginUpdates()
            self.tableview.reloadSections(NSIndexSet(index: 0), withRowAnimation: .None)
            self.tableview.endUpdates()
        }
    }
    
    // MARK: KEYBOARD HANDLER
    func keyboardWillShow(notification: NSNotification) {
        let userInfo = notification.userInfo!
        var keyboardSize = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
        
        var contentInsets = UIEdgeInsetsMake(0, 0, keyboardSize.size.height, 0)
        self.tableview.contentInset = contentInsets
        self.tableview.scrollIndicatorInsets = contentInsets
    }
    
    func keyboardWillHide(notification: NSNotification) {
        let contentInsets = UIEdgeInsetsZero
        UIView.animateWithDuration(0.2, animations: { () -> Void in
            self.tableview.contentInset = contentInsets
            self.tableview.scrollIndicatorInsets = contentInsets
        })
    }
    
    // MARK: TEXTFIELD METHODS
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        if string == "\n" {
            textField.resignFirstResponder()
            return false
        }
        return true
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        if textField.text.isEmpty {
            let alert = UIAlertView(title: "Error", message: "Your message must not be empty", delegate: self, cancelButtonTitle: "OK")
            alert.show()
        } else {
            MRProgressOverlayView.showOverlayAddedTo(self.view, title: "Loading...", mode: MRProgressOverlayViewMode.IndeterminateSmall, animated: true)
            NotificationAPI.submitWithID(self.IID, status: "Y", comment: textField.text, completion: { (result) -> Void in
                MRProgressOverlayView.dismissOverlayForView(self.view, animated: true)
                self.view.makeToast("Success")
                self.delegate?.didSelectButton(true, iid: self.IID)
            }, failure: { (error) -> Void in
                MRProgressOverlayView.dismissOverlayForView(self.view, animated: true)
                self.view.makeToast(error)
            })
        }
    }
}
