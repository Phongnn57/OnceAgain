//
//  FilterView.swift
//  1Again
//
//  Created by Nam Phong on 7/9/15.
//  Copyright (c) 2015 Phong Nguyen Nam. All rights reserved.
//

import UIKit

protocol FilterViewDelegate {
    func didSelectButtonAtIndex(index: Int)
}

class FilterView: UIView {
    
    @IBOutlet weak var categoryBtn: UIButton!
    @IBOutlet weak var distanceBtn: UIButton!
    @IBOutlet weak var conditionBtn: UIButton!
    
    var selectedIndex: Int = -1
    var delegate: FilterViewDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.hidden = true
        self.setStateUnSelectedToButton(self.categoryBtn)
        self.setStateUnSelectedToButton(self.distanceBtn)
        self.setStateUnSelectedToButton(self.conditionBtn)
    }
    
    
    func hideViewFromSuperView() {
        if self.hidden == false {
            UIView.animateWithDuration(0.3, delay: 0, options: UIViewAnimationOptions.BeginFromCurrentState, animations: { () -> Void in
                self.alpha = 0
                self.center.y -= 60
                }) { (finished: Bool) -> Void in
                    
                    self.hidden = true
                    self.resetView()
            }
        }
    }
    
    func showViewFromSuperView() {
        if self.hidden == true {
            UIView.animateWithDuration(0.3, delay: 0, options: nil, animations: { () -> Void in
                self.alpha = 1
                self.center.y += 60
                }) { (finished: Bool) -> Void in
                    self.hidden = false
            }
        }
    }
    
    func resetView() {
        self.setStateUnSelectedToButton(self.categoryBtn)
        self.setStateUnSelectedToButton(self.distanceBtn)
        self.setStateUnSelectedToButton(self.conditionBtn)
        self.selectedIndex = -1
    }
    
    func setStateSelectedToButton(btn: UIButton) {
        btn.backgroundColor = UIColor.darkGrayColor()
    }
    
    func setStateUnSelectedToButton(btn: UIButton) {
        btn.backgroundColor = UIColor.lightGrayColor()
    }
    
    func setSelectedButtonAtIndex(index: Int) {
        self.selectedIndex = index
        if index == 0 {
            self.setStateSelectedToButton(self.categoryBtn)
            self.setStateUnSelectedToButton(self.distanceBtn)
            self.setStateUnSelectedToButton(self.conditionBtn)
        } else if index == 1 {
            self.setStateSelectedToButton(self.distanceBtn)
            self.setStateUnSelectedToButton(self.categoryBtn)
            self.setStateUnSelectedToButton(self.conditionBtn)
        } else if index == 2 {
            self.setStateSelectedToButton(self.conditionBtn)
            self.setStateUnSelectedToButton(self.distanceBtn)
            self.setStateUnSelectedToButton(self.categoryBtn)
        }
    }
    
    @IBAction func selectButton(sender: AnyObject) {
        let btn = sender as! UIButton
        if self.selectedIndex == btn.tag {
            self.resetView()
        } else if btn.isEqual(self.categoryBtn) {
            self.setSelectedButtonAtIndex(0)
        } else if btn.isEqual(self.distanceBtn) {
            self.setSelectedButtonAtIndex(1)
        } else {
            self.setSelectedButtonAtIndex(2)
        }
        
        delegate?.didSelectButtonAtIndex(self.selectedIndex)
    }
}
