//
//  UserAPI.swift
//  1Again
//
//  Created by Nam Phong on 7/18/15.
//  Copyright (c) 2015 Phong Nguyen Nam. All rights reserved.
//

import UIKit

class UserAPI: NSObject {
    
    // MARK: LOGIN
    class func login(userName: String, password: String, completion: (Void)->Void, failure:(error: String)-> Void) {
        var params: Dictionary<String, String> = Dictionary<String, String>()
        params[Constant.KEYs.User_UserName] = userName
        params[Constant.KEYs.User_UserPassword] = password
        
        DataManager.shareManager.PostRequest(Constant.MyUrl.Login_API_URL, params: params, success: { (responseData) -> Void in
            if let data = responseData as? Dictionary<String, AnyObject> {
                let userObj = User()
                userObj.userID = (data["id"] as? String) ?? ""
                userObj.userType = (data["userType"] as? String) ?? ""
                userObj.userName = userName
                
                userObj.saveOffline()
                User.sharedUser = userObj
                completion()
            } else {
                failure(error: "Could not login to server")
            }
        }) { (errorMessage) -> Void in
            failure(error: errorMessage ?? "Could not login to server")
        }
    }
    
    // MARK: SIGN UP
    class func signup(firstName: String, lastName: String, address1: String, address2: String, email: String, password: String, cPassword: String, completion:(Void)->Void, failure:(error: String)->Void) {
        var params: Dictionary<String, String> = Dictionary<String, String>()
        params[Constant.KEYs.User_UserName] = email
        params[Constant.KEYs.User_UserPassword] = password
        params[Constant.KEYs.Confirm_Password] = cPassword
        params[Constant.KEYs.Address1] = address1
        params[Constant.KEYs.Address2] = address2
        params[Constant.KEYs.User_FirstName] = firstName
        params[Constant.KEYs.User_LastName] = lastName
        params[Constant.KEYs.User_DisplayName] = "Tester"

        DataManager.shareManager.PostRequest(Constant.MyUrl.Signup_API_URL, params: params, success: { (responseData) -> Void in
            print(responseData)
        }) { (errorMessage) -> Void in
            failure(error: errorMessage ?? "Could not sign up")
        }
    }
    
    // MARK: USER PROFILE
    class func getUserProfile(completion: (user: User!)->Void, failure:(error: String)-> Void) {
        var params: Dictionary<String, String> = Dictionary<String, String>()
        params["id"] = User.sharedUser.userID
        
        DataManager.shareManager.PostRequest(Constant.MyUrl.User_Get_Profile_API_URL, params: params, success: { (responseData) -> Void in
            
            if let arr: Array<AnyObject> = responseData as? Array<AnyObject> {
                if arr.count >= 1 {
                    if let _user : Dictionary<String, String> = arr[0] as? Dictionary<String, String> {
                        let user = User()
                        user.userID = _user["id"]! ?? ""
                        user.displayName = _user["displayName"]! ?? ""
                        user.email = _user["email"]! ?? ""
                        completion(user: user)
                    }
                }
            }
        }) { (errorMessage) -> Void in
            failure(error: errorMessage)
        }
    }
    
}


