//
//  ChatAPI.swift
//  1Again
//
//  Created by Nam Phong on 7/17/15.
//  Copyright (c) 2015 Phong Nguyen Nam. All rights reserved.
//

import UIKit

class ChatAPI: NSObject {
    class func getAllMessage(imd: String, completion: (result: [Message]!)->Void, failure:(error: String) ->Void) {
        var param = ["imd": imd]
        
        DataManager.shareManager.mainManager.GET("V5.messages_get_ac.php", parameters: param, success: { (operation: AFHTTPRequestOperation!, responseData: AnyObject!) -> Void in
            
            let data:Dictionary<String, AnyObject> = (responseData as? Dictionary<String, AnyObject>)!
            
            if let messages = data["messages"] as? NSArray {
                var senderMessage: [Message] = [Message]()
                for _msg in messages {
                    let msg = Message()
                    msg.im_imd = _msg["IM_imd"] as! String
                    msg.id = _msg["id"] as! String
                    msg.message = _msg["message"] as! String
                    msg.receiverId = _msg["receiverId"] as! String
                    msg.senderId = _msg["senderId"] as! String
                    msg.timestamp = _msg["timestamp"] as! String
                    msg.type = _msg["type"] as! String
                    msg.jsqMessage = JSQMessage(senderId: msg.senderId, senderDisplayName: "TEST", date: getDataFromStr(msg.timestamp), text: msg.message)
                    senderMessage.append(msg)
                }
                completion(result: senderMessage)
            }
            print(responseData)
            }) { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
            failure(error: error.description)
        }
    }
}
