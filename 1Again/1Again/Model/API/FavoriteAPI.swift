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
        
        manager.POST(Constant.MyUrl.Favorite_GetList, parameters: param, success: { (operation: AFHTTPRequestOperation!, responseData: AnyObject!) -> Void in
            print(responseData)
            }) { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
            failure(error: error.description)
        }
    }
}
