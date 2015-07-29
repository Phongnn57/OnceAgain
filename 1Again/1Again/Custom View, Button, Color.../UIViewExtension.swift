//
//  UIViewExtension.swift
//  Rongbay
//
//  Created by Ngo Ngoc Chien on 5/21/15.
//  Copyright (c) 2015 Ngo Ngoc Chien. All rights reserved.
//

import Foundation
import UIKit
extension UIView {
    
    @IBInspectable var borderColor: UIColor {
        get {
            return UIColor.clearColor()
        }
        set (color) {
            self.layer.borderColor = color.CGColor
        }
    }
    
    @IBInspectable var borderWidth: CGFloat {
        get {
            return 0
        }
        set (width) {
            self.layer.borderWidth = width
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return 0
        }
        set (width) {
            self.layer.cornerRadius = width
        }
    }
    @IBInspectable var _radius: CGFloat {
        get {
            return 0
        }
        set (_radius) {
            self.layer.cornerRadius = _radius
            self.layer.masksToBounds = true
        }
    }
    
    @IBInspectable var shadowColor: UIColor {
        get { return UIColor(CGColor: self.layer.shadowColor ?? UIColor(red: 0, green: 0, blue: 0, alpha: 0).CGColor)! }
        set (color) { self.layer.shadowColor = color.CGColor }
    }
    
    @IBInspectable var shadowOffset: CGSize {
        get { return self.layer.shadowOffset }
        set (offset) { self.layer.shadowOffset = offset }
    }
    
    @IBInspectable var shadowOpacity: CGFloat {
        get { return CGFloat(self.layer.shadowOpacity) }
        set (opacity) { self.layer.shadowOpacity = Float(opacity) }
    }
    
    @IBInspectable var shadowRadius: CGFloat {
        get { return CGFloat(self.layer.shadowRadius) }
        set (radius) { self.layer.shadowRadius = radius }
    }
    
}

// MARK: - Animation Constants

private let BubbleControlMoveAnimationDuration: NSTimeInterval = 0.3
private let BubbleControlSpringDamping: CGFloat = 0.5
private let BubbleControlSpringVelocity: CGFloat = 0.2



extension UIView {
    
    // MARK: Frame Extensions
    
    var x: CGFloat {
        get {
            return self.frame.origin.x
        } set (value) {
            self.frame = CGRect (x: value, y: self.y, width: self.w, height: self.h)
        }
    }
    
    var y: CGFloat {
        get {
            return self.frame.origin.y
        } set (value) {
            self.frame = CGRect (x: self.x, y: value, width: self.w, height: self.h)
        }
    }
    
    var w: CGFloat {
        get {
            return self.frame.size.width
        } set (value) {
            self.frame = CGRect (x: self.x, y: self.y, width: value, height: self.h)
        }
    }
    
    var h: CGFloat {
        get {
            return self.frame.size.height
        } set (value) {
            self.frame = CGRect (x: self.x, y: self.y, width: self.w, height: value)
        }
    }
    
    
    var position: CGPoint {
        get {
            return self.frame.origin
        } set (value) {
            self.frame = CGRect (origin: value, size: self.frame.size)
        }
    }
    
    var size: CGSize {
        get {
            return self.frame.size
        } set (value) {
            self.frame = CGRect (origin: self.frame.origin, size: size)
        }
    }
    
    
    var left: CGFloat {
        get {
            return self.x
        } set (value) {
            self.x = value
        }
    }
    
    var right: CGFloat {
        get {
            return self.x + self.w
        } set (value) {
            self.x = value - self.w
        }
    }
    
    var top: CGFloat {
        get {
            return self.y
        } set (value) {
            self.y = value
        }
    }
    
    var bottom: CGFloat {
        get {
            return self.y + self.h
        } set (value) {
            self.y = value - self.h
        }
    }
    
    
    
    func leftWithOffset (offset: CGFloat) -> CGFloat {
        return self.left - offset
    }
    
    func rightWithOffset (offset: CGFloat) -> CGFloat {
        return self.right + offset
    }
    
    func topWithOffset (offset: CGFloat) -> CGFloat {
        return self.top - offset
    }
    
    func botttomWithOffset (offset: CGFloat) -> CGFloat {
        return self.bottom + offset
    }
    
    
    
    func spring (animations: ()->Void, completion:((Bool)->Void)?) {
        UIView.animateWithDuration(BubbleControlMoveAnimationDuration,
            delay: 0,
            usingSpringWithDamping: BubbleControlSpringDamping,
            initialSpringVelocity: BubbleControlSpringVelocity,
            options: UIViewAnimationOptions.CurveEaseInOut,
            animations: animations,
            completion: completion)
        
        //UIView.animateWithDuration(0.1, animations: animations, completion: completion)
    }
    
    
    func moveY (y: CGFloat) {
        var moveRect = self.frame
        moveRect.origin.y = y
        
        spring({ () -> Void in
            self.frame = moveRect
            }, completion: nil)
    }
    
    func moveX (x: CGFloat) {
        var moveRect = self.frame
        moveRect.origin.x = x
        
        spring({ () -> Void in
            self.frame = moveRect
            }, completion: nil)
    }
    
    func movePoint (x: CGFloat, y: CGFloat) {
        var moveRect = self.frame
        moveRect.origin.x = x
        moveRect.origin.y = y
        
        spring({ () -> Void in
            self.frame = moveRect
            }, completion: nil)
    }
    
    func movePoint (point: CGPoint) {
        var moveRect = self.frame
        moveRect.origin = point
        
        spring({ () -> Void in
            self.frame = moveRect
            }, completion: nil)
    }
    
    
    func setScale (s: CGFloat) {
        var transform = CATransform3DIdentity
        transform.m34 = 1.0 / -1000.0
        transform = CATransform3DScale(transform, s, s, s)
        
        self.layer.transform = transform
    }
    
    func alphaTo (to: CGFloat) {
        UIView.animateWithDuration(BubbleControlMoveAnimationDuration,
            animations: {
                self.alpha = to
        })
    }
    
    func bubble () {
        
        self.setScale(1.2)
        spring({ () -> Void in
            self.setScale(1)
            }, completion: nil)
    }

    func scaleBigger(){
        self.setScale(1.3)
    }
    func scaleNormal(){
        self.setScale(1.0)
    }
    
    func roundCorner(radius:CGFloat)
    {
        self.layer.cornerRadius = radius
    }
}
