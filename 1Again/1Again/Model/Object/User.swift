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
    var id, usrReviewCount, usrReviewTotal, usrRating: String?
    var type: String?
    var name, lastName, displayName: String?
    var email, phone, address1, address2, city, zipcode, state: String?
    var premiumUser, TS, timestamp, favID, latitude, longitude, password: String?
    
    required override init() {
        super.init()
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.userName, forKey: "username")
        aCoder.encodeObject(self.userID, forKey: "userID")
        aCoder.encodeObject(self.userType, forKey: "userType")
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
