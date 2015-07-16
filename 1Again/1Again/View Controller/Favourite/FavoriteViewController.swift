//
//  FavoriteViewController.swift
//  1Again
//
//  Created by Nam Phong on 6/30/15.
//  Copyright (c) 2015 Phong Nguyen Nam. All rights reserved.
//

import UIKit

class FavoriteObject {
    var items: [ItemObject]!
    var sellers: [UserObject]!
    
    init() {
        self.items = [ItemObject]()
        self.sellers = [UserObject]()
    }
}

class FavoriteViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var menuBtn: UIBarButtonItem!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var tableview: UITableView!
    
    // DATA
    var favorites: FavoriteObject!
    var tableData: [NSObject]!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setMenuButtonAction(menuBtn)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        FavoriteAPI.getFavoriteListWithType("U", completion: { (responseData) -> Void in
            
        }) { (error) -> Void in
            print(error)
        }
    }
    
    @IBAction func segmentDidChangeIndex(sender: AnyObject) {
    }
    
    // MARK: TABLE VIEW METHODS
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 80
    }
}
