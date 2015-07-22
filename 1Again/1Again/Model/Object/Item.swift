//
//  Item.swift
//  1Again
//
//  Created by Nam Phong on 7/18/15.
//  Copyright (c) 2015 Phong Nguyen Nam. All rights reserved.
//

import UIKit

class Item {
    
    var itemID, ownerID: String?
    var image1, image2, image3, image4, image5: UIImage?
    var imageStr1, imageStr2, imageStr3, imageStr4, imageStr5: String?
    var title, description: String?
    var donate, consign, sale, price: String?
    var category, condition, age, brand: String?
    var displayName, compensation, status, timestamp, miles: String?
    
    init() {
        self.itemID = ""
        self.ownerID = ""
        self.image1 = nil
        self.image2 = nil
        self.image3 = nil
        self.image4 = nil
        self.image5 = nil
        self.imageStr1 = ""
        self.imageStr2 = ""
        self.imageStr3 = ""
        self.imageStr4 = ""
        self.imageStr5 = ""
        self.title = ""
        self.description = ""
        self.donate = ""
        self.consign = ""
        self.sale = ""
        self.price = ""
        self.category = ""
        self.condition = ""
        self.age = ""
        self.brand = ""
        self.displayName = ""
        self.compensation = ""
        self.status = ""
        self.timestamp = ""
        self.miles = ""
    }
}
