//
//  ShopLocalFirstCell.swift
//  1Again
//
//  Created by Nam Phong on 7/2/15.
//  Copyright (c) 2015 Phong Nguyen Nam. All rights reserved.
//

import UIKit

protocol ShopLocalFirstCellDelegate {
    
}

class ShopLocalFirstCell: UITableViewCell {


    @IBOutlet weak var scrollView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var favorite: UIButton!
    @IBOutlet weak var descriptionLB: UILabel!
    
    @IBAction func btnTakeItAction(sender: AnyObject) {
    }
    
    @IBAction func btnMakeOfferAction(sender: AnyObject) {
    }
    
    @IBAction func btnFavoriteAction(sender: AnyObject) {
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func showDataFromItem(item: ItemObject) {
        self.price.text = "$\(item.price)"
        self.title.text = item.title
        self.descriptionLB.text = item.description
    }
    
}
