//
//  MyCustomImage.swift
//  1Again
//
//  Created by Nam Phong on 6/27/15.
//  Copyright (c) 2015 Phong Nguyen Nam. All rights reserved.
//

import UIKit

class MyCustomImage: UIImage {
    
    func imageRotateByDegree(degree: CGFloat, image: UIImage) -> UIImage {
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
    
    func getRadianFromDegree(degree: CGFloat) -> CGFloat {
        var returnValue = CGFloat(M_PI / 180) as CGFloat
        returnValue = CGFloat(degree) * returnValue
        return returnValue
    }
    
    func rotateImage(image: UIImage) -> UIImage{
        var rotatedImaged: UIImage = UIImage(CGImage: image.CGImage, scale: CGFloat(1), orientation: UIImageOrientation.DownMirrored)!
        return rotatedImaged
    }

}
