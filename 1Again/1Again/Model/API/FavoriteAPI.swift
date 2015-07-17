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
        var param:Dictionary<String, AnyObject> = Dictionary<String, AnyObject>()
        param[Constant.KEYs.User_ID] = "95"
        param[Constant.KEYs.Type] = type
        
        var manager: AFHTTPRequestOperationManager = AFHTTPRequestOperationManager(baseURL:NSURL(string: Constant.MyUrl.homeURL))
        manager.requestSerializer = AFJSONRequestSerializer()
        manager.responseSerializer = AFJSONResponseSerializer()
        manager.responseSerializer.acceptableContentTypes = NSSet(object: "text/html") as Set<NSObject>
        
        
        manager.GET(Constant.MyUrl.Favorite_GetList, parameters: param, success: { (operation: AFHTTPRequestOperation!, responseData: AnyObject!) -> Void in
            print(responseData)
            
            let data:Dictionary<String, AnyObject> = (responseData as? Dictionary<String, AnyObject>)!

                if let items = data["myFavorite"] as? NSArray {
                    if type == "I" {
                    var senderItems: [ItemObject] = [ItemObject]()
                    for item in items {
                        let senderItem = ItemObject()
                        senderItem.age = item["age"] as! String
                        senderItem.brand = item["brand"] as! String
                        senderItem.compensation = item["compensation"] as! String
                        senderItem.condition = item["conditionA"] as! String
                        senderItem.description = item["description"] as! String
                        senderItem.id = item["id"] as! String
                        senderItem.imageStr1 = item["image1"] as! String
                        senderItem.imageStr2 = item["image2"] as! String
                        senderItem.imageStr3 = item["image3"] as! String
                        senderItem.imageStr4 = item["image4"] as! String
                        senderItem.imageStr5 = item["image5"] as! String
                        senderItem.status = item["status"] as! String
                        senderItem.timestamp = item["timestamp"] as! String
                        senderItem.title = item["title"] as! String
                        
                        senderItems.append(senderItem)
                    }
                    completion(responseData: senderItems)
                    } else if type == "U" {
                        var senderSellers: [UserObject] = [UserObject]()
                        for seller in items {
                            let senderSeller = UserObject()
                            senderSeller.address1 = seller["Address1"] as! String
                            senderSeller.address2 = seller["Address2"] as! String
                            senderSeller.city = seller["City"] as! String
                            senderSeller.state = seller["State"] as! String
                            senderSeller.TS = seller["TS"] as! String
                            senderSeller.zipCode = seller["Zip"] as! String
                            senderSeller.displayName = seller["displayName"] as! String
                            senderSeller.email = seller["email"] as! String
                            senderSeller.favID = seller["favId"] as! String
                            senderSeller.id = (seller["id"] as! String).toInt()
                            senderSeller.lastName = seller["lastname"] as! String
                            senderSeller.latitude = seller["lat"] as! String
                            senderSeller.longitude = seller["lng"] as! String
                            senderSeller.name = seller["name"] as! String
                            senderSeller.password = seller["password"] as! String
                            senderSeller.phone = seller["phone"] as! String
                            senderSeller.premiumUser = seller["premiumUser"] as! String
                            senderSeller.timestamp = seller["timestamp"] as! String
                            senderSeller.types = seller["type"] as! String
                            senderSeller.userId = (seller["userId"] as! String).toInt()
                            senderSeller.userType = seller["userType"] as! String
                            senderSeller.usrRating = seller["usrRating"] as! String
                            senderSeller.usrReviewCount = (seller["usrReviewCount"] as! String).toInt()
                            senderSeller.usrReviewTotal = (seller["usrReviewTotal"] as! String).toInt()
                            
                            senderSellers.append(senderSeller)
                        }
                        completion(responseData: senderSellers)
                    }
                } else {
                    failure(error: "Something went wrong")
                }

            }) { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
            failure(error: error.description)
        }
        
//        manager.POST(Constant.MyUrl.Favorite_GetList, parameters: param, success: { (operation: AFHTTPRequestOperation!, responseData: AnyObject!) -> Void in
//            
//            print(responseData)
//            
//            let data:Dictionary<String, AnyObject> = (responseData as? Dictionary<String, AnyObject>)!
//            if type == "I" {
//                if let items = data["myFavorite"] as? NSArray {
//                    var senderItems: [ItemObject] = [ItemObject]()
//                    for item in items {
//                        let senderItem = ItemObject()
//                        
//                        senderItems.append(senderItem)
//                    }
//                    completion(responseData: senderItems)
//                } else {
//                    failure(error: "Something went wrong")
//                }
//            } else if type == "U" {
//                var senderSellers: [UserObject] = [UserObject]()
//                completion(responseData: senderSellers)
//            }
//            
//            }) { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
//            failure(error: error.description)
//        }
    }
}