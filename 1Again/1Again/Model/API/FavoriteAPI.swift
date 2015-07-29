//
//  FavoriteAPI.swift
//  1Again
//
//  Created by Nam Phong on 7/16/15.
//  Copyright (c) 2015 Phong Nguyen Nam. All rights reserved.
//

import UIKit

class FavoriteAPI: NSObject {
    class func getFavoriteListWithType(type: String, completion:(responseData: AnyObject!) -> Void, failure:(error: String) -> Void) {
        var params:Dictionary<String, AnyObject> = Dictionary<String, AnyObject>()
        params[Constant.KEYs.User_ID] = NSUserDefaults.standardUserDefaults().integerForKey(Constant.UserDefaultKey.activeUserId)
        params[Constant.KEYs.Type] = type
        
        
        DataManager.shareManager.PostRequest(Constant.MyUrl.Favorite_GetList_API_URL, params: params, success: { (responseData) -> Void in
            
            if let data: Array<AnyObject> = responseData as? Array<AnyObject> {
                if type == "I" {
                    var senderItems: [Item] = [Item]()
                    for item in data {
                        let senderItem = Item()
                        senderItem.age = item["age"] as? String
                        senderItem.brand = item["brand"] as? String
                        senderItem.compensation = item["compensation"] as? String
                        senderItem.condition = item["conditionA"] as? String
                        senderItem.description = item["description"] as? String
                        senderItem.itemID = item["id"] as? String
                        senderItem.imageStr1 = item["image1"] as? String
                        senderItem.imageStr2 = item["image2"] as? String
                        senderItem.imageStr3 = item["image3"] as? String
                        senderItem.imageStr4 = item["image4"] as? String
                        senderItem.imageStr5 = item["image5"] as? String
                        senderItem.status = item["status"] as? String
                        senderItem.timestamp = item["timestamp"] as? String
                        senderItem.title = item["title"] as? String
                        
                        senderItems.append(senderItem)
                    }
                    completion(responseData: senderItems)
                } else if type == "U" {
                    var senderSellers: [User] = [User]()
                    for seller in data {
                        let senderSeller = User()
                        senderSeller.address1 = seller["Address1"] as? String
                        senderSeller.address2 = seller["Address2"] as? String
                        senderSeller.city = seller["City"] as? String
                        senderSeller.state = seller["State"] as? String
                        senderSeller.TS = seller["TS"] as? String
                        senderSeller.zipcode = seller["Zip"] as? String
                        senderSeller.displayName = seller["displayName"] as? String
                        senderSeller.email = seller["email"] as? String
                        senderSeller.favID = seller["favId"] as? String
                        senderSeller.id = seller["id"] as? String
                        senderSeller.lastName = seller["lastname"] as? String
                        senderSeller.latitude = seller["lat"] as? String
                        senderSeller.longitude = seller["lng"] as? String
                        senderSeller.name = seller["name"] as? String
                        senderSeller.password = seller["password"] as? String
                        senderSeller.phone = seller["phone"] as? String
                        senderSeller.premiumUser = seller["premiumUser"] as? String
                        senderSeller.timestamp = seller["timestamp"] as? String
                        senderSeller.type = seller["type"] as? String
                        senderSeller.userID = (seller["userId"] as? String)!
                        senderSeller.userType = (seller["userType"] as? String)!
                        senderSeller.usrRating = seller["usrRating"] as? String
                        senderSeller.usrReviewCount = seller["usrReviewCount"] as? String
                        senderSeller.usrReviewTotal = seller["usrReviewTotal"] as? String
                        
                        senderSellers.append(senderSeller)
                    }
                    completion(responseData: senderSellers)
                }
            }
            
        }) { (errorMessage) -> Void in
            failure(error: errorMessage)
        }
    }
}