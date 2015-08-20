//
//  ShopLocalThirdCell.swift
//  1Again
//
//  Created by Nam Phong on 7/2/15.
//  Copyright (c) 2015 Phong Nguyen Nam. All rights reserved.
//

import UIKit

protocol ShopLocalThirdCellDelegate {
    func didSelectFavorite(cell:ShopLocalThirdCell)
}

class ShopLocalThirdCell: UITableViewCell {
    
    @IBOutlet weak var favButton: UIButton!
    @IBOutlet weak var category: UILabel!
    @IBOutlet weak var brand: UILabel!
    @IBOutlet weak var condition: UILabel!
    @IBOutlet weak var age: UILabel!
    @IBOutlet weak var seller: UILabel!
    
    
    var delegate: ShopLocalThirdCellDelegate?
    
    @IBAction func favAction(sender: AnyObject) {
        self.delegate?.didSelectFavorite(self)
    }
    
    @IBOutlet weak var sellerView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        
        super.setSelected(selected, animated: animated)
    }
    
    func showDataFromItem(item: Item) {
        self.category.text = item.category
        self.brand.text = item.brand
        self.condition.text = item.condition
        self.age.text = item.age
        self.seller.text = "Sold By" + item.displayName!
        if item.favOwner == "1" {
            favButton.setImage(UIImage(named: "image:shop-local-like"), forState: UIControlState.Normal)
        } else {
            favButton.setImage(UIImage(named: "image:shop-local-dislike"), forState: UIControlState.Normal)
        }

    }
}
