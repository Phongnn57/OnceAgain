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
    }
    
    class func postComment(itemId: String, displayName: String, comment: String, completion: (object: AnyObject!) ->Void, failure: (error: String) -> Void) {
        var param:Dictionary<String, String> = Dictionary<String, String>()
        param["id"] = itemId
        param["displayName"] = displayName
        param["comment"] = comment
        
        var manager = AFHTTPRequestOperationManager()
        manager.responseSerializer = AFHTTPResponseSerializer()
        manager.POST(Constant.MyUrl.homeURL + Constant.MyUrl.Item_Add_Comment, parameters: param, success: { (operation: AFHTTPRequestOperation!, responseData: AnyObject!) -> Void in
            completion(object: responseData)
            }) { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                failure(error: error.description)
        }
    }
}