//
//  User.swift
//  1Again
//
//  Created by Nam Phong on 7/18/15.
//  Copyright (c) 2015 Phong Nguyen Nam. All rights reserved.
//

import UIKit
import Foundation

class User: NSObject, NSCoding {
    
    static var sharedUser = User()
    
    var userID: String = ""
    var userType: String = ""
    var userName: String = ""
    var id, star, usrReviewCount, usrReviewTotal, usrRating: String?
    var type: String?
    var name, lastName, displayName: String?
    var email, phone, address1, address2, city, zipcode, state: String?
    var premiumUser, TS, timestamp, favID, latitude, longitude, password: String?
    var imageURL: String = ""
    
    required override init() {
        super.init()
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.userName, forKey: "username")
        aCoder.encodeObject(self.userID, forKey: "userID")
        aCoder.encodeObject(self.userType, forKey: "userType")
        aCoder.encodeObject(self.displayName, forKey: "displayName")
        aCoder.encodeObject(self.address1, forKey: "address1")
        aCoder.encodeObject(self.address2, forKey: "address2")
        aCoder.encodeObject(self.city, forKey: "city")
        aCoder.encodeObject(self.state, forKey: "state")
        aCoder.encodeObject(self.zipcode, forKey: "zip")
        aCoder.encodeObject(self.phone, forKey: "phone")
        aCoder.encodeObject(self.email, forKey: "email")
        aCoder.encodeObject(self.imageURL, forKey: "imageURL")
        aCoder.encodeObject(self.usrReviewCount, forKey: "usrReviewCount")
        aCoder.encodeObject(self.star, forKey: "star")
    }
    
    required init(coder aDecoder: NSCoder) {

        if let userName = aDecoder.decodeObjectForKey("userName") as? String {
            self.userName = userName
        }
        if let userID = aDecoder.decodeObjectForKey("userID") as? String {
            self.userID = userID
        }
        if let userType = aDecoder.decodeObjectForKey("userType") as? String {
            self.userType = userType
        }
        if let displayName = aDecoder.decodeObjectForKey("displayName") as? String {
            self.displayName = displayName
        }
        if let address1 = aDecoder.decodeObjectForKey("address1") as? String {
            self.address1 = address1
        }
        if let address2 = aDecoder.decodeObjectForKey("address2") as? String {
            self.address2 = address2
        }
        if let city = aDecoder.decodeObjectForKey("city") as? String {
            self.city = city
        }
        if let state = aDecoder.decodeObjectForKey("state") as? String {
            self.state = state
        }
        if let zip = aDecoder.decodeObjectForKey("zip") as? String {
            self.zipcode = zip
        }
        if let phone = aDecoder.decodeObjectForKey("phone") as? String {
            self.phone = phone
        }
        if let email = aDecoder.decodeObjectForKey("email") as? String {
            self.email = email
        }
        if let imageURL = aDecoder.decodeObjectForKey("imageURL") as? String {
            self.imageURL = imageURL
        }
        if let reviewCount = aDecoder.decodeObjectForKey("usrReviewCount") as? String {
            self.usrReviewCount = reviewCount
        }
        if let star = aDecoder.decodeObjectForKey("star") as? String {
            self.star = star
        }
    }
    
    func saveOffline() {
        NSKeyedArchiver.archiveRootObject(self, toFile: User.fileLocation())
    }
    
    class func readOffline() {
        if let data: AnyObject = NSKeyedUnarchiver.unarchiveObjectWithFile(User.fileLocation()){
            User.sharedUser = (data as? User) ?? User()
        }
    }
    
    private class func fileLocation() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        let documentDirectory = paths[0] as! String
        return documentDirectory.stringByAppendingPathComponent(Constant.UserDefaultKey.User)
    }
}
