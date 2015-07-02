//
//  NotificationObject.swift
//  1Again
//
//  Created by Nam Phong on 6/28/15.
//  Copyright (c) 2015 Phong Nguyen Nam. All rights reserved.
//

import UIKit

class NotificationObject {
    var iid: String!
    var ownerId: String!
    var displayName: String!
    var category:  String!
    var itemId: String!
    var title: String!
    var desc: String!
    var image1:String!
    var status: String!
    var comment: String!
    var timestamp: String!
    
    init () {
        iid = String()
        ownerId = String()
        displayName = String()
        category = String()
        itemId = String()
        title = String()
        desc = String()
        image1 = String()
        status = String()
        comment = String()
        timestamp = String()
    }
    
    class func deleteNotification(item:String) {
        
        var urlData = Constant.MyUrl.homeURL.stringByAppendingString("V5.notification_update_acJSONPOST.php")
        var paramsData = ["status":"X", "iid":"\(item)"] as Dictionary<String, String>
        println("iid: \(item)")
        
        postJSON(paramsData, urlData)
    }
    
    class func getListOfNotifications(item:String, completionHandle: (notifications: [NotificationObject]) -> ()){
        
        var notificationArray:[NotificationObject] = []
        
        //    println("==== Notifications ====")
        
        var postURL = Constant.MyUrl.homeURL + Constant.MyUrl.notificationPage + "?id=" + item
        println(postURL)
        
        var url=NSURL(string:postURL)
        
        var data=NSData(contentsOfURL:url!)
        
        if let json = NSJSONSerialization.JSONObjectWithData(data!, options: nil, error: nil) as? NSDictionary {
            if let feed = json["notifications"] as? NSArray {
                println(feed)
                for entry in feed {
                    
                    var notifications = NotificationObject()
                    notifications.desc = entry["description"] as! String
                    notifications.displayName = entry["displayName"] as! String
                    notifications.iid = entry["iid"] as! String
                    notifications.ownerId = entry["ownerId"] as! String
                    notifications.category = entry["category"] as! String
                    notifications.itemId = entry["itemId"] as! String
                    notifications.image1 = entry["image1"] as! String
                    notifications.title = entry["title"] as! String
                    notifications.status = entry["status"] as! String
                    notifications.comment = entry["comment"] as! String
                    notifications.timestamp = entry["timestamp"] as! String
                    
                    println(notifications.desc)
                    println(notifications.image1)
                    
                    notificationArray.append(notifications)
                }
            }
        }
        
        completionHandle(notifications: notificationArray)
    }
}




