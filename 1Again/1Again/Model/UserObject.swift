//
//  UserObject.swift
//  1Again
//
//  Created by Nam Phong on 6/27/15.
//  Copyright (c) 2015 Phong Nguyen Nam. All rights reserved.
//

import UIKit

class UserObject {

    var userId, id, usrReviewCount, usrReviewTotal: Int!
    var userType, types: String!
    var displayName, name, lastName: String!
    var email, phone: String!
    var address1, address2, city, zipCode, state: String!
    var usrRating: String!
    var premiumUser: String!
    var TS, timestamp: String!
    var favID: String!
    var latitude, longitude: String!
    var password: String!

    init() {
        self.initialize()
    }
    
    func initialize() {
        self.id = 0
        self.types = ""
        self.password = ""
        self.latitude = ""
        self.longitude = ""
        self.lastName = ""
        self.favID = ""
        self.userId = -1
        self.userType = ""
        self.displayName = ""
        self.name = ""
        self.email = ""
        self.phone = ""
        self.address1 = ""
        self.address2 = ""
        self.city = ""
        self.zipCode = ""
        self.state = ""
        self.usrRating = ""
        self.usrReviewCount = 0
        self.usrReviewTotal = 0
        self.premiumUser = ""
        self.TS = ""
        self.timestamp = ""
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