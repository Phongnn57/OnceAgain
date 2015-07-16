//
//  ApplyFilterView.swift
//  1Again
//
//  Created by Nam Phong on 7/9/15.
//  Copyright (c) 2015 Phong Nguyen Nam. All rights reserved.
//

import UIKit

class ApplyFilterView: UIView {

    @IBOutlet weak var applyFilterBtn: UIButton!

    
    override func awakeFromNib() {
        self.hidden = true
    }
    
    func hideViewFromSuperView() {
        if self.hidden == false {
            UIView.animateWithDuration(0.3, delay: 0, options: UIViewAnimationOptions.TransitionCurlDown, animations: { () -> Void in
                self.alpha = 0
                self.center.y = 1000
                }) { (finished: Bool) -> Void in
                    self.hidden = true
            }
        }
    }
    
    func showViewFromSuperView(point: CGFloat) {
        if self.hidden == true {
            UIView.animateWithDuration(0.3, delay: 0, options: UIViewAnimationOptions.BeginFromCurrentState, animations: { () -> Void in
                self.alpha = 1
                self.center.y = point
                }) { (finished: Bool) -> Void in
                    self.hidden = false
            }
        }
    }
}
