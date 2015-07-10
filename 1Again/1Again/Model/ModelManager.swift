//
//  ModelManager.swift
//  1Again
//
//  Created by Nam Phong on 7/10/15.
//  Copyright (c) 2015 Phong Nguyen Nam. All rights reserved.
//

import UIKit

class ModelManager: NSObject {
    static let shareManager = ModelManager(baseURL: Constant.MyUrl.homeURL)
    
    var mainManager:AFHTTPRequestOperationManager!
    
    init(baseURL:String) {
        
        super.init()
        
        mainManager = AFHTTPRequestOperationManager(baseURL: NSURL(string: baseURL))
        mainManager.responseSerializer = AFJSONResponseSerializer()
        mainManager.requestSerializer = AFJSONRequestSerializer()
        mainManager.responseSerializer.acceptableContentTypes = NSSet(object: "text/html") as Set<NSObject>
    }
    
    func postRequest(urlStr: String, params: Dictionary<String, String>!, success: (responseData: AnyObject!) -> Void, failure: (error: String!)-> Void) {
//        print(mainManager.)
//        mainManager.POST(urlStr, parameters: params, success: { (operation: AFHTTPRequestOperation!, responseData: AnyObject!) -> Void in
//            success(responseData: responseData)
//            }) { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
//                if(error.code == 3840){
//                    failure(error: "Lỗi 3840. Vui lòng gọi tổng đài để được hỗ trợ.")
//                }else{
//                    failure(error: "Không thể kết nối đến máy chủ, vui lòng kiểm tra lại đường truyền mạng!")
//                    print(error)
//                }
//        }
        
        mainManager.GET(urlStr, parameters: params, success: { (operation: AFHTTPRequestOperation!, responseData: AnyObject!) -> Void in
            success(responseData: responseData)
        }) { (operation: AFHTTPRequestOperation!, error: NSError! ) -> Void in
            if(error.code == 3840){
                failure(error: "Lỗi 3840. Vui lòng gọi tổng đài để được hỗ trợ.")
            }else{
                failure(error: "Không thể kết nối đến máy chủ, vui lòng kiểm tra lại đường truyền mạng!")
                print(error)
            }
        }
    }
}
