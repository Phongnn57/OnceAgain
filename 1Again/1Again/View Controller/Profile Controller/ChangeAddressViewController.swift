//
//  ChangeAddressViewController.swift
//  1Again
//
//  Created by Nam Phong Nguyen on 8/15/15.
//  Copyright (c) 2015 Phong Nguyen Nam. All rights reserved.
//

import UIKit

class ChangeAddressViewController: BaseSubViewController, UITextFieldDelegate {

    var saveButton: UIBarButtonItem!
    
    @IBOutlet weak var address1: MyCustomTextField!
    @IBOutlet weak var address2: MyCustomTextField!
    @IBOutlet weak var city: MyCustomTextField!
    @IBOutlet weak var state: MyCustomTextField!
    @IBOutlet weak var zip: MyCustomTextField!
    @IBOutlet weak var phone: MyCustomTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Change address"
        self.saveButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Save, target: self, action: "changeAddressAction")
        self.navigationItem.rightBarButtonItem = self.saveButton
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "hideKeyboard"))
        self.navigationController?.navigationBar.translucent = false
        
        self.address1.text = User.sharedUser.address1
        self.address2.text = User.sharedUser.address2
        self.city.text = User.sharedUser.city
        self.state.text = User.sharedUser.state
        self.zip.text = User.sharedUser.zipcode
        self.phone.text = User.sharedUser.phone
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func hideKeyboard() {
        self.view.endEditing(true)
    }
    
    func changeAddressAction() {
        self.hideKeyboard()
        if self.isAvailable() {
            UserAPI.updateAddress(self.address1.text, address2: self.address2.text, city: self.city.text, state: self.state.text, zip: self.zip.text, phone: self.phone.text, completion: { () -> Void in
                self.view.makeToast("Success", duration: 2, position: CSToastPositionTop)
                
                User.sharedUser.address1 = self.address1.text
                User.sharedUser.address2 = self.address2.text
                User.sharedUser.city = self.city.text
                User.sharedUser.state = self.state.text
                User.sharedUser.zipcode = self.zip.text
                User.sharedUser.phone = self.phone.text
                User.sharedUser.saveOffline()
                
            }, failure: { (error) -> Void in
                self.view.makeToast(error, duration: 2, position: CSToastPositionTop)
            })
        } else {
            self.view.makeToast("Please fill in required fill: address1, address2 or (city, state, zip)", duration: 2, position: CSToastPositionTop)
        }
    }
    
    func isAvailable() ->Bool {
        if !self.address1.text.isEmpty && (!self.address2.text.isEmpty || (!self.city.text.isEmpty && !self.state.text.isEmpty && !self.zip.text.isEmpty)) {
            return true
        }
        return false
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        if string == "\n" {
            textField.resignFirstResponder()
            return false
        }
        return true
    }
}