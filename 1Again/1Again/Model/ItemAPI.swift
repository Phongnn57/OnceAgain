//
//  ItemAPI.swift
//  1Again
//
//  Created by Nam Phong on 7/10/15.
//  Copyright (c) 2015 Phong Nguyen Nam. All rights reserved.
//

import UIKit

class ItemAPI: NSObject {
   
    //
    class func getItemList(url: String!, search: String!, condition: String!, category: String!, distance: String!, completion: (nextLink: String!, totalRecord: String!, items: [ItemObject]!) -> Void, failure:(error: String!)-> Void) {
        
        var params: Dictionary<String, String> = Dictionary<String, String>()
        params["userid"] = "\(NSUserDefaults.standardUserDefaults().integerForKey(Constant.UserDefaultKey.activeUserId))"
        if !search.isEmpty {
            params["search"] = search
        }
        if !condition.isEmpty {
            params["condition"] = condition
        }
        if !category.isEmpty {
            params["category"] = category
        }
        if !distance.isEmpty {
            params["distance"] = distance
        }

        ModelManager.shareManager.getRequest(url, params: params, success: { (responseData) -> Void in
            print(responseData)
            var senderLink: String = ""
            var senderTotalRecord: String = ""
            var senderItems:[ItemObject] = []
            if let response = responseData["paging"] as? NSArray {
                if response.count > 0 {
                    senderTotalRecord = response[0]["totalRecords"] as! String!
                    senderLink = response[0]["next"] as! String
                }
            }
            
            if let items = responseData["items"] as? NSArray {
                for item in items {
                    var thisItem = ItemObject()
                    thisItem.miles = item["miles"] as! String
                    thisItem.id = item["id"] as! String
                    thisItem.ownerId = (item["ownerId"] as! String).toInt()!
                    thisItem.category = item["category"] as! String
                    thisItem.title = item["title"] as! String!
                    thisItem.description = item["description"] as! String!
                    thisItem.imageStr1 = item["image1"] as! String!
                    thisItem.timestamp = item["timestamp"] as! String!
                    thisItem.price = item["price"] as! String!
                    senderItems.append(thisItem)
                }
            }
            completion(nextLink: senderLink, totalRecord: senderTotalRecord, items: senderItems)
            
            }) { (error) -> Void in
                failure(error: error)
        }
    }
    
    
    //GET ITEM DETAIL
    class func getItem(itemid: String , completion: (item: ItemObject!) -> Void, failure:(error: String!)-> Void) {
        
        var params: Dictionary<String, String> = Dictionary<String, String>()
        params["id"] = itemid

        ModelManager.shareManager.getRequest("V5.forSaleItem_JSONV2.php", params: params, success: { (responseData) -> Void in
            print(responseData)
            
            var senderItem: ItemObject = ItemObject()
            if let jsonData = NSJSONSerialization.JSONObjectWithData(responseData as! NSData, options: nil, error: nil) as? NSDictionary {
                if let items = jsonData["item"] as? NSArray {
                    for item in items {
                        var thisItem = ItemObject()
                        
                        thisItem.ownerId = (item["ownerId"] as! String).toInt()!
                        thisItem.id = item["id"] as! String
                        thisItem.displayName = item["displayName"] as! String
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
                        senderItem = thisItem
                    }
                }
            }
            
            completion(item: senderItem)
            
            }) { (error) -> Void in
                failure(error: error)
        }
    }
}
