//
//  MessageAPI.swift
//  1Again
//
//  Created by Nam Phong on 7/27/15.
//  Copyright (c) 2015 Phong Nguyen Nam. All rights reserved.
//

import UIKit

class MessageAPI: NSObject {
   
    class func getMessages(completion: (result: [Message]!) ->Void, failure:(error: String)->Void) {
        var params: Dictionary<String, String> = Dictionary<String, String>()
        params["id"] = User.sharedUser.userID
        
        DataManager.shareManager.PostRequest(Constant.MyUrl.Message_GetMessage_List_API_URL, params: params, success: { (responseData) -> Void in
            if let arr: Array<AnyObject> = responseData as? Array<AnyObject> {
                var messages: [Message] = [Message]()
                for dic in arr {
                    let msg = Message()
                    msg.displayName = dic["displayName"] as? String
                    msg.id = dic["id"] as? String
                    msg.type = dic["type"] as? String
                    msg.comment = dic["comment"] as? String
                    msg.status = dic["status"] as? String
                    msg.ownerstatus = dic["ownerstatus"] as? String
                    msg.iid = dic["iid"] as? String
                    msg.entityId = dic["entityId"] as? String
                    msg.lng = dic["lng"] as? String
                    msg.lat = dic["lat"] as? String
                    msg.address1 = dic["address1"] as? String
                    msg.city = dic["city"] as? String
                    msg.state = dic["state"] as? String
                    msg.zip = dic["zip"] as? String
                    msg.title = dic["title"] as? String
                    msg.descrip = dic["descrip"] as? String
                    msg.image1 = dic["image1"] as? String
                    msg.distance = dic["distance"] as? String
                    msg.timestamp = dic["timestamp"] as? String
                    msg.newIndicator = Utilities.numberFromJSONAnyObject(dic["newIndicator"])!.integerValue
                    
                    messages.append(msg)
                }
                completion(result: messages)
            }

        }) { (errorMessage) -> Void in
            failure(error: errorMessage)
        }
    }
    
    
    class func deleteMessage(messageID: String, completion:(result: AnyObject!) ->Void, failure:(error: String)->Void) {
        var params: Dictionary<String, String> = Dictionary<String, String>()
        params["status"] = "D"
        params["iid"] = messageID
        params["userId"] = User.sharedUser.userID
        
        DataManager.shareManager.PostRequest(Constant.MyUrl.Message_DeleteMessage_API_URL, params: params, success: { (responseData) -> Void in
            completion(result: nil)
        }) { (errorMessage) -> Void in
            failure(error: errorMessage)
        }
    }
    
    class func getChatHistory(imd: String, completion: (result: [Message]!)->Void, failure:(error: String) ->Void) {
        var params: Dictionary<String, String> = Dictionary<String, String>()
        params["imd"] = imd
        params["userId"] = User.sharedUser.userID
        
        DataManager.shareManager.PostRequest(Constant.MyUrl.Chat_GetChatHistory_API_URL, params: params, success: { (responseData) -> Void in
            
            if let messages: Array<AnyObject> = responseData as? Array<AnyObject> {
                var senderMessage: [Message] = [Message]()
                for _msg in messages {
                    let msg = Message()
                    msg.im_imd = _msg["IM_imd"] as? String
                    msg.id = _msg["id"] as? String
                    msg.message = _msg["message"] as? String
                    msg.receiverId = _msg["receiverId"] as? String
                    msg.senderId = _msg["senderId"] as? String
                    msg.timestamp = _msg["timestamp"] as? String
                    msg.type = _msg["type"] as? String
                    msg.jsqMessage = JSQMessage(senderId: msg.senderId, senderDisplayName: "TEST", date: getDataFromStr(msg.timestamp!), text: msg.message)
                    senderMessage.append(msg)
                }
                completion(result: senderMessage)
            }
            
            
        }) { (errorMessage) -> Void in
            failure(error: errorMessage)
        }
    }

    
    class func sendNewMessage(imd: String, senderID: String, receiverID: String, status: String, message: String, completion: (result: AnyObject!) -> Void, failure:(error: String)-> Void) {
        var params: Dictionary<String, String> = Dictionary<String, String>()
        params["imd"] = imd
        params["userId"] = senderID
        params["receiverId"] = receiverID
        params["status"] = status
        params["message"] = message
        println(params)
        
        DataManager.shareManager.PostRequest(Constant.MyUrl.Chat_Send_Message_API_URL, params: params, success: { (responseData) -> Void in
            completion(result: nil)
        }) { (errorMessage) -> Void in
            failure(error: errorMessage)
        }
    }
    
}
