//
//  ShopLocalThirdCell.swift
//  1Again
//
//  Created by Nam Phong on 7/2/15.
//  Copyright (c) 2015 Phong Nguyen Nam. All rights reserved.
//

import UIKit

class ShopLocalThirdCell: UITableViewCell {
    
    
    @IBOutlet weak var category: UILabel!
    @IBOutlet weak var brand: UILabel!
    @IBOutlet weak var condition: UILabel!
    @IBOutlet weak var age: UILabel!
    @IBOutlet weak var seller: UILabel!
    
    @IBOutlet weak var sellerView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
