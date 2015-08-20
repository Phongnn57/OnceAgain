//
//  NotificationAPI.swift
//  1Again
//
//  Created by Nam Phong on 7/16/15.
//  Copyright (c) 2015 Phong Nguyen Nam. All rights reserved.
//

import UIKit

class NotificationAPI: NSObject {
    
    class func getNotificationListWithUser(userID: String, completion: (newNoti: [Notification]!, savedNoti: [Notification]!, interestedNoti: [Notification]!)-> Void, failure:(error: String)->Void) {
        var param: Dictionary<String, AnyObject> = Dictionary<String, AnyObject>()
        param["id"] = userID
        DataManager.shareManager.PostRequest(Constant.MyUrl.Notification_List_API_URL, params: param, success: { (responseData) -> Void in
            
            if let data: Array<AnyObject> = responseData as? Array<AnyObject> {
                var newNotifications: [Notification] = [Notification]()
                var savedNotifications: [Notification] = [Notification]()
                var interestedNotifications: [Notification] = [Notification]()
                for obj in data {
                    let notification = Notification()
                    notification.desc = obj["description"] as? String
                    notification.displayName = obj["displayName"] as? String
                    notification.iid = obj["iid"] as? String
                    notification.ownerId = obj["ownerId"] as? String
                    notification.category = obj["category"] as? String
                    notification.itemId = obj["itemId"] as? String
                    notification.image1 = obj["image1"] as? String
                    notification.title = obj["title"] as? String
                    notification.status = obj["status"] as? String
                    notification.comment = obj["comment"] as? String
                    notification.timestamp = obj["timestamp"] as? String
                    notification.status = obj["status"] as? String
                    
                    if notification.status == "N" {
                        newNotifications.append(notification)
                    } else if notification.status == "S" {
                        savedNotifications.append(notification)
                    } else if notification.status == "Y" {
                        interestedNotifications.append(notification)
                    }
                }
                completion(newNoti: newNotifications, savedNoti: savedNotifications, interestedNoti: interestedNotifications)
            }
            
        }) { (errorMessage) -> Void in
            
        }
    }
    
    class func deleteNotification(itemID: String, completion:() -> Void, failure:(error: String) ->Void) {
        
        var params: Dictionary<String, AnyObject> = Dictionary<String, AnyObject>()
        params["status"] = "X"
        params["iid"] = itemID
        
        DataManager.shareManager.PostRequest(Constant.MyUrl.NOtification_Delete_API_URL, params: params, success: { (responseData) -> Void in
            completion()
        }) { (errorMessage) -> Void in
            failure(error: errorMessage)
        }
    }

    class func getNotificationDetailWithItem(itemID: String, completion: (result: AnyObject!)-> Void, failure:(error: String)->Void) {
        
        var params: Dictionary<String, AnyObject> = Dictionary<String, AnyObject>()
        params["id"] = itemID
        params["userId"] = User.sharedUser.userID
        
        DataManager.shareManager.PostRequest(Constant.MyUrl.Notification_Detail_API_URL, params: params, success: { (responseData) -> Void in
            if let arrData:Array<AnyObject> = responseData as? Array<AnyObject> {
                if let jsonData: Dictionary<String, AnyObject> = arrData[0] as? Dictionary<String, AnyObject> {
                    let senderObj = Item()
                    senderObj.age = jsonData["age"] as? String
                    senderObj.brand = jsonData["brand"] as? String
                    senderObj.category = jsonData["category"] as? String
                    senderObj.condition = jsonData["conditionA"] as? String
                    senderObj.description = jsonData["description"] as? String
                    senderObj.displayName = jsonData["displayName"] as? String
                    senderObj.itemID = jsonData["id"] as? String
                    senderObj.imageStr1 = jsonData["image1"] as? String
                    senderObj.imageStr2 = jsonData["image2"] as? String
                    senderObj.imageStr3 = jsonData["image3"] as? String
                    senderObj.imageStr4 = jsonData["image4"] as? String
                    senderObj.imageStr5 = jsonData["image5"] as? String
                    senderObj.ownerID = jsonData["ownerId"] as? String
                    senderObj.price = jsonData["price"] as? String
                    senderObj.status = jsonData["status"] as? String
                    senderObj.timestamp = jsonData["timestamp"] as? String
                    senderObj.title = jsonData["title"] as? String
                    completion(result: senderObj)
                }
            }
        }) { (errorMessage) -> Void in
            failure(error: errorMessage)
        }
    }
    
    class func submitWithID(itemID: String, status: String, comment: String, completion: (result: AnyObject!) ->Void, failure: (error: String)-> Void) {
        
        println(itemID)
        var params: Dictionary<String, AnyObject> = Dictionary<String, AnyObject>()
        params["iid"] = itemID
        params["status"] = status
        params["comment"] = comment
        
        DataManager.shareManager.PostRequest(Constant.MyUrl.Notification_Submit_API_URL, params: params, success: { (responseData) -> Void in
            completion(result: responseData)
        }) { (errorMessage) -> Void in
            failure(error: errorMessage)
        }
        
        
        
//        var manager: AFHTTPRequestOperationManager = AFHTTPRequestOperationManager(baseURL:NSURL(string: Constant.MyUrl.homeURL))
//        manager.requestSerializer = AFJSONRequestSerializer()
//        manager.responseSerializer = AFJSONResponseSerializer()
//        manager.responseSerializer.acceptableContentTypes = NSSet(object: "text/html") as Set<NSObject>
//        
//        manager.POST(Constant.MyUrl.Notification_Submit, parameters: nil, constructingBodyWithBlock: { (formData: AFMultipartFormData!) -> Void in
//            formData.appendPartWithFormData(itemID.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false), name: "iid")
//            formData.appendPartWithFormData(status.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false), name: "status")
//            formData.appendPartWithFormData(comment.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false), name: "comment")
//            }, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
//                print(response)
//                completion(result: nil)
//                if let jsonData = response as? NSDictionary {
//                    
//                    let statusCode = numberFromJSONAnyObject(jsonData["return_code"])?.integerValue ?? 0
//                        if statusCode == 0 {
//                            completion(result: nil)
//                        } else {
//                            failure(error: "Error")
//                        }
//                }
//            }) { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
//            failure(error: error.description)
//        }
        
    }
}