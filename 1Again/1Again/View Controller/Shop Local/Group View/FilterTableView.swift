//
//  FilterTableView.swift
//  1Again
//
//  Created by Nam Phong on 7/9/15.
//  Copyright (c) 2015 Phong Nguyen Nam. All rights reserved.
//

import UIKit

class FilterTableView: UITableView, UITableViewDelegate, UITableViewDataSource {
    
    var datas:[AnyObject]!
    
    override func awakeFromNib() {
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        return UITableViewCell()
    }
}
