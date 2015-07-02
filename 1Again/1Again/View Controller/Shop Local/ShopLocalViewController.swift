//
//  ShopLocalViewController.swift
//  1Again
//
//  Created by Nam Phong on 7/1/15.
//  Copyright (c) 2015 Phong Nguyen Nam. All rights reserved.
//

import UIKit

class ShopLocalViewController: BaseViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    @IBOutlet weak var menuBtn: UIBarButtonItem!
    @IBOutlet weak var collectionview: UICollectionView!
    
    private let cellIdentifier = "ShopLocalCollectionCell"
    var items: [ItemObject]!
    var nextLink: String!
    var totalRecord: String!
    var filterStr: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setMenuButtonAction(menuBtn)
        configCollectionView()
        items = [ItemObject]()
        nextLink = String()
        totalRecord = String()
        filterStr = String()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        println(NSUserDefaults.standardUserDefaults().integerForKey(Constant.UserDefaultKey.activeUserId))
        ItemObject.getShopLocalDataFromStringURL(Constant.MyUrl.homeURL.stringByAppendingString("forSale_listJSONV4.php?userid=\(NSUserDefaults.standardUserDefaults().integerForKey(Constant.UserDefaultKey.activeUserId))"), completionClosure: { (resultItems, totalRecord, nextLink) -> () in
            self.items = resultItems
            self.totalRecord = totalRecord
            self.nextLink = nextLink
            self.collectionview.reloadData()
        })
    }
    
    func loadMoreData() {
        if totalRecord.toInt() > items.count {
            var additionData: [ItemObject] = []
            ItemObject.getShopLocalDataFromStringURL(Constant.MyUrl.homeURL + self.nextLink, completionClosure: { (resultItems, totalRecord, nextLink) -> () in
                additionData = resultItems
                self.nextLink = nextLink
                self.totalRecord = totalRecord
                for item in additionData {
                    self.items.append(item)
                }
                additionData.removeAll(keepCapacity: false)
                self.collectionview.reloadData()
            })
        }
    }
    
    //Mark: COLLECTION VIEW METHODS
    
    func configCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top:10,left:10,bottom:10,right:10)
        layout.minimumInteritemSpacing = 5
        layout.minimumLineSpacing = 10
        
        collectionview.setCollectionViewLayout(layout, animated: true)
        collectionview.backgroundColor = UIColor(rgba:"#F0F0F0")
        collectionview.userInteractionEnabled = true
        collectionview.registerNib(UINib(nibName: cellIdentifier, bundle: nil), forCellWithReuseIdentifier: cellIdentifier)
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellIdentifier, forIndexPath: indexPath) as! ShopLocalCollectionCell
        
        let item = items[indexPath.row]
        cell.setupCellBasedOnItem(item)
        if indexPath.row == items.count - 1 {
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.loadMoreData()
            })
        }
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: UIScreen.mainScreen().bounds.size.width/2 - 15, height: UIScreen.mainScreen().bounds.size.width/2 + 50)
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let item = items[indexPath.row]
        if item.category != "15" {
            let shopLocalDetailController = ShopLocalDetailViewController()
            self.navigationController?.pushViewController(shopLocalDetailController, animated: true)
        }
    }
}
