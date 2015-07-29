//
//  NotificationDetailLastCell.swift
//  1Again
//
//  Created by Nam Phong on 7/16/15.
//  Copyright (c) 2015 Phong Nguyen Nam. All rights reserved.
//

import UIKit

class NotificationDetailLastCell: UITableViewCell {

    @IBOutlet weak var age: UILabel!
    @IBOutlet weak var brand: UILabel!
    @IBOutlet weak var category: UILabel!
    @IBOutlet weak var condition: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configCellWithItem(item: Item) {
        self.age.text = item.age
        self.brand.text = item.brand
        self.category.text = item.category
        self.condition.text = item.condition
    }
    
}
