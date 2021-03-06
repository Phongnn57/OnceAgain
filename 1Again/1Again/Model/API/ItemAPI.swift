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
    
    
    class func getShopLocal(page: String, counter: String, category: String!, search: String!, miles: String!, condition: [String]!, completion:(items: [Item]!, nextLink: String!, counter: String, page: String, totalRecord: Int, loadMore: Bool) ->Void, failure:(error: String)->Void) {
        var params: Dictionary<String, AnyObject> = Dictionary<String, AnyObject>()
        params["page"] = page
        params["counter"] = counter
        params["category"] = category
        params["search"] = search
        params["miles"] = miles
        params["seller"] = condition
        params["userId"] = User.sharedUser.userID
        
        
        DataManager.shareManager.PostRequest(Constant.MyUrl.Item_ShopLocal_Item_URL, params: params, success: { (responseData) -> Void in

            if let dataArr: Array<AnyObject> = responseData as? Array<AnyObject> {
                if let data: Dictionary<String, AnyObject> = responseData[0] as? Dictionary<String, AnyObject> {
                    var senderItem: [Item] = [Item]()
                    var page: String?
                    var nextLink: String?
                    var counter: String?
                    var totalRecord: Int = 0
                    var loadMore: Bool = true
                    if let paging: Array<AnyObject> = data["paging"] as? Array<AnyObject> {
                        if let pagingDic = paging[0] as? Dictionary<String, AnyObject> {
                            page = pagingDic["page"] as? String
                            nextLink = pagingDic["next"] as? String
                            counter = pagingDic["counter"] as? String
                            totalRecord =  Utilities.numberFromJSONAnyObject(pagingDic["totalRecords"])?.integerValue ?? 0
                        }
                    }
                    
                    if let items:Array<AnyObject> = data["items"] as? Array<AnyObject> {
                        if items.count > 0 {
                            loadMore = true
                        } else {
                            loadMore = false
                        }
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
                    completion(items: senderItem, nextLink: nextLink, counter: counter!, page: page!, totalRecord: totalRecord, loadMore: loadMore)
                } else {
                    failure(error: "ERROR")
                }
            }
            
            }) { (errorMessage) -> Void in
                failure(error: errorMessage)
        }
    }
    
    class func updateAdsClickingCount(itemID: String, completion:()->Void, failure:(error: String)->Void) {
        var params: Dictionary<String, AnyObject> = Dictionary<String, AnyObject>()
        params["id"] = itemID
        
        DataManager.shareManager.PostRequest(Constant.MyUrl.Ads_Clicking_Count_API_URL, params: params, success: { (responseData) -> Void in
            completion()
        }) { (errorMessage) -> Void in
            failure(error: errorMessage)
        }
    }
    
    class func getItem(itemid: String , completion: (item: Item!) -> Void, failure:(error: String!)-> Void) {
        var params: Dictionary<String, AnyObject> = Dictionary<String, AnyObject>()
        params["id"] = itemid
        params["userId"] = User.sharedUser.userID
        
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
                    thisItem.favItem = item["favItem"] as? String
                    thisItem.favOwner = item["favOwner"] as? String
                    
                    completion(item: thisItem)
                }
            }
        }) { (errorMessage) -> Void in
            failure(error: errorMessage)
        }
    }
    
    class func postItemWithParams(params: Dictionary<String, AnyObject>, completion: (object: AnyObject!)->Void, failure: (error: String)->Void) {
        DataManager.shareManager.PostRequest(Constant.MyUrl.Item_Detail_Favorite_API_URL, params: params, success: { (responseData) -> Void in
            completion(object: nil)
        }) { (errorMessage) -> Void in
            failure(error: errorMessage)
        }
    }
    
    class func takeItem(params: Dictionary<String, AnyObject>, completion: (object: AnyObject!)->Void, failure: (error: String)->Void) {
        DataManager.shareManager.PostRequest(Constant.MyUrl.Item_Detail_Take_Action_API_URL, params: params, success: { (responseData) -> Void in
            completion(object: nil)
            }) { (errorMessage) -> Void in
                failure(error: errorMessage)
        }
    }
    
    class func itemWithCount(itemID: String, completion:(data: AnyObject)->Void, failure:(error: String)->Void) {
        var params: Dictionary<String, AnyObject> = Dictionary<String, AnyObject>()
        params["itemId"] = itemID
        
        DataManager.shareManager.PostRequest(Constant.MyUrl.Item_ItemCount_API_URL, params: params, success: { (responseData) -> Void in
            completion(data: responseData)
        }) { (errorMessage) -> Void in
            failure(error: errorMessage)
        }
    }
    
    // MARK: Item Detail
    class func getNotificationOfItem(itemID: String, completion:(notifications: [Notification]!)->Void, failure:(error: String)->Void) {
        var params: Dictionary<String, AnyObject> = Dictionary<String, AnyObject>()
        params["userId"] = User.sharedUser.userID
        params["itemId"] = itemID
        
        DataManager.shareManager.PostRequest(Constant.MyUrl.Item_NotificationItem_API_URL, params: params, success: { (responseData) -> Void in
            if let arr:Array<AnyObject> = responseData as? Array<AnyObject> {
                var senderArr: [Notification] = []
                for obj in arr {
                    let noti = Notification()
                    noti.displayName = obj["displayName"] as? String ?? ""
                    noti.id = obj["id"] as? String ?? ""
                    noti.comment = obj["comment"] as? String ?? ""
                    noti.status = obj["status"] as? String ?? ""
                    noti.iid = obj["iid"] as? String ?? ""
                    noti.itemId = obj["itemId"] as? String ?? ""
                    noti.title = obj["title"] as? String ?? ""
                    noti.distance = obj["distance"] as? String ?? ""
                    noti.timestamp = obj["timestamp"] as? String ?? ""
                    noti.image1 = obj["profileImage"] as? String ?? ""
                    
                    senderArr.append(noti)
                }
                completion(notifications: senderArr)
            }
        }) { (errorMessage) -> Void in
            failure(error: errorMessage)
        }
    }
    
    class func getMessageOfItem(itemID: String, completion:(messages: [Message]!)->Void, failure:(error: String)->Void) {
        var params: Dictionary<String, AnyObject> = Dictionary<String, AnyObject>()
        params["userId"] = User.sharedUser.userID
        params["itemId"] = itemID
        
        DataManager.shareManager.PostRequest(Constant.MyUrl.Item_MessageItem_API_URL, params: params, success: { (responseData) -> Void in
            if let arr:Array<AnyObject> = responseData as? Array<AnyObject> {
                var senderArr: [Message] = []
                for obj in arr {
                    let mess = Message()

                    mess.displayName = obj["displayName"] as? String
                    mess.id = obj["id"] as? String
                    mess.type = obj["type"] as? String
                    mess.comment = obj["comment"] as? String
                    mess.status = obj["status"] as? String
                    mess.ownerstatus = obj["ownerstatus"] as? String
                    mess.entityStatus = obj["entitystatus"] as? String
                    mess.iid = obj["iid"] as? String
                    mess.entityId = obj["entityId"] as? String
                    mess.lng = obj["lng"] as? String
                    mess.lat = obj["lat"] as? String
                    mess.address1 = obj["address1"] as? String
                    mess.city = obj["city"] as? String
                    mess.state = obj["state"] as? String
                    mess.zip = obj["zip"] as? String
                    mess.itemId = obj["itemId"] as? String
                    mess.image1 = obj["image1"] as? String
                    mess.title = obj["title"] as? String
                    mess.descrip = obj["description"] as? String
                    mess.distance = obj["distance"] as? String
                    mess.senderId = obj["senderId"] as? String
                    mess.message = obj["message"] as? String
                    mess.newIndicator = Utilities.numberFromJSONAnyObject(obj["newIndicator"])!.integerValue
                    mess.newIndicatorEntity = Utilities.numberFromJSONAnyObject(obj["newIndicatorEntity"])!.integerValue
                    mess.timestamp = obj["timestamp"] as? String
                    mess.jsqMessage = JSQMessage(senderId: mess.senderId, senderDisplayName: "TEST", date: getDataFromStr(mess.timestamp!), text: mess.message)
                    
                    senderArr.append(mess)
                }
                completion(messages: senderArr)
            }
            }) { (errorMessage) -> Void in
                failure(error: errorMessage)
        }
    }
    
    class func itemActionInfo(imd: String, completion: (profileImage: String, sellerName: String, buyerName: String, title: String, image1: String, ownerID: String, buyerID: String, status: String, itemID: String, date: String)->Void, failure:(error: String)->Void) {
        var param: Dictionary<String, AnyObject> = Dictionary<String,AnyObject>()
        param["imd"] = imd
        
        DataManager.shareManager.PostRequest(Constant.MyUrl.Item_ItemAction_API_URL, params: param, success: { (responseData) -> Void in
            
            if let dataArr: Array<AnyObject> = responseData as? Array<AnyObject> {
                if let response:Dictionary<String, AnyObject> = dataArr.first as? Dictionary<String, AnyObject> {
                    let profileImage = response["profileImage"] as! String
                    let sellerName = response["sellerName"] as! String
                    let buyerName = response["buyerName"] as! String
                    let title = response["title"] as! String
                    let image1 = response["image1"] as! String
                    let ownerID = response["ownerId"] as! String
                    let buyerID = response["buyerId"] as! String
                    let status = response["status"] as! String
                    let itemID = response["id"] as! String
                    let timeStamp = response["timestamp"] as! String
                    let dateTime = timeStamp.toDate(format: "yyyy-MM-dd HH:mm:ss")
                    let senderTime = dateTime?.toString()
                    
                    completion(profileImage: profileImage, sellerName: sellerName, buyerName: buyerName, title: title, image1: image1, ownerID: ownerID, buyerID: buyerID, status: status, itemID: itemID, date: senderTime!)
                } else {
                    failure(error: "Error while loading data")
                    
                }
            } else {
                failure(error: "Error while loading data")
            }
            
        }) { (errorMessage) -> Void in
            failure(error: errorMessage)
        }
        
    }
    
    class func updateItemStatus(status: String, imd: String, receivedID: String, itemID: String, comment: String, completion: ()->Void, failure: (error: String)->Void) {
        var params: Dictionary<String, AnyObject> = Dictionary<String, AnyObject>()
        params["imd"] = imd
        params["userId"] = User.sharedUser.userID
        params["receiverId"] = receivedID
        params["itemId"] = itemID
        params["status"] = status
        params["comment"] = comment
        
        DataManager.shareManager.PostRequest(Constant.MyUrl.Item_UpdateItemAction, params: params, success: { (responseData) -> Void in
            completion()
        }) { (errorMessage) -> Void in
            failure(error: errorMessage)
        }
    }
    
    class func getNotification(itemID: String, completion: (messages: [Message]!)->Void, failure:(error: String)->Void) {
        var params: Dictionary<String, AnyObject> = Dictionary<String, AnyObject>()
        params["userId"] = User.sharedUser.userID
        params["itemId"] = itemID
        
        DataManager.shareManager.PostRequest(Constant.MyUrl.Item_NotificationItem_API_URL, params: params, success: { (responseData) -> Void in
            
        }) { (errorMessage) -> Void in
            failure(error: errorMessage)
        }
        
    }
    
    class func postNewReviewForItem(itemID: String, ratedID: String, star: Double, comment: String, completion:()->Void, failure:(error: String)->Void) {
        var params: Dictionary<String, AnyObject> = Dictionary<String,AnyObject>()
        params["userId"] = User.sharedUser.userID
        params["ratedId"] = ratedID
        params["stars"] = star
        params["comment"] = comment
        params["itemId"] = itemID
        
        DataManager.shareManager.PostRequest("V6.review_insert.php", params: params, success: { (responseData) -> Void in
            completion()
        }) { (errorMessage) -> Void in
            failure(error: errorMessage)
        }
    }
}
