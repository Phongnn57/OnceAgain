//
//  ItemAPI.swift
//  1Again
//
//  Created by Nam Phong on 7/10/15.
//  Copyright (c) 2015 Phong Nguyen Nam. All rights reserved.
//

import UIKit

class ItemAPI: NSObject {
    
    // MARK: ADD NEW ITEM
    class func addNewItem(item: Item, completion: () -> Void, failure:(error: String) ->Void) {
        DataManager.shareManager.PostRequestWithItem(Constant.MyUrl.Add_Item_API_URL, item: item, success: { (responseData) -> Void in
            completion()
        }) { (error) -> Void in
            failure(error: error)
        }
    }
    
    
    
    
    //GET LIST OF ITEM IN ITEM LIST VIEW
    class func getItemList(completion:(items :[Item]!)-> Void, failure:(error: String) ->Void) {
        
        var params: Dictionary<String, AnyObject> = Dictionary<String, AnyObject>()
        params["id"] = User.sharedUser.userID
        
        DataManager.shareManager.PostRequest(Constant.MyUrl.Item_List_API_URL, params: params, success: { (responseData) -> Void in
            if let jsonData: Array<AnyObject> = responseData as? Array<AnyObject> {
                var senderItems: [Item] = [Item]()
                for dic in jsonData {
                    let item = Item()
                    item.itemID = dic["id"] as? String
                    item.ownerID = dic["ownerId"] as? String
                    item.category = dic["category"] as? String
                    item.title = dic["title"] as? String
                    item.brand = dic["brand"] as? String
                    item.condition = dic["conditionA"] as? String
                    item.compensation = dic["compensation"] as? String
                    item.age = dic["age"] as? String
                    item.description = dic["description"] as? String
                    item.imageStr1 = dic["image1"] as? String
                    item.imageStr2 = dic["image2"] as? String
                    item.imageStr3 = dic["image3"] as? String
                    item.imageStr4 = dic["image4"] as? String
                    item.imageStr5 = dic["image5"] as? String
                    item.status = dic["status"] as? String
                    item.timestamp = dic["timestamp"] as? String
                    senderItems.append(item)
                }
                completion(items: senderItems)
            }
        }) { (errorMessage) -> Void in
            failure(error: errorMessage)
        }
    }
    
    class func archiveItem(itemID: String, completion: () ->Void, failure:(error: String)->Void) {
        var params: Dictionary<String, AnyObject> = Dictionary<String, AnyObject>()
        params["id"] = itemID
        params["status"] = "I"
        
        DataManager.shareManager.PostRequest(Constant.MyUrl.Item_UpdateItem_API_URL, params: params, success: { (responseData) -> Void in
            completion()
        }) { (errorMessage) -> Void in
            failure(error: errorMessage)
        }
        
    }
    
    
    class func getShopLocal(page: String, counter: String, category: String!, search: String!, miles: String!, condition: String!, completion:(items: [Item]!, nextLink: String!, counter: String, page: String, totalRecord: Int) ->Void, failure:(error: String)->Void) {
        var params: Dictionary<String, AnyObject> = Dictionary<String, AnyObject>()
        params["page"] = page
        params["counter"] = counter
        params["category"] = category
        params["search"] = search
        params["miles"] = miles
        params["condition"] = condition
        params["userId"] = User.sharedUser.userID
        
        
        DataManager.shareManager.PostRequest(Constant.MyUrl.Item_ShopLocal_Item_URL, params: params, success: { (responseData) -> Void in

            if let dataArr: Array<AnyObject> = responseData as? Array<AnyObject> {
                if let data: Dictionary<String, AnyObject> = responseData[0] as? Dictionary<String, AnyObject> {
                    var senderItem: [Item] = [Item]()
                    var page: String?
                    var nextLink: String?
                    var counter: String?
                    var totalRecord: Int = 0
                    if let paging: Array<AnyObject> = data["paging"] as? Array<AnyObject> {
                        if let pagingDic = paging[0] as? Dictionary<String, AnyObject> {
                            page = pagingDic["page"] as? String
                            nextLink = pagingDic["next"] as? String
                            counter = pagingDic["counter"] as? String
                            totalRecord =  Utilities.numberFromJSONAnyObject(pagingDic["totalRecords"])?.integerValue ?? 0
                        }
                    }
                    
                    if let items:Array<AnyObject> = data["items"] as? Array<AnyObject> {
                        for item in items {
                            var thisItem = Item()
                            thisItem.miles = item["miles"] as? String
                            thisItem.itemID = item["id"] as? String
                            thisItem.ownerID = item["ownerId"] as? String
                            thisItem.category = item["category"] as? String
                            thisItem.title = item["title"] as? String
                            thisItem.description = item["description"] as? String
                            thisItem.imageStr1 = item["image1"] as? String
                            thisItem.timestamp = item["timestamp"] as? String
                            thisItem.price = item["price"] as? String
                            senderItem.append(thisItem)
                        }
                    }
                    completion(items: senderItem, nextLink: nextLink, counter: counter!, page: page!, totalRecord: totalRecord)
                } else {
                    failure(error: "ERROR")
                }
            }
            
            }) { (errorMessage) -> Void in
                failure(error: errorMessage)
        }
    }
    
