//
//  ProfileViewController.swift
//  1Again
//
//  Created by Nam Phong on 6/30/15.
//  Copyright (c) 2015 Phong Nguyen Nam. All rights reserved.
//

import UIKit

class ProfileViewController: BaseViewController {

    @IBOutlet weak var menuBtn: UIBarButtonItem!
    @IBOutlet weak var userId: UILabel!
    @IBOutlet weak var displayName: UILabel!
    @IBOutlet weak var emailAddress: UILabel!
    
    var user = User()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setMenuButtonAction(menuBtn)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        UserAPI.getUserProfile({ (user) -> Void in
            self.user = user
            self.userId.text = self.user.userID
            self.emailAddress.text = self.user.email
            self.displayName.text = self.user.displayName
        }, failure: { (error) -> Void in
            self.view.makeToast(error)
        })
    }

}
