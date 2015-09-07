//
//  RateItemViewController.swift
//  1Again
//
//  Created by Nguyen Nam Phong on 9/5/15.
//  Copyright (c) 2015 Phong Nguyen Nam. All rights reserved.
//

import UIKit

class RateItemViewController: BaseSubViewController {
    
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var currentStar: HCSStarRatingView!
    @IBOutlet weak var reviewCount: UILabel!
    @IBOutlet weak var rateStar: HCSStarRatingView!
    @IBOutlet weak var feedback: UITextView!
    
    var btnSubmit: UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.btnSubmit = UIBarButtonItem(title: "Submit", style: UIBarButtonItemStyle.Plain, target: self, action: "doSubmitReview")
        self.navigationItem.rightBarButtonItem = self.btnSubmit
        self.initialize()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func initialize() {
        let urlStr = Constant.MyUrl.ImageURL + User.sharedUser.imageURL
        self.avatar.sd_setImageWithURL(NSURL(string: urlStr), placeholderImage: UIImage(named: "avatar_default"))
        self.name.text = User.sharedUser.displayName
        self.reviewCount.text = User.sharedUser.usrReviewCount! + " reviews"
        self.rateStar.maximumValue = 5
        self.rateStar.minimumValue = 0
        self.rateStar.value = CGFloat(Utilities.numberFromJSONAnyObject(User.sharedUser.star)!.floatValue)
    }
    
    // MARK: BUTTON ACTION
    func doSubmitReview() {
//        ItemAPI.postNewReviewForItem(<#itemID: String#>, ratedID: <#String#>, star: <#Double#>, comment: <#String#>, completion: <#() -> Void##() -> Void#>, failure: <#(error: String) -> Void##(error: String) -> Void#>)
    }

}
