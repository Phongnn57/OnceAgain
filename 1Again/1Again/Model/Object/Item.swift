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
        self.donate = "0"
        self.consign = "0"
        self.sale = "0"
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
    
    func numberOfImages() -> Int{
        if self.image1 == nil {
            return 0
        } else if self.image2 == nil {
            return 1
        } else if self.image3 == nil {
            return 2
        } else if self.image4 == nil {
            return 3
        } else if self.image5 == nil {
            return 4
        } else {
            return 5
        }
    }
    
    func getImageAtIndex(index: Int) -> UIImage? {
        if index == 0 {
            return self.image1
        } else if index == 1 {
            return self.image2
        } else if index == 2 {
            return self.image3
        } else if index == 3 {
            return self.image4
        } else {
            return self.image5
        }
    }
    
    func setItemWithImage(image: UIImage, index: Int) {
        if index == 0 {
            self.image1 = image
        } else if index == 1 {
            self.image2 = image
        } else if index == 2 {
            self.image3 = image
        } else if index == 3 {
            self.image4 = image
        } else if index == 4 {
            self.image5 = image
        }
    }
    
    func setItemWithImage(image: UIImage) {
        if self.image1 == nil {
            self.image1 = image
        } else if self.image2 == nil {
            self.image2 = image
        } else if self.image3 == nil {
            self.image3 = image
        } else if self.image4 == nil {
            self.image4 = image
        } else if self.image5 == nil {
            self.image5 = image
        }
    }
    
    func deleteImageAtIndex(index: Int) {
        if index == 0 {
            self.image1 = nil
        } else if index == 1 {
            self.image2 = nil
        } else if index == 2 {
            self.image3 = nil
        } else if index == 3 {
            self.image4 = nil
        } else if index == 4 {
            self.image5 = nil
        }
    }
    
    func reOrderImageList() {
        var images:[UIImage?] = []
        if self.image1 != nil {images.append(self.image1)}
        if self.image2 != nil {images.append(self.image2)}
        if self.image3 != nil {images.append(self.image3)}
        if self.image4 != nil {images.append(self.image4)}
        if self.image5 != nil {images.append(self.image5)}
        
        for var i = 0; i < 5; i++ {
            self.deleteImageAtIndex(i)
        }
        
        for var i = 0; i < images.count; i++ {
            if i == 0 {image1 = images[0] }
            else if i == 1 {image2 = images[1] }
            else if i == 2 {image3 = images[2] }
            else if i == 3 {image4 = images[3] }
            else if i == 4 {image5 = images[4] }
        }
    }
    
    func exchangeImageList(index: Int) {
        var tmpImage = self.image1
        if index == 0 {
        } else if index == 1 {
            self.image1 = self.image2
            self.image2 = tmpImage
        } else if index == 2 {
            self.image1 = self.image3
            self.image3 = tmpImage
        } else if index == 3 {
            self.image1 = self.image4
            self.image4 = tmpImage
        } else if index == 4 {
            self.image1 = self.image5
            self.image5 = tmpImage
        }
    }
    
    func availableForUpload() -> Bool {
        if self.image1 != nil && self.category != "" && self.title != "" && self.description != "" && self.condition != "" && self.age != "" && (consign != "0" || donate != "0" || sale != "0") {
            return true
        }
        return false
    }
}
