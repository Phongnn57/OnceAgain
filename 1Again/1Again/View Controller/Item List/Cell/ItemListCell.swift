//
//  ItemListCell.swift
//  1Again
//
//  Created by Nam Phong on 6/30/15.
//  Copyright (c) 2015 Phong Nguyen Nam. All rights reserved.
//

import UIKit

class ItemListCell: UITableViewCell {

    @IBOutlet weak var imageview: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var descriptionLb: UILabel!
    @IBOutlet weak var timeStamp: UILabel!

    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configCellWithItem(item: ItemObject) {
        self.title.text = item.title
        self.descriptionLb.text = item.description
        self.timeStamp.text = "\(getDateFromString(item.timestamp!)) days ago"
        let url = Constant.MyUrl.homeURL + "uploads/" + item.imageStr1!
        self.imageview.sd_setImageWithURL(NSURL(string: url), placeholderImage: UIImage(named: "image:add-item-camera.png"))
    }
    
    func configCellByItem(item: Item) {
        self.title.text = item.title
        self.descriptionLb.text = item.description
        self.timeStamp.text = "\(getDateFromString(item.timestamp!)) days ago"
        let url = Constant.MyUrl.homeURL + "uploads/" + item.imageStr1!
        self.imageview.sd_setImageWithURL(NSURL(string: url), placeholderImage: UIImage(named: "image:add-item-camera.png"))
    }
}
