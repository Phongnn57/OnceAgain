//
//  NotificationDetailDescriptionCell.swift
//  1Again
//
//  Created by Nam Phong on 7/16/15.
//  Copyright (c) 2015 Phong Nguyen Nam. All rights reserved.
//

import UIKit

class NotificationDetailDescriptionCell: UITableViewCell {

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var descriptionLB: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configCellWithItem(item: Item) {
        self.title.text = item.title
        self.descriptionLB.text = item.description
        self.descriptionLB.sizeToFit()
    }
    
}
