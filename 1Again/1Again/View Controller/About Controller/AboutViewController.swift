//
//  AboutViewController.swift
//  1Again
//
//  Created by Nam Phong on 7/1/15.
//  Copyright (c) 2015 Phong Nguyen Nam. All rights reserved.
//

import UIKit

class AboutViewController: BaseViewController {
    @IBOutlet var menuBtn: UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()

        setMenuButtonAction(menuBtn)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