    class func getItem(itemid: String , completion: (item: Item!) -> Void, failure:(error: String!)-> Void) {
        var params: Dictionary<String, AnyObject> = Dictionary<String, AnyObject>()
        params["id"] = itemid
        
        DataManager.shareManager.PostRequest(Constant.MyUrl.Item_GetItemDetail_API_URL, params: params, success: { (responseData) -> Void in
            if let items: Array<AnyObject> = responseData as? Array<AnyObject> {
                for item in items {
                    var thisItem = Item()
                    thisItem.itemID = item["id"] as? String
                    thisItem.displayName = item["displayName"] as? String
                    thisItem.ownerID = item["ownerId"] as? String
                    thisItem.category = item["category"] as? String
                    thisItem.title = item["title"] as? String
                    thisItem.brand = item["brand"] as? String!
                    thisItem.condition = item["conditionA"] as? String!
                    thisItem.age = item["age"] as? String
                    thisItem.description = item["description"] as? String
                    thisItem.price = item["price"] as? String
                    thisItem.imageStr1 = item["image1"] as? String
                    thisItem.imageStr2 = item["image2"] as? String
                    thisItem.imageStr3 = item["image3"] as? String
                    thisItem.imageStr4 = item["image4"] as? String
                    thisItem.imageStr5 = item["image5"] as? String
                    thisItem.status = item["status"] as? String
                    thisItem.timestamp = item["timestamp"] as? String
                    
                    completion(item: thisItem)
                }
            }
        }) { (errorMessage) -> Void in
            failure(error: errorMessage)
        }
    }
    
    class func postItemWithParams(params: Dictionary<String, AnyObject>, completion: (object: AnyObject!)->Void, failure: (error: String)->Void) {
        DataManager.shareManager.mainManager.POST(Constant.MyUrl.Item_Detail_Favorite_API_URL, parameters: nil, constructingBodyWithBlock: { (formData: AFMultipartFormData!) -> Void in
            for key in params.keys.array {
                if let sValue: AnyObject = params[key] {
                    var value: String = (sValue as? String)!
                    formData.appendPartWithFormData(value.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false), name: key)
                }
            }
            
            }, success: { (operation: AFHTTPRequestOperation!, responseData: AnyObject!) -> Void in
                print(responseData)
                
                if let jsonData = responseData as? NSDictionary {
                    
                    let statusCode = numberFromJSONAnyObject(jsonData["return_code"])?.integerValue ?? 0
                    if statusCode == 0 {
                        completion(object: responseData)
                    } else {
                        failure(error: "Error")
                    }
                }
            }) { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                failure(error: error.description)
        }
    }
}
