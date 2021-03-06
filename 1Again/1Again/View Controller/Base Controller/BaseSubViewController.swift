//
//  BaseSubViewController.swift
//  1Again
//
//  Created by Nam Phong on 6/27/15.
//  Copyright (c) 2015 Phong Nguyen Nam. All rights reserved.
//

import UIKit

class BaseSubViewController: UIViewController, MBProgressHUDDelegate {

    var hud: MBProgressHUD!
    
    override func loadView() {
        
        let nameSpaceClassName = NSStringFromClass(self.classForCoder)
        let className = nameSpaceClassName.componentsSeparatedByString(".").last! as String
        NSBundle.mainBundle().loadNibNamed(className, owner:self, options:nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func showHUD() {
        self.hud = MBProgressHUD(view: self.view)
        self.hud.delegate = self
        self.hud.labelText = "Loading"
        self.view.addSubview(self.hud)
        self.hud.show(true)
    }
    
    func hideHUD() {
        self.hud.hide(true)
        self.hud.removeFromSuperview()
    }
    
}
