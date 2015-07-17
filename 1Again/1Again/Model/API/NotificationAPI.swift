//
//  NotificationAPI.swift
//  1Again
//
//  Created by Nam Phong on 7/16/15.
//  Copyright (c) 2015 Phong Nguyen Nam. All rights reserved.
//

import UIKit

class NotificationAPI: NSObject {
    class func getNotificationDetailWithItem(itemID: String, completion: (result: AnyObject!)-> Void, failure:(error: String)->Void) {
        var url = NSURL(string: Constant.MyUrl.homeURL.stringByAppendingString(Constant.MyUrl.Notification_Detail) + "?id=\(itemID)")
        var data: NSData = NSData(contentsOfURL: url!)!
        
        if let jsonData = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as? NSDictionary {
            if let items = jsonData["item"] as? NSArray {
                for item in items {
                    var thisItem = ItemObject()
                    thisItem.id = item["id"] as! String
                    thisItem.displayName = item["displayName"] as! String
                    thisItem.ownerId = (item["ownerId"] as! String).toInt()!
                    thisItem.category = item["category"] as! String
                    thisItem.title = item["title"] as! String
                    thisItem.brand = item["brand"] as! String!
                    thisItem.condition = item["conditionA"] as! String!
                    thisItem.age = item["age"] as! String!
                    thisItem.description = item["description"] as! String!
                    thisItem.price = item["price"] as! String!
                    thisItem.imageStr1 = item["image1"] as! String!
                    thisItem.imageStr2 = item["image2"] as! String!
                    thisItem.imageStr3 = item["image3"] as! String!
                    thisItem.imageStr4 = item["image4"] as! String!
                    thisItem.imageStr5 = item["image5"] as! String!
                    thisItem.status = item["status"] as! String!
                    thisItem.timestamp = item["timestamp"] as! String!
                    
                    completion(result: thisItem)
                }
            }
        }
    }
    
    class func submitWithID(itemID: String, status: String, comment: String, completion: (result: AnyObject!) ->Void, failure: (error: String)-> Void) {
        
        var manager: AFHTTPRequestOperationManager = AFHTTPRequestOperationManager(baseURL:NSURL(string: Constant.MyUrl.homeURL))
        manager.requestSerializer = AFJSONRequestSerializer()
        manager.responseSerializer = AFJSONResponseSerializer()
        manager.responseSerializer.acceptableContentTypes = NSSet(object: "text/html") as Set<NSObject>
        
        manager.POST(Constant.MyUrl.Notification_Submit, parameters: nil, constructingBodyWithBlock: { (formData: AFMultipartFormData!) -> Void in
            formData.appendPartWithFormData(itemID.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false), name: "iid")
            formData.appendPartWithFormData(status.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false), name: "status")
            formData.appendPartWithFormData(comment.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false), name: "comment")
            }, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
                print(response)
                completion(result: nil)
                if let jsonData = response as? NSDictionary {
                    
                    let statusCode = numberFromJSONAnyObject(jsonData["return_code"])?.integerValue ?? 0
                        if statusCode == 0 {
                            completion(result: nil)
                        } else {
                            failure(error: "Error")
                        }
                }
            }) { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
            failure(error: error.description)
        }
        
            }
}