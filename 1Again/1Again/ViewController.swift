//
//  ViewController.swift
//  1Again
//
//  Created by Nam Phong on 6/26/15.
//  Copyright (c) 2015 Phong Nguyen Nam. All rights reserved.
//

import UIKit

class ViewController: BaseViewController {

    @IBOutlet weak var menuBarBtn: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setMenuButtonAction(menuBarBtn)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        println("User name: \(User.sharedUser.userName)")
        println("User type: \(User.sharedUser.userType)")
        println("User ID: \(User.sharedUser.userID)")
        
        if User.sharedUser.userID.isEmpty {
            let loginController = LoginViewController()
            self.presentViewController(loginController, animated: true, completion: nil)
        }
    }
}