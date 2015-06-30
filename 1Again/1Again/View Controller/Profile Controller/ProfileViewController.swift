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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setMenuButtonAction(menuBtn)
        
        var userIdInt: Int = NSUserDefaults.standardUserDefaults().integerForKey(Constant.UserDefaultKey.activeUserId)
        var url = Constant.MyUrl.homeURL.stringByAppendingString("v5.getUser_JSONV2.php?id=\(userIdInt)")
        var user =  ProfileObject(urlStr: url) as ProfileObject
        
        userId.text = "\(user.uId)"
        emailAddress.text = user.email
        displayName.text = user.displayName
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
