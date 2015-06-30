//
//  ItemDetailController.swift
//  1Again
//
//  Created by Nam Phong on 7/1/15.
//  Copyright (c) 2015 Phong Nguyen Nam. All rights reserved.
//

import UIKit

class ItemDetailController: BaseSubViewController {

    @IBOutlet weak var image1: ClickImage!
    @IBOutlet weak var image2: ClickImage!
    @IBOutlet weak var image3: ClickImage!
    @IBOutlet weak var image4: ClickImage!
    @IBOutlet weak var image5: ClickImage!
    
    var item: ItemObject!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        image1.canClick = true
        image2.canClick = true
        image3.canClick = true
        image4.canClick = true
        image5.canClick = true
        self.navigationController?.navigationBar.translucent = false
        self.edgesForExtendedLayout = UIRectEdge.None
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        image1.sd_setImageWithURL(NSURL(string: Constant.MyUrl.homeURL.stringByAppendingString("uploads/\(item.imageStr1)")), placeholderImage: UIImage(named: "image:add-item-camera.png"))
        image2.sd_setImageWithURL(NSURL(string: Constant.MyUrl.homeURL.stringByAppendingString("uploads/\(item.imageStr2)")), placeholderImage: UIImage(named: "image:add-item-camera.png"))
        image3.sd_setImageWithURL(NSURL(string: Constant.MyUrl.homeURL.stringByAppendingString("uploads/\(item.imageStr3)")), placeholderImage: UIImage(named: "image:add-item-camera.png"))
        image4.sd_setImageWithURL(NSURL(string: Constant.MyUrl.homeURL.stringByAppendingString("uploads/\(item.imageStr4)")), placeholderImage: UIImage(named: "image:add-item-camera.png"))
        image5.sd_setImageWithURL(NSURL(string: Constant.MyUrl.homeURL.stringByAppendingString("uploads/\(item.imageStr5)")), placeholderImage: UIImage(named: "image:add-item-camera.png"))
    }
    
}
