//
//  Constant.swift
//  1Again
//
//  Created by Nam Phong on 6/27/15.
//  Copyright (c) 2015 Phong Nguyen Nam. All rights reserved.
//

import UIKit

class Constant: NSObject {
    struct MyUrl {
        static let homeURL: String = "http://www.theconsignmentclub.com/"
        static let notificationPage: String = "V5.notifications.ListJSON.php"
        static let messagePage: String = "V5.messages.ListJSON.php?id="
        
        static let Item_Detail_Favorite: String = "V5.favorite_item_insert_ac.php"
        static let Item_Get_Item_Detail: String = "V5.forSaleItem_JSONV2.php"
        static let Item_Take_It: String = "V5.notification_insert_ac.php"
        static let Item_Add_Comment: String = "forSaleItemAddComment_V2.php"
    }
    
    struct KeyUserDefaults {
        static let userName = "username"
    }
    
    struct UploadImageSize {
        static let uploadImageSizePortrait = CGSizeMake(120, 160)
        static let uploadImageSizeLandscape = CGSizeMake(160, 120)
    }

    
    struct AddItemPhotoMode {
        static let ImageViewAlreadyHasImage = 0
        static let ImageViewHasCameraImage = 1
        static let ImageViewHasDefaultImage = 2
    }
    
    struct TextFieldTag {
        static let addItemTitleTextfield = 20
        static let addItemDescriptionTextview = 21
        static let addItemCategoryTextField = 22
        static let addItemBrandTextField = 23
        static let addItemConditionTextField = 24
        static let addItemAgeTextField = 25
        static let addItemPriceTextField = 26
        
        static let ItemDetailPriceTextField = 27
    }
    
    struct ButtonTag {
        static let Category_Button_Tag = 0
        static let Distance_Button_Tag = 1
        static let Condition_Button_Tag = 2
        
    }
    
    struct ConditionData {
        static let conditions = ["New with tags", "New", "Like New", "Very Good", "Good", "Satisfactory"]
    }
    
    struct AgeData {
        static let ages = ["0 - 6 months", "7 - 12 months", "13 - 18 months", "19 - 24 months", "2+ years", "Not Specified"]
    }
    
    struct UserDefaultKey {
        static let activeUserId = "activeUserId"
        static let activeUsertype = "activeUserType"
        static let activeUser = "activeUser"
    }
    
    struct CustomNotification {
        static let AddItemWithResult = "addItemResult"
        static let LoginResult = "loginResult"
        
        static let SignUpResult = "signUpResult"
    }
}

let USER_ID = NSUserDefaults.standardUserDefaults().integerForKey(Constant.UserDefaultKey.activeUserId)

func formatCurrency(string: String) -> Double {
//    let formatter = NSNumberFormatter()
//    formatter.numberStyle = NSNumberFormatterStyle.CurrencyStyle
//    formatter.locale = NSLocale(localeIdentifier: "en_US")
    var numberFromField = (NSString(string: string).doubleValue)/100
    return numberFromField
}

func getFormatCurrency(string: String) -> String {
        let formatter = NSNumberFormatter()
        formatter.numberStyle = NSNumberFormatterStyle.CurrencyStyle
        formatter.locale = NSLocale(localeIdentifier: "en_US")
    return formatter.stringFromNumber(formatCurrency(string))!
}


func postJSON(params : Dictionary<String, String>, url : String)  {
    var request = NSMutableURLRequest(URL: NSURL(string: url)!)
    var session = NSURLSession.sharedSession()
    request.HTTPMethod = "POST"
    
    var err: NSError?
    request.HTTPBody = NSJSONSerialization.dataWithJSONObject(params, options: nil, error: &err)
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    request.addValue("application/json", forHTTPHeaderField: "Accept")
    
    var task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
        println("Response: \(response)")
        var strData = NSString(data: data, encoding: NSUTF8StringEncoding)
        println("Body: \(strData)")
        var err: NSError?
        var json = NSJSONSerialization.JSONObjectWithData(data, options: .MutableLeaves, error: &err) as? NSDictionary
        
        // Did the JSONObjectWithData constructor return an error? If so, log the error to the console
        if(err != nil) {
            println(err!.localizedDescription)
            let jsonStr = NSString(data: data, encoding: NSUTF8StringEncoding)
            println("Error could not parse JSON: '\(jsonStr)'")
        }
        else {
            // The JSONObjectWithData constructor didn't return an error. But, we should still
            // check and make sure that json has a value using optional binding.
            if let parseJSON = json {
                // Okay, the parsedJSON is here, let's get the value for 'success' out of it
                var success = parseJSON["return_code"] as? String
                println("Succes: \(success)")
            }
            else {
                // Woa, okay the json object was nil, something went worng. Maybe the server isn't running?
                let jsonStr = NSString(data: data, encoding: NSUTF8StringEncoding)
                println("Error could not parse JSON: \(jsonStr)")
            }
        }
    })
    
    task.resume()
}

func getDateFromString(dateStr: String) -> Int{
    var dateFormater = NSDateFormatter()
    dateFormater.dateFormat = "yyyy-MM-dd HH:mm:ss"
    var date = dateFormater.dateFromString(dateStr)
    let currentDate = NSDate()
    
    let cal = NSCalendar.currentCalendar()
    let unit:NSCalendarUnit = .DayCalendarUnit
    
    let components = cal.components(unit, fromDate: date!, toDate: currentDate, options: nil)
    let day = components.day
    
    return day
}

func rotateImage(image: UIImage) -> UIImage{
    var rotatedImaged: UIImage = UIImage(CGImage: image.CGImage, scale: CGFloat(1), orientation: UIImageOrientation.DownMirrored)!
    return rotatedImaged
}

func getRadianFromDegree(degree: CGFloat) -> CGFloat {
    var returnValue = CGFloat(M_PI / 180) as CGFloat
    returnValue = CGFloat(degree) * returnValue
    return returnValue
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

func scaleDownImageWith(image: UIImage, newSize: CGSize) -> UIImage {
    UIGraphicsBeginImageContextWithOptions(newSize, true, 0.0)
    image.drawInRect(CGRectMake(0, 0, newSize.width, newSize.height))
    var scaledImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    return scaledImage
}

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
            img = scaleDownImageWith(image, Constant.UploadImageSize.uploadImageSizePortrait)
        } else {
            img = scaleDownImageWith(image, Constant.UploadImageSize.uploadImageSizeLandscape)
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
