//
//  UserAPI.swift
//  1Again
//
//  Created by Nam Phong on 7/18/15.
//  Copyright (c) 2015 Phong Nguyen Nam. All rights reserved.
//

import UIKit

class UserAPI: NSObject {
    class func login(userName: String, password: String, completion: (result: AnyObject!)->Void, failure:(error: String)-> Void) {
        
        DataManager.shareManager.mainManager.POST("V5.jsonlogin2.php", parameters: nil, constructingBodyWithBlock: { (formData: AFMultipartFormData!) -> Void in
            formData.appendPartWithFormData(userName.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false), name: "username")
            formData.appendPartWithFormData(password.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false), name: "password")
            
            }, success: { (operation: AFHTTPRequestOperation!, responseData: AnyObject!) -> Void in
            
                print(responseData)
                
            }) { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
            failure(error: error.description)
        }
    }
}
