//
//  ShopLocalSecondCell.swift
//  1Again
//
//  Created by Nam Phong on 7/2/15.
//  Copyright (c) 2015 Phong Nguyen Nam. All rights reserved.
//

import UIKit

protocol ShopLocalSecondCellDelegate {
    func didSelectOfferBtn(cell: ShopLocalSecondCell)
}

class ShopLocalSecondCell: UITableViewCell {

    @IBOutlet weak var price: MyCustomTextField!
    var delegate: ShopLocalSecondCellDelegate?
    
    @IBAction func btnOfferAction(sender: AnyObject) {
        self.delegate?.didSelectOfferBtn(self)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
