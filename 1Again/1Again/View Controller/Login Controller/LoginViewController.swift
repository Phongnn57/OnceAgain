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


class LoginViewController: BaseSubViewController, MBProgressHUDDelegate, UITextFieldDelegate, SignUpViewControllerDelegate {
    
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

    func endEditingAlltextfield(sender: AnyObject!) {
        email.resignFirstResponder()
        password.resignFirstResponder()
    }

    @IBAction func goToSignUp(sender: AnyObject) {
        let signUpController = SignUpViewController()
        signUpController.delegate = self
        self.presentViewController(signUpController, animated: true, completion: nil)
    }
    
    @IBAction func signInAction(sender: AnyObject!) {
        self.view.endEditing(true)
        if availableToLogin() {
            
            MRProgressOverlayView.showOverlayAddedTo(self.view, title: "Logging...", mode: MRProgressOverlayViewMode.IndeterminateSmall, animated: true)
            
            UserAPI.login(email.text, password: password.text, completion: { () -> Void in
                MRProgressOverlayView.dismissOverlayForView(self.view, animated: true)
                self.dismissViewControllerAnimated(true, completion: nil)
            }, failure: { (error) -> Void in
                MRProgressOverlayView.dismissOverlayForView(self.view, animated: true)
                self.view.makeToast(error)
            })
        } else {
            self.view.makeToast("Please fill email and password before submit")
        }
    }
    
    func availableToLogin() -> Bool {
        if email.text != nil && password.text != nil && email.text != "" && password.text != "" {return true}
        else {return false}
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
    
    func didFinishSignupWithEmail(email: String) {
        self.email.text = email
    }
}
