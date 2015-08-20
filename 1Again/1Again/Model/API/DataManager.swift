//
//  DataManager.swift
//  1Again
//
//  Created by Nam Phong on 7/16/15.
//  Copyright (c) 2015 Phong Nguyen Nam. All rights reserved.
//

import UIKit

class DataManager: NSObject {
    static let shareManager = DataManager(baseURL: Constant.MyUrl.homeURL)
    
    var mainManager:AFHTTPRequestOperationManager!
    
    init(baseURL:String) {
        
        super.init()

        mainManager = AFHTTPRequestOperationManager(baseURL: NSURL(string: baseURL))
        mainManager.requestSerializer = AFJSONRequestSerializer()
        mainManager.responseSerializer = AFJSONResponseSerializer(readingOptions: NSJSONReadingOptions.AllowFragments)
        mainManager.requestSerializer.setValue("application/json", forHTTPHeaderField: "Accept")
        mainManager.requestSerializer.setValue("application/json", forHTTPHeaderField: "Content-Type")
        mainManager.responseSerializer.acceptableContentTypes = NSSet(objects: "text/html", "application/json") as Set<NSObject>
    }
    
    func PostRequest(path:String!, params: Dictionary<String, AnyObject>, success:(responseData:AnyObject) -> Void, failure:(errorMessage:String) -> Void) {
        mainManager.POST(path, parameters: params, success: { (response: AFHTTPRequestOperation!, responseObject: AnyObject!) -> Void in
            
            print(responseObject)
            
            if(responseObject == nil || !(responseObject is Dictionary<String, AnyObject>)){
                failure(errorMessage: "Unknown error. Call 911 for help :D")
                return
            }
            
            let responseData: Dictionary = responseObject as! Dictionary<String, AnyObject>
            
            var message = ""
            if(responseData[Constant.KEYs.Message] != nil){
                message = responseData[Constant.KEYs.Message] as! String
            }
            
            if(responseData[Constant.KEYs.Message] != nil &&
                ((responseData[Constant.KEYs.Status] as? Int) == 1 ||
                    (responseData[Constant.KEYs.Status] as? String) == "1")){
                        let contentData: AnyObject? = responseData[Constant.KEYs.Data]
                        if(contentData != nil){
                            success(responseData: contentData!)
                            return
                        }
                        success(responseData: [Constant.KEYs.Message : message])
                        return
            }
            
            message = message.isEmpty ? "Error! Please try again later" : message
            failure(errorMessage: message)
            }) { (response: AFHTTPRequestOperation!, errorRes: NSError!) -> Void in
                print(errorRes.description)
                if(errorRes.code == 3840){
                    failure(errorMessage: "Error 3840! Call 911 for help :D")
                }else{
                    failure(errorMessage: "Can not connect to server! Please try again later")
                }
        }
    }

    func PostRequestWithItem(path: String, item: Item, success:(responseData: AnyObject!) -> Void, failure:(error: String) ->Void) {
        mainManager.POST(path, parameters: nil, constructingBodyWithBlock: { (formData: AFMultipartFormData!) -> Void in
            
            var imageData: NSData = NSData()
            if (item.image1 != nil) {
                imageData = getDataFromImage(item.image1!)
                formData.appendPartWithFileData(imageData, name: "files[]", fileName: "image1.jpg", mimeType: "image/jpeg")
            }
            if (item.image2 != nil) {
                imageData = getDataFromImage(item.image2!)
                formData.appendPartWithFileData(imageData, name: "files[]", fileName: "image2.jpg", mimeType: "image/jpeg")
            }
            if (item.image3 != nil) {
                imageData = getDataFromImage(item.image3!)
                formData.appendPartWithFileData(imageData, name: "files[]", fileName: "image3.jpg", mimeType: "image/jpeg")
            }
            if (item.image4 != nil) {
                imageData = getDataFromImage(item.image4!)
                formData.appendPartWithFileData(imageData, name: "files[]", fileName: "image4.jpg", mimeType: "image/jpeg")
            }
            if (item.image5 != nil) {
                imageData = getDataFromImage(item.image5!)
                formData.appendPartWithFileData(imageData, name: "files[]", fileName: "image5.jpg", mimeType: "image/jpeg")
            }
            
            formData.appendPartWithFormData(User.sharedUser.userID.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false), name: Constant.KEYs.Item_OwnerID)
            formData.appendPartWithFormData(item.category!.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false), name: Constant.KEYs.Item_Category)
            formData.appendPartWithFormData(item.title!.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false), name: Constant.KEYs.Item_Title)
            formData.appendPartWithFormData(item.condition!.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false), name: Constant.KEYs.Item_ConditionA)
            formData.appendPartWithFormData(item.brand!.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false), name: Constant.KEYs.Item_Brand)
            formData.appendPartWithFormData(item.age!.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false), name: Constant.KEYs.Item_Age)
            formData.appendPartWithFormData(item.description!.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false), name: Constant.KEYs.Item_Description)
            formData.appendPartWithFormData(item.donate!.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false), name: Constant.KEYs.Item_Donate)
            formData.appendPartWithFormData(item.consign!.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false), name: Constant.KEYs.Item_Consign)
            formData.appendPartWithFormData(item.sale!.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false), name: Constant.KEYs.Item_Sale)
            formData.appendPartWithFormData(item.price!.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false), name: Constant.KEYs.Item_Price)
            
            }, success: { (request: AFHTTPRequestOperation!, responseObject: AnyObject!) -> Void in
                print(responseObject)
                if(responseObject == nil || !(responseObject is Dictionary<String, AnyObject>)){
                    failure(error: "Unknown error. Call 911 for help :D")
                    return
                }
                
                let responseData: Dictionary = responseObject as! Dictionary<String, AnyObject>
                
                var message = ""
                if(responseData[Constant.KEYs.Message] != nil){
                    message = responseData[Constant.KEYs.Message] as! String
                }
                
                if(responseData[Constant.KEYs.Message] != nil &&
                    ((responseData[Constant.KEYs.Status] as? Int) == 1 ||
                        (responseData[Constant.KEYs.Status] as? String) == "1")){
                            let contentData: AnyObject? = responseData[Constant.KEYs.Data]
                            if(contentData != nil){
                                success(responseData: contentData!)
                                return
                            }
                            success(responseData: [Constant.KEYs.Message : message])
                            return
                }
                
                message = message.isEmpty ? "Error! Please try again later" : message
                failure(error: message)
            }) { (request: AFHTTPRequestOperation!, error: NSError!) -> Void in
                println(error.description)
                if(error.code == 3840){
                    failure(error: "Error 3840! Call 911 for help :D")
                }else{
                    failure(error: "Can not connect to server. Please try again later")
                }
        }
    }
}