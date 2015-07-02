//
//  UserObject.swift
//  1Again
//
//  Created by Nam Phong on 6/27/15.
//  Copyright (c) 2015 Phong Nguyen Nam. All rights reserved.
//

import UIKit

class UserObject {
    var userId: Int!
    var userType: String!
    var displayName: String!
    var email: String!
    
    init() {
        userId = -1
        userType = ""
        displayName = ""
        email = ""
    }
    
    init(sUserId: Int, sUserType: String!, sDisplayname: String!, sEmail: String!) {
        userId = sUserId
        userType = sUserType
        displayName = sDisplayname
        email = sEmail
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
                    userId = (currentUser["id"] as! String).toInt()
                }
            }
        }
    }
}
