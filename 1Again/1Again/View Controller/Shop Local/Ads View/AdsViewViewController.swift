//
//  AdsViewViewController.swift
//  1Again
//
//  Created by Nam Phong on 7/3/15.
//  Copyright (c) 2015 Phong Nguyen Nam. All rights reserved.
//

import UIKit

class AdsViewViewController: BaseSubViewController {

    @IBOutlet weak var webview: UIWebView!
    var urlStr: String!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        urlStr = "http://" + urlStr
        let adsURL = NSURL(string: urlStr)
        let request = NSURLRequest(URL: adsURL!)
        self.webview.loadRequest(request)
        // Do any additional setup after loading the view.
        println("YOU SHOULD OPEN THIS URL: \(urlStr)")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
