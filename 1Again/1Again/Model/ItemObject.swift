//
//  NewItemObject.swift
//  1Again
//
//  Created by Nam Phong on 6/27/15.
//  Copyright (c) 2015 Phong Nguyen Nam. All rights reserved.
//

import UIKit

class ItemObject {
    var image1: UIImage!
    var image2: UIImage!
    var image3: UIImage!
    var image4: UIImage!
    var image5: UIImage!
    
    var title: String!
    var description: String!
    var donate: String!
    var consign: String!
    var price: String!
    var sale: String!
    
    var userId: Int!
    var category: String!
    var condition: String!
    var age: String!
    var brand: String!
    
    init() {
        
    }
    
    func setImage(sImage1: UIImage!, sImage2: UIImage!, sImage3: UIImage!, sImage4: UIImage!, sImage5: UIImage!) {
        self.image1 = sImage1
        self.image2 = sImage2
        self.image3 = sImage3
        self.image4 = sImage4
        self.image5 = sImage5
    }
    
    func setTitle(sTitle: String!, sDescription: String!, sUserId: Int!, scategory: String!, sCondition: String!, sAge: String!, sBrand: String!) {
        title = sTitle
        description = sDescription
        userId = sUserId
        category = scategory
        condition = sCondition
        age = sAge
        brand = sBrand
    }
    
    func setDonate(sDonate: String!, sConsign: String!, sSale: String!, sPrice: String) {
        donate = sDonate
        condition = sConsign
        sale = sSale
        price = sPrice
    }
    
    func getNumberOfEmptyImage() -> Int {
        if image1 == nil {return 5}
        if image2 == nil {return 4}
        if image3 == nil {return 3}
        if image4 == nil {return 2}
        if image5 == nil {return 1}
        return 0
    }
    
    func passToEmptyImageInOrderWithImage(image: UIImage!) {
        if image1 == nil {image1 = image}
        else if image2 == nil {image2 = image}
        else if image3 == nil {image3 = image}
        else if image4 == nil {image4 = image}
        else if image5 == nil {image5 = image}
    }
    
    func reOrderImageList() {
        var images:[UIImage] = []
        if image1 != nil {images.append(image1)}
        if image2 != nil {images.append(image2)}
        if image3 != nil {images.append(image3)}
        if image4 != nil {images.append(image4)}
        if image5 != nil {images.append(image5)}
        
        removeAllImage()
        
        for var i = 0; i < images.count; i++ {
            if i == 0 {image1 = images[0] }
            else if i == 1 {image2 = images[1] }
            else if i == 2 {image3 = images[2] }
            else if i == 3 {image4 = images[3] }
            else if i == 4 {image5 = images[4] }
        }
    }
    
    func removeImageAtByTag(tag: Int) {
        if tag == 13 {image1 = nil}
        else if tag == 14 {image2 = nil}
        else if tag == 15 {image3 = nil}
        else if tag == 16 {image4 = nil}
        else if tag == 17 {image5 = nil}
    }
    
    func removeAllImage() {
        image1 = nil
        image2 = nil
        image3 = nil
        image4 = nil
        image5 = nil
    }
    
    func exChangeImageByTag(tag: Int) {
        var tmpImage: UIImage! = self.image1
        if tag == 14 {
            self.image1 = self.image2
            self.image2 = tmpImage
        }
        else if tag == 15 {
            self.image1 = self.image3
            self.image3 = tmpImage
        }
        else if tag == 16 {
            self.image1 = self.image4
            self.image4 = tmpImage
        }
        else if tag == 17 {
            self.image1 = self.image5
            self.image5 = tmpImage
        }
    }
    
    func pushItemWithActivityIndicator(hud: MBProgressHUD!) ->Bool {
        var uploadStatus: Bool = false
        let manager = AFHTTPRequestOperationManager()
        manager.responseSerializer = AFHTTPResponseSerializer()
        
        var postURL = Constant.MyUrl.homeURL.stringByAppendingString("item_insert_ac.V2.php")
        
        manager.POST(postURL, parameters: nil, constructingBodyWithBlock: { (data: AFMultipartFormData!) -> Void in
            
            var imageData: NSData = NSData()
            if (self.image1 != nil) {
                imageData = self.getDataFromImage(self.image1)
                data.appendPartWithFileData(imageData, name: "files[]", fileName: "image1.jpg", mimeType: "image/jpeg")
            }
            if (self.image2 != nil) {
                imageData = self.getDataFromImage(self.image2)
                data.appendPartWithFileData(imageData, name: "files[]", fileName: "image2.jpg", mimeType: "image/jpeg")
            }
            if (self.image3 != nil) {
                imageData = self.getDataFromImage(self.image1)
                data.appendPartWithFileData(imageData, name: "files[]", fileName: "image3.jpg", mimeType: "image/jpeg")
            }
            if (self.image4 != nil) {
                imageData = self.getDataFromImage(self.image1)
                data.appendPartWithFileData(imageData, name: "files[]", fileName: "image4.jpg", mimeType: "image/jpeg")
            }
            if (self.image5 != nil) {
                imageData = self.getDataFromImage(self.image1)
                data.appendPartWithFileData(imageData, name: "files[]", fileName: "image5.jpg", mimeType: "image/jpeg")
            }
            
            data.appendPartWithFormData("\(self.userId)".dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false), name: "ownerId")
            data.appendPartWithFormData(self.category.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false), name: "category")
            data.appendPartWithFormData(self.title.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false), name: "category")
            data.appendPartWithFormData(self.condition.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false), name: "category")
            data.appendPartWithFormData(self.brand.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false), name: "category")
            data.appendPartWithFormData(self.age.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false), name: "category")
            data.appendPartWithFormData(self.description.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false), name: "category")
            data.appendPartWithFormData(self.donate.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false), name: "category")
            data.appendPartWithFormData(self.consign.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false), name: "category")
            data.appendPartWithFormData(self.sale.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false), name: "category")
            data.appendPartWithFormData(self.price.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false), name: "category")

            }, success: { (request: AFHTTPRequestOperation!, obj: AnyObject!) -> Void in
                hud.hide(true)
                uploadStatus = true
            }) { (request: AFHTTPRequestOperation!, error: NSError!) -> Void in
                hud.hide(true)
                uploadStatus = false
        }
        
        return uploadStatus
    }
    
    
    //Mark: Image methods
    func getDataFromImage(image: UIImage) -> NSData! {
        var resulution = image.size.width * image.size.height
        var img: UIImage!
        var mode: String!
        
        if (image.size.height > image.size.width) {
            mode = "P"
        } else {
            mode = "L"
        }
        if resulution > 60 * 60 {
            if mode == "P" {
                img = scaleDownImageWith(image, newSize: Constant.UploadImageSize.uploadImageSizePortrait)
            } else {
                img = scaleDownImageWith(image, newSize: Constant.UploadImageSize.uploadImageSizeLandscape)
            }
            
        }
        
        var compression = 0.8 as CGFloat
        var maxCompression = 0.1 as CGFloat
        var imageData = UIImageJPEGRepresentation(img, compression)
        //Mark: Compress Image
        /*
        while imageData.length > 500 && compression > maxCompression {
        compression -= 0.1
        imageData = UIImageJPEGRepresentation(img, compression)
        }
        */
        return imageData
    }
    
    
    func scaleDownImageWith(image: UIImage, newSize: CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(newSize, true, 0.0)
        image.drawInRect(CGRectMake(0, 0, newSize.width, newSize.height))
        var scaledImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return scaledImage
    }
    
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
