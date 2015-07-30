//
//  CommentAPI.swift
//  1Again
//
//  Created by Nam Phong on 7/10/15.
//  Copyright (c) 2015 Phong Nguyen Nam. All rights reserved.
//

import UIKit

class CommentAPI: NSObject {
    class func getAllComment(itemID: String, completion: (comments: [CommentObject]!) -> Void, failure:(error: String) -> Void) {
        
        var param:Dictionary<String, String> = Dictionary<String, String>()
        param["id"] = itemID
        
        DataManager.shareManager.PostRequest(Constant.MyUrl.Item_GetComment_API_URL, params: param, success: { (responseData) -> Void in
            if let arr: Array<AnyObject> = responseData as? Array<AnyObject> {
                var senderComments: [CommentObject] = [CommentObject]()
                for obj in arr {
                    let comment = CommentObject()
                    comment.comment = obj["comment"] as! String
                    comment.commentID = obj["commentId"] as! String
                    comment.displayName = obj["displayName"] as! String
                    comment.itemID = obj["itemId"] as! String
                    comment.timestamp = obj["timestamp"] as! String
                    senderComments.append(comment)
                }
                completion(comments: senderComments)
            }
        }) { (errorMessage) -> Void in
            failure(error: errorMessage)
        }

    }
    
    class func postComment(itemId: String, displayName: String, comment: String, completion: (object: AnyObject!) ->Void, failure: (error: String) -> Void) {
        var param:Dictionary<String, String> = Dictionary<String, String>()
        param["id"] = itemId
        param["displayName"] = displayName
        param["comment"] = comment
        
        
        DataManager.shareManager.PostRequest(Constant.MyUrl.Item_AddComment_API_URL, params: param, success: { (responseData) -> Void in
            completion(object: responseData)
        }) { (errorMessage) -> Void in
            failure(error: errorMessage)
        }
    }
}