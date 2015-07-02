//
//  UserManager.swift
//  1Again
//
//  Created by Nam Phong on 6/29/15.
//  Copyright (c) 2015 Phong Nguyen Nam. All rights reserved.
//

class UserManager {
	
    var activeUser: UserObject!
    
    class var sharedInstance: UserManager {
        struct Singleton {
            static let instance = UserManager()
        }
        return Singleton.instance
    }
	
    init() {
        activeUser = UserObject()
    }
    
    func setUser(sUser: UserObject) {
        activeUser = sUser
    }
    
    func getActiveUser() -> UserObject! {
        return activeUser
    }
    
    func getActiveUserId() -> Int {
        return activeUser.userId
    }
    
    func getActiveUserType() -> String {
        return activeUser.userType
    }
    
    func removeActiveUser() {
        activeUser = nil
    }
    
    class func saveActiveUser(userId: Int, userType: String!) {
        NSUserDefaults.standardUserDefaults().setInteger(userId, forKey: Constant.UserDefaultKey.activeUserId)
        NSUserDefaults.standardUserDefaults().setObject(userType, forKey: Constant.UserDefaultKey.activeUsertype)
    }
    
    class func removeActiveUser() {
        NSUserDefaults.standardUserDefaults().removeObjectForKey(Constant.UserDefaultKey.activeUserId)
        NSUserDefaults.standardUserDefaults().removeObjectForKey(Constant.UserDefaultKey.activeUsertype)
    }
    
    class func isAuthorized() -> Bool {
        if NSUserDefaults.standardUserDefaults().objectForKey(Constant.UserDefaultKey.activeUsertype) != nil {
            return true
        }
        return false
    }
    
    class func loginWithUsername(username: String, password: String, hud: MBProgressHUD!) {
        var postURL = Constant.MyUrl.homeURL.stringByAppendingString("V5.jsonlogin2.php")
        var paramsData = ["username":"\(username)", "password":"\(password)"] as Dictionary<String, String>
        var request = NSMutableURLRequest(URL: NSURL(string: postURL)!)
        request.HTTPMethod = "POST"
        var err: NSError?
        
        request.HTTPBody = NSJSONSerialization.dataWithJSONObject(paramsData, options: nil, error: &err)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        var reponseError: NSError?
        var response: NSURLResponse?
        
        var urlData: NSData? = NSURLConnection.sendSynchronousRequest(request, returningResponse:&response, error:&reponseError)
        
        if ( urlData != nil ) {
            let res = response as! NSHTTPURLResponse!;
            
            if (res.statusCode >= 200 && res.statusCode < 300)
            {
                var responseData:NSString  = NSString(data:urlData!, encoding:NSUTF8StringEncoding)!
                var error: NSError?
                let jsonData:NSDictionary = NSJSONSerialization.JSONObjectWithData(urlData!, options:NSJSONReadingOptions.MutableContainers , error: &error) as! NSDictionary
                let success:NSInteger = jsonData.valueForKey("success") as! NSInteger
                if(success == 1)
                {
                    let id:NSInteger = jsonData.valueForKey("id") as! NSInteger
                    let userType:String = jsonData.valueForKey("userType") as! String
                    var activeUser = UserObject(sUserId: id, sUserType: userType)
                    UserManager.sharedInstance.setUser(activeUser)
                    saveActiveUser(activeUser.userId, userType: activeUser.userType)
                    NSNotificationCenter.postNotificationName(Constant.CustomNotification.LoginResult, userInfo: ["result": "success"])
                } else {
                    var error_msg:NSString
                    if jsonData["error_message"] as? NSString != nil {
                        error_msg = jsonData["error_message"] as! NSString
                    } else {
                        error_msg = "Unknown Error"
                    }
                    NSNotificationCenter.postNotificationName(Constant.CustomNotification.LoginResult, userInfo: ["result": "failt", "error" : error_msg])
                }
            } else {
                NSNotificationCenter.postNotificationName(Constant.CustomNotification.LoginResult, userInfo: ["result": "failt", "error": "Connection Failure"])
            }
        } else {
            NSNotificationCenter.postNotificationName(Constant.CustomNotification.LoginResult, userInfo: ["result": "failt", "error": "Connection Failure"])
        }
        hud.hide(true)
    }
    
    class func signUpWithFirstName(firstName: String!, lastName: String!, address1: String!, address2: String!, email: String!, password: String!, cPassword: String!, hud: MBProgressHUD!) {
        let postURL = Constant.MyUrl.homeURL.stringByAppendingString("V6.jsonsignup.php")
        var paramsData = ["username":"\(email)",
            "password":"\(password)",
            "c_password":"\(cPassword)",
            "address1":"\(address1)",
            "address2":"\(address2)",
            "firstname":"\(firstName)",
            "displayname":"Tester",
            "lastname":"\(lastName)"] as Dictionary<String, String>
        var request = NSMutableURLRequest(URL: NSURL(string: postURL)!)
        request.HTTPMethod = "POST"
        var err: NSError?
        
        request.HTTPBody = NSJSONSerialization.dataWithJSONObject(paramsData, options: nil, error: &err)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        var reponseError: NSError?
        var response: NSURLResponse?
        
        var urlData: NSData? = NSURLConnection.sendSynchronousRequest(request, returningResponse:&response, error:&reponseError)
        
        if ( urlData != nil ) {
            let res = response as! NSHTTPURLResponse!;
            if (res.statusCode >= 200 && res.statusCode < 300)
            {
                var responseData:NSString  = NSString(data:urlData!, encoding:NSUTF8StringEncoding)!
                var error: NSError?
                let jsonData:NSDictionary = NSJSONSerialization.JSONObjectWithData(urlData!, options:NSJSONReadingOptions.MutableContainers , error: &error) as! NSDictionary
                let success:NSInteger = jsonData.valueForKey("success") as! NSInteger
                if(success > 0)
                {
                    NSNotificationCenter.postNotificationName(Constant.CustomNotification.SignUpResult, userInfo: ["result" : "success"])
                } else {
                    var error_msg:NSString
                    if jsonData["error_message"] as? NSString != nil {
                        error_msg = jsonData["error_message"] as! NSString
                    } else {
                        error_msg = "Unknown Error"
                    }
                    NSNotificationCenter.postNotificationName(Constant.CustomNotification.SignUpResult, userInfo: ["result" : "failt", "error" : error_msg])
                }
                
            } else {
                NSNotificationCenter.postNotificationName(Constant.CustomNotification.SignUpResult, userInfo: ["result" : "failt", "error" : "Connection Failure"])
            }
        }  else {
            NSNotificationCenter.postNotificationName(Constant.CustomNotification.SignUpResult, userInfo: ["result" : "failt", "error" : "Connection Failure"])
        }
        hud.hide(true)
    }
}
