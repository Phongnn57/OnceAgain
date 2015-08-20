//
//  ChangePasswordViewController.swift
//  1Again
//
//  Created by Nam Phong Nguyen on 8/15/15.
//  Copyright (c) 2015 Phong Nguyen Nam. All rights reserved.
//

import UIKit

class ChangePasswordViewController: BaseSubViewController, UITextFieldDelegate {

    @IBOutlet weak var currentPass: UITextField!
    @IBOutlet weak var newPass: UITextField!
    @IBOutlet weak var confirmPass: UITextField!
    
    var saveButton: UIBarButtonItem!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.title = "Change Password"
        self.saveButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Save, target: self, action: "changePasswordAction")
        self.navigationItem.rightBarButtonItem = self.saveButton
        self.navigationController?.navigationBar.translucent = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func changePasswordAction() {
        self.view.endEditing(true)
        if self.isAvailable() {
            MRProgressOverlayView.showOverlayAddedTo(self.view, title: "", mode: MRProgressOverlayViewMode.IndeterminateSmall, animated: true)
            UserAPI.changePassword(self.newPass.text, oldPass: self.currentPass.text, completion: { () -> Void in
                MRProgressOverlayView.dismissOverlayForView(self.view, animated: true)
                self.view.makeToast("Change password success", duration: 2, position: CSToastPositionTop)
            }, failure: { (error) -> Void in
                MRProgressOverlayView.dismissOverlayForView(self.view, animated: true)
                self.view.makeToast(error, duration: 2, position: CSToastPositionTop)
            })
        }
    }
    
    func isAvailable() ->Bool {
        if self.newPass.text != self.confirmPass.text {
            self.view.makeToast("New password and confirm pass does not match!", duration: 2, position: CSToastPositionTop)
            return false
        } else if self.newPass.text.length < 7 {
            self.view.makeToast("Password must be at least 7 characters long", duration: 2, position: CSToastPositionTop)
            return false
        } else if self.currentPass.text.isEmpty {
            self.view.makeToast("Please enter current password", duration: 2, position: CSToastPositionTop)
            return false
        } else if self.newPass.text.isEmpty {
            self.view.makeToast("Please enter new password", duration: 2, position: CSToastPositionTop)
            return false
        } else if self.confirmPass.text.isEmpty {
            self.view.makeToast("Please confirm new password", duration: 2, position: CSToastPositionTop)
            return false
        } else if !self.containNumber() {
            self.view.makeToast("Password must contains at least 1 number", duration: 2, position: CSToastPositionTop)
            return false
        }
        return true
    }
    
    func containNumber() ->Bool {
        let str: NSString = self.newPass.text as NSString
        if str.rangeOfCharacterFromSet(NSCharacterSet.decimalDigitCharacterSet()).location == NSNotFound {
            return false
        }
        return true
    }

}
