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
        
        ModelManager.shareManager.postRequest("forSaleItemGetComments_JSONV2.php", params: nil, success: { (responseData) -> Void in
            var senderComments: [CommentObject] = []
            if let items = responseData["comments"] as? NSArray {
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
            completion(comments: senderComments)
        }) { (error) -> Void in
            failure(error: error)
        }
    }
}