//
//  ShopLocalFirstCell.swift
//  1Again
//
//  Created by Nam Phong on 7/2/15.
//  Copyright (c) 2015 Phong Nguyen Nam. All rights reserved.
//

import UIKit

protocol ShopLocalFirstCellDelegate {
    func didChangeFavorite(cell: ShopLocalFirstCell)
    func didSelectMakeOfferButton(cell: ShopLocalFirstCell)
    func didSelectIWillTakeItButton(cell: ShopLocalFirstCell)
}

class ShopLocalFirstCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource {
    private let collectionCellIdentifier = "MyCollectionViewCell"

    @IBOutlet weak var collectionview: UICollectionView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var favorite: UIButton!
    @IBOutlet weak var descriptionLB: UILabel!
    
    var like: Bool = false
    var delegate: ShopLocalFirstCellDelegate?
    var makeOfferSelected: Bool = false
    var imageURLs: [String]! = []
    
    @IBAction func btnTakeItAction(sender: AnyObject) {
        self.delegate?.didSelectIWillTakeItButton(self)
    }
    
    @IBAction func btnMakeOfferAction(sender: AnyObject) {
        self.makeOfferSelected = !self.makeOfferSelected
        self.delegate?.didSelectMakeOfferButton(self)
    }
    
    @IBAction func btnFavoriteAction(sender: AnyObject) {
        self.like = !self.like
        self.setupFavoriteButton()
        self.delegate?.didChangeFavorite(self)
    }
    
    func configCollectionView() {
        let frameSize = UIScreen.mainScreen().bounds.size
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = UICollectionViewScrollDirection.Horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.itemSize = CGSizeMake(frameSize.width, frameSize.width)
        self.collectionview.delegate = self
        self.collectionview.dataSource = self
        self.collectionview.collectionViewLayout = layout
        self.collectionview.registerNib(UINib(nibName: collectionCellIdentifier, bundle: nil), forCellWithReuseIdentifier: collectionCellIdentifier)
    }
    
    func setupFavoriteButton() {
        if self.like {
            self.favorite.setBackgroundImage(UIImage(named: "image:shop-local-like"), forState: UIControlState.Normal)
        } else {
            self.favorite.setBackgroundImage(UIImage(named: "image:shop-local-dislike"), forState: UIControlState.Normal)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupFavoriteButton()
        self.configCollectionView()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func showDataFromItem(item: ItemObject) {
        self.price.text = "$\(item.price)"
        self.title.text = item.title
        self.descriptionLB.text = item.description
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.imageURLs.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell: MyCollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier(collectionCellIdentifier, forIndexPath: indexPath) as! MyCollectionViewCell
        cell.imageview.sd_setImageWithURL(NSURL(string:Constant.MyUrl.homeURL.stringByAppendingString("uploads/\(self.imageURLs[indexPath.row])") ), placeholderImage: UIImage(named: "image:add-item-camera"))
        return cell
    }
    
}
