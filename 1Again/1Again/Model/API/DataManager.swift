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
        mainManager.responseSerializer = AFHTTPResponseSerializer()
        mainManager.responseSerializer.acceptableContentTypes = NSSet(object: "text/html") as Set<NSObject>
    }
}
