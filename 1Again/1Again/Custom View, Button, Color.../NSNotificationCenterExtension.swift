//
//  NSNotificationCenterExtension.swift
//  1Again
//
//  Created by Nam Phong on 6/27/15.
//  Copyright (c) 2015 Phong Nguyen Nam. All rights reserved.
//

import UIKit

extension NSNotificationCenter {
    class func postNotificationName(name: String) {
        let nc = defaultCenter()
        nc.postNotificationName(name, object: nil)
    }
    
    class func postNotificationName(name: String, userInfo: [NSObject : AnyObject]?) {
        let nc = defaultCenter()
        nc.postNotificationName(name, object: nil, userInfo: userInfo)
    }
}