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
    
}