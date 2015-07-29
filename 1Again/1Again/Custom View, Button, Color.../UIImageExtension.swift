//
//  UIImageExtension.swift
//  Enbac
//
//  Created by Ngo Ngoc Chien on 7/10/15.
//  Copyright © 2015 Hoang Duy Nam. All rights reserved.
//

import Foundation
import UIKit
extension UIImage {
    
    class func fromColor(color: UIColor, size: CGSize) -> UIImage {
        let rect = CGRectMake(0, 0, size.width, size.height)
        UIGraphicsBeginImageContext(rect.size);
        let context = UIGraphicsGetCurrentContext()
        CGContextSetFillColorWithColor(context, color.CGColor)
        CGContextFillRect(context, rect);
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        return image
    }
    
    class func imageRotateByDegree(degree: CGFloat, image: UIImage) -> UIImage {
        var rotatedViewBox = UIView(frame: CGRectMake(0, 0, image.size.width, image.size.height))
        println(image.size)
        var t: CGAffineTransform = CGAffineTransformMakeRotation(getRadianFromDegree(degree))
        rotatedViewBox.transform = t
        var rotatedSize = rotatedViewBox.frame.size
        
        
        UIGraphicsBeginImageContext(rotatedSize)
        var bitmap = UIGraphicsGetCurrentContext()
        
        CGContextTranslateCTM(bitmap, rotatedSize.width, rotatedSize.height)
        CGContextRotateCTM(bitmap, getRadianFromDegree(degree))
        CGContextScaleCTM(bitmap, 1.0, -1.0)
        CGContextDrawImage(bitmap, CGRectMake(-image.size.width, -image.size.height, image.size.width, image.size.height), image.CGImage!)
        var newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        println(newImage.size)
        return newImage
    }
}