//
//  ProfileObject.swift
//  1Again
//
//  Created by Nam Phong on 6/30/15.
//  Copyright (c) 2015 Phong Nguyen Nam. All rights reserved.
//

import UIKit

class ProfileObject {
    var uId: Int!
    var displayName: String!
    var email: String!
    
    init() {
        uId = -1
        displayName = String()
        email = String()
    }
    
    init(urlStr: String) {
        var url = NSURL(string: urlStr)
        var data: NSData = NSData(contentsOfURL: url!)!
        
        if let jsonData = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as? NSDictionary {
            if let users = jsonData["user"] as? NSArray {
                println(users)
                for currentUser in users {
                    displayName = currentUser["displayName"] as! String
                    email = currentUser["email"] as! String
                    uId = (currentUser["id"] as! String).toInt()
                }
            }
        }
    }
}
