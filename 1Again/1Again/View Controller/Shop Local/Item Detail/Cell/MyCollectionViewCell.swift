//
//  MyCollectionViewCell.swift
//  1Again
//
//  Created by Nam Phong on 7/11/15.
//  Copyright (c) 2015 Phong Nguyen Nam. All rights reserved.
//

import UIKit

class MyCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imageview: ClickImage!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.imageview.canClick = true
    }

}
