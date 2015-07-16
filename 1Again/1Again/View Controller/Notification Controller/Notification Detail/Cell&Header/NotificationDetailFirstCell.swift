//
//  NotificationDetailFirstCell.swift
//  1Again
//
//  Created by Nam Phong on 7/16/15.
//  Copyright (c) 2015 Phong Nguyen Nam. All rights reserved.
//

import UIKit
protocol NotificationDetailFirstCellDelegate {
    func clickButtonAtIndex(index: Int)
}

class NotificationDetailFirstCell: UITableViewCell {
    
    @IBOutlet weak var imageview1: ClickImage!
    @IBOutlet weak var imageview2: ClickImage!
    @IBOutlet weak var imageview3: ClickImage!
    @IBOutlet weak var imageview4: ClickImage!
    @IBOutlet weak var imageview5: ClickImage!
    
    var delegate: NotificationDetailFirstCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.imageview1.canClick = true
        self.imageview2.canClick = true
        self.imageview3.canClick = true
        self.imageview4.canClick = true
        self.imageview5.canClick = true
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func btnNothankClicked(sender: AnyObject) {
        self.delegate?.clickButtonAtIndex(0)
    }
    
    @IBAction func btnSaveClicked(sender: AnyObject) {
        self.delegate?.clickButtonAtIndex(1)
    }
    
    @IBAction func btnInterestedClicked(sender: AnyObject) {
        self.delegate?.clickButtonAtIndex(2)
    }
    
    func configCellWithItem(item: ItemObject) {
        if !item.imageStr1.isEmpty {
            self.imageview1.sd_setImageWithURL(NSURL(string:Constant.MyUrl.ImageURL + item.imageStr1), placeholderImage: UIImage(named: "image:add-item-default"))
        }
        if !item.imageStr2.isEmpty {
            self.imageview2.sd_setImageWithURL(NSURL(string:Constant.MyUrl.ImageURL + item.imageStr2), placeholderImage: UIImage(named: "image:add-item-default"))
        }
        if !item.imageStr3.isEmpty {
            self.imageview3.sd_setImageWithURL(NSURL(string:Constant.MyUrl.ImageURL + item.imageStr3), placeholderImage: UIImage(named: "image:add-item-default"))
        }
        if !item.imageStr4.isEmpty {
            self.imageview4.sd_setImageWithURL(NSURL(string:Constant.MyUrl.ImageURL + item.imageStr4), placeholderImage: UIImage(named: "image:add-item-default"))
        }
        if !item.imageStr5.isEmpty {
            self.imageview5.sd_setImageWithURL(NSURL(string:Constant.MyUrl.ImageURL + item.imageStr5), placeholderImage: UIImage(named: "image:add-item-default"))
        }
    }
}
