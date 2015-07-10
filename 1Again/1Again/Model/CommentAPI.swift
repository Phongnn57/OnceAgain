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
        var url = NSURL(string: Constant.MyUrl.homeURL.stringByAppendingString("forSaleItemGetComments_JSONV2.php?id=\(itemID)"))
        var data: NSData = NSData(contentsOfURL: url!)!
        var senderComments: [CommentObject] = []
        if let jsonData = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as? NSDictionary {
            if let items = jsonData["comments"] as? NSArray {
                for comment in items {
                    var thisComment = CommentObject()
                    thisComment.commentID = comment["commentId"] as! String!
                    thisComment.itemID = comment["itemId"] as! String!
                    thisComment.displayName = comment["displayName"] as! String!
                    thisComment.comment = comment["comment"] as! String!
                    thisComment.timestamp = comment["timestamp"] as! String!
                    senderComments.append(thisComment)
                }
            }
        }
        completion(comments: senderComments)
//        var param:Dictionary<String, String> = Dictionary<String, String>()
//        param["id"] = itemID
//        
//        ModelManager.shareManager.getRequest("forSaleItemGetComments_JSONV2.php", params: nil, success: { (responseData) -> Void in
//            var senderComments: [CommentObject] = []
//            if let jsonData = NSJSONSerialization.JSONObjectWithData(responseData as! NSData, options: nil, error: nil) as? NSDictionary {
//                if let items = jsonData["comments"] as? NSArray {
//                    for comment in items {
//                        var thisComment = CommentObject()
//                        thisComment.commentID = comment["commentId"] as! String!
//                        thisComment.itemID = comment["itemId"] as! String!
//                        thisComment.displayName = comment["displayName"] as! String!
//                        thisComment.comment = comment["comment"] as! String!
//                        thisComment.timestamp = comment["timestamp"] as! String!
//                        senderComments.append(thisComment)
//                    }
//                }
//            }
//            
//            completion(comments: senderComments)
//        }) { (error) -> Void in
//            failure(error: error)
//        }
    }
    
    class func postComment(itemId: String, displayName: String, comment: String, completion: (object: AnyObject!) ->Void, failure: (error: String) -> Void) {
        var param:Dictionary<String, String> = Dictionary<String, String>()
        param["id"] = itemId
        param["displayName"] = displayName
        param["comment"] = comment
        
        ModelManager.shareManager.postRequest("forSaleItemAddComment_V2.php", params: param, success: { (responseData) -> Void in
            completion(object: responseData)
        }) { (error) -> Void in
            failure(error: error)
        }
    }
}