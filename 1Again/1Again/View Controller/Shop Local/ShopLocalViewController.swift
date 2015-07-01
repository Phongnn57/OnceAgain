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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setMenuButtonAction(menuBtn)
        
        items = [ItemObject]()
        configCollectionView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
    func configCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top:10,left:10,bottom:10,right:10)
        layout.minimumInteritemSpacing = 5
        layout.minimumLineSpacing = 10
        
        collectionview.setCollectionViewLayout(layout, animated: true)
        collectionview.backgroundColor = UIColor(rgba:"#F0F0F0")
        collectionview.userInteractionEnabled = true
        collectionview.registerNib(UINib(nibName: cellIdentifier, bundle: nil), forCellWithReuseIdentifier: cellIdentifier)
        
//        self.view.addSubview(galleryCollectionView)
    }
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return items.count
        return 30
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellIdentifier, forIndexPath: indexPath) as! ShopLocalCollectionCell
        
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: UIScreen.mainScreen().bounds.size.width/2 - 15, height: UIScreen.mainScreen().bounds.size.width/2 - 15)
    }
}
