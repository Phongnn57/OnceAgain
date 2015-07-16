//
//  ItemAPI.swift
//  1Again
//
//  Created by Nam Phong on 7/10/15.
//  Copyright (c) 2015 Phong Nguyen Nam. All rights reserved.
//

import UIKit

class ItemAPI: NSObject {
    
    class func PostRequest(urlStr: String, params: Dictionary<String, AnyObject>, completion: (object: AnyObject!)->Void, failure: (error: String)->Void) {
        ModelManager.shareManager.postRequest(urlStr, params: params as! Dictionary<String, String>, success: { (responseData) -> Void in
            completion(object: responseData)
            }) { (error) -> Void in
                failure(error: error)
        }
    }
    
    //
    class func getItemList(url: String!, search: String!, condition: String!, category: String!, distance: String!, completion: (nextLink: String!, totalRecord: String!, items: [ItemObject]!) -> Void, failure:(error: String!)-> Void) {
        
        var params: Dictionary<String, String> = Dictionary<String, String>()
        
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
        
        if !search.isEmpty || !condition.isEmpty || !distance.isEmpty || !category.isEmpty {
            params["userid"] = "\(USER_ID)"
        }
        
        var mainManager = AFHTTPRequestOperationManager(baseURL: NSURL(string: Constant.MyUrl.homeURL))
        mainManager.responseSerializer = AFJSONResponseSerializer()
        mainManager.responseSerializer.acceptableContentTypes = NSSet(object: "text/html") as Set<NSObject>
        
        mainManager.GET(url, parameters: params, success: { (operation: AFHTTPRequestOperation!, responseData: AnyObject!) -> Void in
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
        }) { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
            failure(error: error.description)
        }
    
//        mainManager.POST(url, parameters: params, success: { (operation: AFHTTPRequestOperation!, responseData: AnyObject!) -> Void in
//            print(responseData)
//            var senderLink: String = ""
//            var senderTotalRecord: String = ""
//            var senderItems:[ItemObject] = []
//            if let response = responseData["paging"] as? NSArray {
//                if response.count > 0 {
//                    senderTotalRecord = response[0]["totalRecords"] as! String!
//                    senderLink = response[0]["next"] as! String
//                }
//            }
//            
//            if let items = responseData["items"] as? NSArray {
//                for item in items {
//                    var thisItem = ItemObject()
//                    thisItem.miles = item["miles"] as! String
//                    thisItem.id = item["id"] as! String
//                    thisItem.ownerId = (item["ownerId"] as! String).toInt()!
//                    thisItem.category = item["category"] as! String
//                    thisItem.title = item["title"] as! String!
//                    thisItem.description = item["description"] as! String!
//                    thisItem.imageStr1 = item["image1"] as! String!
//                    thisItem.timestamp = item["timestamp"] as! String!
//                    thisItem.price = item["price"] as! String!
//                    senderItems.append(thisItem)
//                }
//            }
//            
//            completion(nextLink: senderLink, totalRecord: senderTotalRecord, items: senderItems)
//            }) { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
//                failure(error: error.description)
//        }
    }
    
    //GET ITEM DETAIL
    class func getItem(itemid: String , completion: (item: ItemObject!) -> Void, failure:(error: String!)-> Void) {
        
        var url = NSURL(string: Constant.MyUrl.homeURL.stringByAppendingString(Constant.MyUrl.Item_Get_Item_Detail) + "?id=\(itemid)")
        var data: NSData = NSData(contentsOfURL: url!)!
        
        if let jsonData = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as? NSDictionary {
            println(jsonData)
            
            if let items = jsonData["item"] as? NSArray {
                for item in items {
                    var thisItem = ItemObject()
                    thisItem.id = item["id"] as! String
                    thisItem.displayName = item["displayName"] as! String
                    thisItem.ownerId = (item["ownerId"] as! String).toInt()!
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
                    
                    completion(item: thisItem)
                }
            }
        } else {
            failure(error: "Some thing went wrong!")
        }
        //        var params: Dictionary<String, String> = Dictionary<String, String>()
        //        params["id"] = itemid
        //
        //        ModelManager.shareManager.getRequest("V5.forSaleItem_JSONV2.php", params: params, success: { (responseData) -> Void in
        //
        //            var senderItem: ItemObject = ItemObject()
        //            if let jsonData = NSJSONSerialization.JSONObjectWithData(responseData as! NSData, options: nil, error: nil) as? NSDictionary {
        //                if let items = responseData["item"] as? NSArray {
        //                    for item in items {
        //                        var thisItem = ItemObject()
        //
        //                        thisItem.ownerId = (item["ownerId"] as! String).toInt()!
        //                        thisItem.id = item["id"] as! String
        //                        thisItem.displayName = item["displayName"] as! String
        //                        thisItem.category = item["category"] as! String
        //                        thisItem.title = item["title"] as! String
        //                        thisItem.brand = item["brand"] as! String!
        //                        thisItem.condition = item["conditionA"] as! String!
        //                        thisItem.age = item["age"] as! String!
        //                        thisItem.description = item["description"] as! String!
        //                        thisItem.price = item["price"] as! String!
        //                        thisItem.imageStr1 = item["image1"] as! String!
        //                        thisItem.imageStr2 = item["image2"] as! String!
        //                        thisItem.imageStr3 = item["image3"] as! String!
        //                        thisItem.imageStr4 = item["image4"] as! String!
        //                        thisItem.imageStr5 = item["image5"] as! String!
        //                        thisItem.status = item["status"] as! String!
        //                        thisItem.timestamp = item["timestamp"] as! String!
        //                        senderItem = thisItem
        //                    }
        //                }
        //            }
        //
        //            completion(item: senderItem)
        //
        //            }) { (error) -> Void in
        //                failure(error: error)
        //        }
    }
}
