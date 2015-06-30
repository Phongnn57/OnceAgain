//
//  SignUpViewController.swift
//  1Again
//
//  Created by Nam Phong on 6/29/15.
//  Copyright (c) 2015 Phong Nguyen Nam. All rights reserved.
//

import UIKit

class SignUpViewController: BaseSubViewController, UITextFieldDelegate {

    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var address: UITextField!
    @IBOutlet weak var city: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var confirmPassword: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "endEditingView:"))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "handleSignUpResult:", name: Constant.CustomNotification.SignUpResult, object: nil)
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: Constant.CustomNotification.SignUpResult, object: nil)
    }
    
    func endEditingView(sender: AnyObject) {
        self.view.endEditing(true)
    }
    
    @IBAction func signUpTapped(sender: AnyObject) {
        
    }
    
    @IBAction func backToLogin(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func handleSignUpResult(notification: NSNotification!) {
        let userInfo:Dictionary<String,String!> = notification.userInfo as! Dictionary<String,String!>
        let result = userInfo["result"]
        if result == "success" {
            self.dismissViewControllerAnimated(true, completion: nil)
        } else {
            let alert = UIAlertView(title: "Error", message: userInfo["error"], delegate: self, cancelButtonTitle: "OK")
            alert.show()
        }
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        if string == "\n" {
            textField.resignFirstResponder()
            return false
        }
        return true
    }
    
    func isAvailableToSignUp() -> Bool {
        if email.text.isEmpty || password.text.isEmpty || address.text.isEmpty || city.text.isEmpty {
            let alert = UIAlertView(title: "Error", message: "Please enter Username, Address1, Address2 and Password", delegate: self, cancelButtonTitle: "Try again")
            alert.show()
            return false
        } else if !password.isEqual(confirmPassword) {
            let alert = UIAlertView(title: "Error", message: "Password does not match!", delegate: self, cancelButtonTitle: "Try again")
            alert.show()
            return false
        }
        return true
    }
}
