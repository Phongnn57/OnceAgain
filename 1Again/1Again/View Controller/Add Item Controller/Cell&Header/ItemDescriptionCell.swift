//
//  ItemDescriptionCell.swift
//  1Again
//
//  Created by Nam Phong on 6/27/15.
//  Copyright (c) 2015 Phong Nguyen Nam. All rights reserved.
//

import UIKit

class ItemDescriptionCell: UITableViewCell {

    @IBOutlet weak var title: MyCustomTextField!

    @IBOutlet weak var descriptionTextview: UITextView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.descriptionTextview.sizeToFit()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configCellWithItem(item: Item) {
        self.title.text = item.title
        if item.description!.isEmpty {
            self.descriptionTextview.text = "Description"
            self.descriptionTextview.textColor = UIColor(rgba: "#BABCC1")
        } else {
            self.descriptionTextview.text = item.description
            self.descriptionTextview.textColor = UIColor.blackColor()
        }
    }
    
}
