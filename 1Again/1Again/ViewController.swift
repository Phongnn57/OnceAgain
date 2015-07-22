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
        println("Home")
        self.setMenuButtonAction(menuBarBtn)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
//        if User.sharedUser.userName.isEmpty {
//            let loginController = LoginViewController()
//            self.presentViewController(loginController, animated: true, completion: nil)
//        }
        
        if !UserManager.isAuthorized() {
            let loginController = LoginViewController()
            self.presentViewController(loginController, animated: true, completion: nil)
        } else {
            
        }
    }
    
}

