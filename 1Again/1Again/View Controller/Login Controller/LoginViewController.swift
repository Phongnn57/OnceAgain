//
//  LoginViewController.swift
//  1Again
//
//  Created by Nam Phong on 6/29/15.
//  Copyright (c) 2015 Phong Nguyen Nam. All rights reserved.
//

import UIKit


class LoginCustomTextfield: MyCustomTextField {
    override func textRectForBounds(bounds: CGRect) -> CGRect {
        return CGRectInset(bounds, 40, 10)
    }
    
    override func editingRectForBounds(bounds: CGRect) -> CGRect {
        return CGRectInset(bounds, 40, 10)
    }
    
    override func leftViewRectForBounds(bounds: CGRect) -> CGRect {
        var textRect = super.leftViewRectForBounds(bounds)
        textRect.origin.x += 10
        return textRect
    }
    
    func addImageToLeftViewWithImage(image: UIImage!) {
        self.leftViewMode = UITextFieldViewMode.Always
        self.leftView = UIImageView(image: image)
    }
}


class LoginViewController: BaseSubViewController, MBProgressHUDDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var email: LoginCustomTextfield!
    @IBOutlet weak var password: LoginCustomTextfield!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        email.addImageToLeftViewWithImage(UIImage(named: "image:email.png"))
        password.addImageToLeftViewWithImage(UIImage(named: "image:password.png"))
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "endEditingAlltextfield:"))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "handleLoginResult:", name: Constant.CustomNotification.LoginResult, object: nil)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: Constant.CustomNotification.LoginResult, object: nil)
    }
    
    func endEditingAlltextfield(sender: AnyObject!) {
        email.resignFirstResponder()
        password.resignFirstResponder()
    }

    @IBAction func goToSignUp(sender: AnyObject) {
        let signUpController = SignUpViewController()
        self.presentViewController(signUpController, animated: true, completion: nil)
    }
    
    @IBAction func signInAction(sender: AnyObject!) {
        if availableToLogin() {
            let hud = MBProgressHUD(view: self.view)
            hud.labelText = "Please wait"
            hud.delegate = self
            self.view.addSubview(hud)
            hud.show(true)
            
            UserManager.loginWithUsername(email.text, password: password.text, hud: hud)
        } else {
            let alertView = UIAlertView(title: "Error!", message: "Please fill email and password before submit", delegate: self, cancelButtonTitle: "Try again")
            alertView.show()
        }
    }
    
    func availableToLogin() -> Bool {
        if email.text != nil && password.text != nil && email.text != "" && password.text != "" {return true}
        else {return false}
    }
    
    func handleLoginResult(notification: NSNotification!) {
        let userInfo:Dictionary<String,String!> = notification.userInfo as! Dictionary<String,String!>
        let result = userInfo["result"]
        if result == "success" {
            self.dismissViewControllerAnimated(true, completion: nil)
        } else {
            let error = userInfo["error"]
            let alertView = UIAlertView(title: "Error", message: error, delegate: self, cancelButtonTitle: "Try Again")
            alertView.show()
        }
    }

    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        if string == "\n" && textField == email {
            email.resignFirstResponder()
            password.becomeFirstResponder()
            return false
        } else if string == "\n" && textField == password {
            password.resignFirstResponder()
            signInAction(nil)
            return false
        }
        return true
    }
}
