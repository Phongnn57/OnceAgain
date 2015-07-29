//
//  ShopLocalCollectionCell.swift
//  1Again
//
//  Created by Nam Phong on 7/1/15.
//  Copyright (c) 2015 Phong Nguyen Nam. All rights reserved.
//

import UIKit

class ShopLocalCollectionCell: UICollectionViewCell {

    
    @IBOutlet weak var imageview: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var price: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setupCellBasedOnItem(item: Item) {
        self.title.text = item.title
        if item.category == "15" {
            self.price.hidden = true
        } else {
            self.price.hidden = false
            self.price.text = "$" + item.price!
        }
        let url = Constant.MyUrl.homeURL + "uploads/" + item.imageStr1!
        self.imageview.sd_setImageWithURL(NSURL(string: url), placeholderImage: UIImage(named: "image:add-item-camera.png"))
    }
}
