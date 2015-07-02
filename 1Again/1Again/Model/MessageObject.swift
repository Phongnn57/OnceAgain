//
//  MessageObject.swift
//  1Again
//
//  Created by Nam Phong on 7/1/15.
//  Copyright (c) 2015 Phong Nguyen Nam. All rights reserved.
//

import UIKit

class MessageObject {
    var iid: String = String()
    var itemId: String = String()
    var name: String = String()
    var address1: String = String()
    var address2: String = String()
    var desc: String = String()
    var title: String = String()
    var distance: String = String()
    var lng: String = String()
    var lat: String = String()
    var image1:String = String()
    var status: String = String()
    var comment: String = String()
    var timestamp: String = String()
    
    init() {
         iid = String()
         itemId = String()
         name = String()
         address1 = String()
         address2 = String()
         desc = String()
         title = String()
         distance = String()
         lng = String()
         lat = String()
         image1 = String()
         status = String()
         comment = String()
         timestamp = String()
    }
    
    class func deleteMessage(item:String) {
        
        var urlData = Constant.MyUrl.homeURL.stringByAppendingString("V5.message_update_acJSONPOST.php")
        var paramsData = ["status":"D", "iid":"\(item)"] as Dictionary<String, String>
        
        postJSON(paramsData, urlData)
    }
    
    class func sendMessage(item:String,ownerId:String,userId:String) {
        
        var urlData = Constant.MyUrl.homeURL.stringByAppendingString("V5.message_insert_ac.php")
        var paramsData = ["itemId":"\(item)","userId":"\(userId)","action":"Y","ownerId":"\(ownerId)"] as Dictionary<String, String>
        postJSON(paramsData, urlData)
    }
    
    class func getListOfMessages(item:String, completionClosure: (msgObjects: [MessageObject]) -> ()){
        
        var messageArray:[MessageObject] = []

        var postURL = Constant.MyUrl.homeURL + "V5.messages.ListJSON.php?id=" + item
        
        var url=NSURL(string:postURL)
        
        var data=NSData(contentsOfURL:url!)
        
        if let json = NSJSONSerialization.JSONObjectWithData(data!, options: nil, error: nil) as? NSDictionary {
            if let feed = json["messages"] as? NSArray {
                println(feed)
                for entry in feed {
                    
                    var messages = MessageObject()
                    messages.desc = entry["description"] as! String
                    messages.name = entry["displayName"] as! String
                    messages.iid = entry["iid"] as! String
                    messages.distance = entry["distance"] as! String
                    messages.lng = entry["lng"] as! String
                    messages.lat = entry["lat"] as! String
                    messages.address1 = entry["address1"] as! String
                    messages.image1 = entry["image1"] as! String
                    messages.title = entry["title"] as! String
                    var cityValue = entry["city"] as! String
                    var stateValue = entry["state"] as! String
                    var zipValue = entry["zip"] as! String
                    messages.status = entry["status"] as! String
                    messages.comment = entry["comment"] as! String
                    messages.timestamp = entry["timestamp"] as! String
                    
                    messages.address2 = cityValue + ", " + stateValue + " " + zipValue
                    
                    println(messages.desc)
                    println(messages.image1)
                    
                    messageArray.append(messages)
                }
            }
        }
        completionClosure(msgObjects: messageArray)
    }

}
