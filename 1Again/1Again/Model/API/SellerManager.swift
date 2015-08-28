//
//  SellerManager.swift
//  1Again
//
//  Created by Nam Phong Nguyen on 8/22/15.
//  Copyright (c) 2015 Phong Nguyen Nam. All rights reserved.
//

import UIKit

class SellerManager {
    var sellers:[Seller]!
    
    class var sharedInstance: SellerManager {
        struct Singleton {
            static let instance = SellerManager()
        }
        return Singleton.instance
    }
    
    init() {
        if sellers == nil {
            sellers = []
            
            var params: Dictionary<String, String> = Dictionary<String,String>()
            params["userId"] = User.sharedUser.userID
            
            DataManager.shareManager.PostRequest("V6.getFilterSellers.php", params: params, success: { (responseData) -> Void in
                if let arr:Array<AnyObject> = responseData as? Array<AnyObject> {
                    for obj in arr {
                        var seller = Seller()
                        seller.displayName = obj["displayName"] as? String ?? ""
                        seller.distance = obj["distance"] as? String ?? ""
                        seller.id = obj["id"] as? String ?? ""
                        self.sellers.append(seller)
                    }
                }
            }, failure: { (errorMessage) -> Void in
                
            })
        }
    }
    
    func getAllSellers() -> [Seller]!{
        return self.sellers
    }
}
