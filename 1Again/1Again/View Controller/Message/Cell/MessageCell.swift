//
//  MessageCell.swift
//  1Again
//
//  Created by Nam Phong on 7/1/15.
//  Copyright (c) 2015 Phong Nguyen Nam. All rights reserved.
//

import UIKit

class MessageCell: UITableViewCell {

    @IBOutlet weak var imageview: UIImageView!
    @IBOutlet weak var user: UILabel!
    @IBOutlet weak var timestamp: UILabel!
    @IBOutlet weak var title: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
