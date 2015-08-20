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
                userObj.displayName = (data["displayName"] as? String) ?? ""
                
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
    
    class func checkDuplicateUser(userName: String, displayName: String, completion: (success: Bool)->Void, failure:(error: String)-> Void) {
        var params:Dictionary<String, String> = Dictionary<String, String>()
        params["user"] = userName
        params[Constant.KEYs.User_DisplayName] = displayName
        
        DataManager.shareManager.PostRequest(Constant.MyUrl.User_CheckDuplicate, params: params, success: { (responseData) -> Void in
            if let responseArr: Array<AnyObject> = responseData as? Array<AnyObject> {
                if let response: Dictionary<String, AnyObject> = responseArr[0] as? Dictionary<String, AnyObject> {
                    if (response["usernameValid"] as! String) == "1" && (response["displaynameValid"] as! String) == "1" {
                        completion(success: true)
                    } else if (response["usernameValid"] as! String) != "1" {
                        failure(error: "User Name is exist")
                    } else if (response["displaynameValid"] as! String) != "1" {
                        failure(error: "Display Name is exist")
                    }
                }
            }
            
        }) { (errorMessage) -> Void in
            failure(error: errorMessage)
        }
    }
    
    class func signup(firstName: String, lastName: String, address1: String, address2: String!, city: String!, state: String!, zip: String!, displayName: String, email: String, password: String, cPassword: String, phone: String!, userType: String, completion:(Void)->Void, failure:(error: String)->Void) {
        var params: Dictionary<String, String> = Dictionary<String, String>()
        params[Constant.KEYs.User_UserName] = email
        params[Constant.KEYs.User_UserPassword] = password
        params[Constant.KEYs.Confirm_Password] = cPassword
        params[Constant.KEYs.Address1] = address1
        params[Constant.KEYs.Address2] = address2
        params[Constant.KEYs.User_FirstName] = firstName
        params[Constant.KEYs.User_LastName] = lastName
        params[Constant.KEYs.User_DisplayName] = displayName
        params[Constant.KEYs.User_City] = city
        params[Constant.KEYs.User_State] = state
        params[Constant.KEYs.User_Zip] = zip
        params[Constant.KEYs.User_Phone] = phone
        params[Constant.KEYs.User_UserType] = userType

        DataManager.shareManager.PostRequest(Constant.MyUrl.Signup_API_URL, params: params, success: { (responseData) -> Void in
            print(responseData)

                if let response: Dictionary<String, AnyObject> = responseData as? Dictionary<String, AnyObject> {
                    let userID = response["id"] as! String
                    USER_DEFAULT.setObject(userID, forKey: "UserID")
                }


            completion()
        }) { (errorMessage) -> Void in
            failure(error: errorMessage ?? "Could not sign up")
        }
    }
    
    // MARK: USER PROFILE
    class func getUserProfile(completion: ()->Void, failure:(error: String)-> Void) {
        var params: Dictionary<String, String> = Dictionary<String, String>()
        params["id"] = User.sharedUser.userID
        
        DataManager.shareManager.PostRequest(Constant.MyUrl.User_Get_Profile_API_URL, params: params, success: { (responseData) -> Void in
            print(responseData)
            if let arr: Array<AnyObject> = responseData as? Array<AnyObject> {
                if arr.count >= 1 {
                    if let _user : Dictionary<String, String> = arr[0] as? Dictionary<String, String> {
                        
                        User.sharedUser.address1 = _user["address1"]! ?? ""
                        User.sharedUser.address2 = _user["address2"]! ?? ""
                        User.sharedUser.city = _user["city"]! ?? ""
                        User.sharedUser.state = _user["state"]! ?? ""
                        User.sharedUser.zipcode = _user["zip"]! ?? ""
                        User.sharedUser.phone = _user["phone"]! ?? ""
                        User.sharedUser.displayName = _user["displayName"]! ?? ""
                        User.sharedUser.email = _user["email"]! ?? ""
                        User.sharedUser.imageURL = _user["profileImage"]! ?? ""
                        
                        User.sharedUser.saveOffline()
                        completion()
                    }
                }
            }
        }) { (errorMessage) -> Void in
            failure(error: errorMessage)
        }
    }
    
    class func updateProfile(displayName: String,completion: ()->Void, failure:(error: String)-> Void ) {
        var params: Dictionary<String, String> = Dictionary<String, String>()
        params[Constant.KEYs.User_DisplayName] = displayName
        params["id"] = USER_DEFAULT.objectForKey("UserID") as? String
        
        DataManager.shareManager.PostRequest(Constant.MyUrl.Update_Profile, params: params, success: { (responseData) -> Void in
             completion()

            }) { (errorMessage) -> Void in
                failure(error: errorMessage)
        }
    }
    
    // MARK: API FOR HOMEPAGE
    class func loadHomePage(completion: (notiCount: Int, messCount: Int)->Void, failure:(error: String)-> Void) {
        var params: Dictionary<String, String> = Dictionary<String, String>()
        params["user"] = User.sharedUser.userID
        
        DataManager.shareManager.PostRequest(Constant.MyUrl.Home_API, params: params, success: { (responseData) -> Void in
            if let arr: Array<AnyObject> = responseData as? Array<AnyObject> {
                if arr.count >= 1 {
                    if let data : Dictionary<String, String> = arr[0] as? Dictionary<String, String> {
                        let notification = Utilities.numberFromJSONAnyObject(data["notifications"])?.integerValue ?? 0
                        let message = Utilities.numberFromJSONAnyObject(data["messages"])?.integerValue ?? 0
                        
                        completion(notiCount: notification, messCount: message)
                    }
                } else {
                    failure(error: "Something went wrong!")
                }
            }
        }) { (errorMessage) -> Void in
            failure(error: errorMessage)
        }
    }
    
    //
    
    class func subcribeInterestedcategory(sale: Bool, consign: Bool, donate: Bool, categories: [String]!, completion: ()->Void, failure:(error: String)-> Void) {
        var params: Dictionary<String, AnyObject> = Dictionary<String, AnyObject>()
        params["id"] = USER_DEFAULT.objectForKey("UserID") as? String
        params["intSale"] = (sale == true) ? "1" : "0"
        params["intConsign"] = (consign == true) ? "1" : "0"
        params["intDonate"] = (donate == true) ? "1" : "0"
        params["category"] = categories
        
        DataManager.shareManager.PostRequest(Constant.MyUrl.Interested_Categories, params: params, success: { (responseData) -> Void in
            completion()
        }) { (errorMessage) -> Void in
            failure(error: errorMessage)
        }
    }
    
    //
    class func updatePhotoProfile(image: UIImage, completion:()->Void, failure:(error: String)->Void) {
        DataManager.shareManager.mainManager.POST(Constant.MyUrl.User_Update_Photo_API_URL, parameters: nil, constructingBodyWithBlock: { (formData: AFMultipartFormData!) -> Void in
        
            let imageData = getDataProfileImage(image)
            formData.appendPartWithFileData(imageData, name: "files[]", fileName: User.sharedUser.userID + "image.jpg", mimeType: "image/jpeg")
            formData.appendPartWithFormData(User.sharedUser.userID.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false), name: "userId")
            }, success: { (operation: AFHTTPRequestOperation!, result: AnyObject!) -> Void in
                if let responseData:Array<AnyObject> = result["data"] as? Array<AnyObject> {
                    if let img:Dictionary<String, String> = responseData[0] as? Dictionary<String, String> {
                        User.sharedUser.imageURL = img["profileImage"]!
                        User.sharedUser.saveOffline()
                        SDImageCache.sharedImageCache().removeImageForKey(Constant.MyUrl.ImageURL + User.sharedUser.imageURL)
                        SDImageCache.sharedImageCache().storeImage(image, forKey: Constant.MyUrl.ImageURL + User.sharedUser.imageURL)
                        completion()
                    }
                }
            }) { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                print(error.description)
            failure(error: "Fail to upload profile photo. Try again later")
        }
    }
    
    class func changePassword(newPass: String, oldPass: String, completion:()->Void, failure:(error: String)->Void) {
        var params: Dictionary<String, AnyObject> = Dictionary<String, AnyObject>()
        params["id"] = User.sharedUser.userID
        params["password"] = newPass
        params["oldPassword"] = oldPass
        
        DataManager.shareManager.PostRequest(Constant.MyUrl.User_Update_Password_API_URL, params: params, success: { (responseData) -> Void in
            completion()
        }) { (errorMessage) -> Void in
            failure(error: errorMessage)
        }
    }
    
    //
    class func updateAddress(address1: String, address2: String!, city: String!, state: String!, zip: String!, phone: String!, completion:()->Void, failure:(error: String)->Void) {
        var params: Dictionary<String, AnyObject> = Dictionary<String, AnyObject>()
        params["id"] = User.sharedUser.userID
        params["address1"] = address1
        params["address2"] = address2
        params["city"] = city
        params["state"] = state
        params["zip"] = zip
        params["phone"] = phone
        
        DataManager.shareManager.PostRequest(Constant.MyUrl.User_Update_Address_API_URL, params: params, success: { (responseData) -> Void in
            completion()
        }) { (errorMessage) -> Void in
            failure(error: errorMessage)
        }
    }
}


