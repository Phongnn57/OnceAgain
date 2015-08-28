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
    @IBOutlet weak var titleLB: UILabel!
    @IBOutlet weak var itemStatus: UILabel!
    @IBOutlet weak var itemAddedDate: UILabel!
    
    @IBOutlet weak var totalNotification: UILabel!
    @IBOutlet weak var noInterested: UILabel!
    @IBOutlet weak var interested: UILabel!
    @IBOutlet weak var noResponse: UILabel!
    @IBOutlet weak var saved: UILabel!
    @IBOutlet weak var newMessage: UILabel!
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var item: Item!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        image1.canClick = true
        image2.canClick = true
        image3.canClick = true
        image4.canClick = true
        image5.canClick = true
        self.navigationController?.navigationBar.translucent = false
        self.edgesForExtendedLayout = UIRectEdge.None
        
        
        self.contentView.frame = CGRectMake(0, 0, SCREEN_SIZE.width, self.contentView.frame.height)
        self.scrollView.addSubview(self.contentView)
        self.scrollView.contentSize = CGSizeMake(SCREEN_SIZE.width, self.contentView.frame.height)
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        let str = Constant.MyUrl.homeURL + "uploads/"
        
        image1.sd_setImageWithURL(NSURL(string: str + item.imageStr1!), placeholderImage: UIImage(named: "image:add-item-camera.png"))
        image2.sd_setImageWithURL(NSURL(string: str + item.imageStr2!), placeholderImage: UIImage(named: "image:add-item-camera.png"))
        image3.sd_setImageWithURL(NSURL(string: str + item.imageStr3!), placeholderImage: UIImage(named: "image:add-item-camera.png"))
        image4.sd_setImageWithURL(NSURL(string: str + item.imageStr4!), placeholderImage: UIImage(named: "image:add-item-camera.png"))
        image5.sd_setImageWithURL(NSURL(string: str + item.imageStr5!), placeholderImage: UIImage(named: "image:add-item-camera.png"))
        MRProgressOverlayView.showOverlayAddedTo(self.view, title: "Loading", mode: MRProgressOverlayViewMode.IndeterminateSmall, animated: true)
        ItemAPI.itemWithCount(self.item.itemID!, completion: { (data) -> Void in
            self.parseData(data)
            MRProgressOverlayView.dismissOverlayForView(self.view, animated: true)
        }) { (error) -> Void in
            self.view.makeToast(error)
            MRProgressOverlayView.dismissOverlayForView(self.view, animated: true)
        }
    }
    
    func parseData(data: AnyObject) {
        if let arr: Array<AnyObject> = data as? Array<AnyObject> {
            if let dic: Dictionary<String, AnyObject> = arr[0] as? Dictionary<String, AnyObject> {
                self.interested.text = (dic["interested"] as? String)! + " interested"
                self.itemAddedDate.text = "Added: " + (dic["itemAddDate"] as? String)!
                self.itemStatus.text = "Status: " + (dic["itemStatus"] as? String)!
                self.newMessage.text = (dic["messages"] as? String)! + " new message"
                self.noResponse.text = (dic["noResponse"] as? String)! + " no response"
                self.noInterested.text = (dic["noThanks"] as? String)! + " no interested"
                self.saved.text = (dic["saved"] as? String)! + " saved"
                self.titleLB.text = dic["title"] as? String
                let value: Int = Utilities.numberFromJSONAnyObject(dic["noResponse"])!.integerValue + Utilities.numberFromJSONAnyObject(dic["noThanks"])!.integerValue + Utilities.numberFromJSONAnyObject(dic["saved"])!.integerValue + Utilities.numberFromJSONAnyObject(dic["interested"])!.integerValue
                self.totalNotification.text = "\(value)" + " notifications sent"
            }
        }
    }
    
    // MARK: BUTTON ACTION
    
    @IBAction func gotoItemMessages(sender: AnyObject) {
        let messageViewController = MessageTableViewController()
        messageViewController.itemID = self.item.itemID
        messageViewController.oneItem = true
        self.navigationController?.pushViewController(messageViewController, animated: true)
    }
    
    @IBAction func gotoItemNotifications(sender: AnyObject) {
        
    }
    
    
}
