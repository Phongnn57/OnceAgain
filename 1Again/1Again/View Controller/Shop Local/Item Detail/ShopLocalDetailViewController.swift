//
//  ShopLocalDetailViewController.swift
//  1Again
//
//  Created by Nam Phong on 7/2/15.
//  Copyright (c) 2015 Phong Nguyen Nam. All rights reserved.
//

import UIKit

class ShopLocalDetailViewController: BaseSubViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableview: UITableView!
    
    private let firstCellIdentifier = "ShopLocalFirstCell"
    private let secondCellIdentifier = "ShopLocalSecondCell"
    private let thirdCellIdentifier = "ShopLocalThirdCell"
    private let commentCellIdentifier = "CommentCell"
    private let addnewComment = "AddNewCommentCell"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableview.registerNib(UINib(nibName: firstCellIdentifier, bundle: nil), forCellReuseIdentifier: firstCellIdentifier)
        self.tableview.registerNib(UINib(nibName: secondCellIdentifier, bundle: nil), forCellReuseIdentifier: secondCellIdentifier)
        self.tableview.registerNib(UINib(nibName: thirdCellIdentifier, bundle: nil), forCellReuseIdentifier: thirdCellIdentifier)
        self.tableview.registerNib(UINib(nibName: commentCellIdentifier, bundle: nil), forCellReuseIdentifier: commentCellIdentifier)
        self.tableview.registerNib(UINib(nibName: addnewComment, bundle: nil), forCellReuseIdentifier: addnewComment)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier(firstCellIdentifier) as! ShopLocalFirstCell
            
            return cell
        } else if indexPath.row == 1 {
            let cell = tableview.dequeueReusableCellWithIdentifier(secondCellIdentifier) as! ShopLocalSecondCell
            
            return cell
        } else if indexPath.row == 2 {
            let cell = tableview.dequeueReusableCellWithIdentifier(thirdCellIdentifier) as! ShopLocalThirdCell
            
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row == 0 {return UIScreen.mainScreen().bounds.width * 3/4 + 240}
        else if indexPath.row == 1 {return 55}
        else if indexPath.row == 2 {return 220}
        else if indexPath.row == 3 {return 60}
        return 0
    }
}
