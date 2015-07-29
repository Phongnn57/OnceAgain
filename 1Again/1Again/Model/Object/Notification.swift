//
//  Notification.swift
//  1Again
//
//  Created by Nam Phong on 7/18/15.
//  Copyright (c) 2015 Phong Nguyen Nam. All rights reserved.
//

import UIKit

class Notification {
    var iid: String?
    var ownerId: String?
    var displayName: String?
    var category:  String?
    var itemId: String?
    var title: String?
    var desc: String?
    var image1:String?
    var status: String?
    var comment: String?
    var timestamp: String?
    var address1: String?
    var city: String?
    
    init() {
        self.iid = ""
        self.ownerId = ""
        self.displayName = ""
        self.category = ""
        self.itemId = ""
        self.title = ""
        self.desc = ""
        self.image1 = ""
        self.status = ""
        self.comment = ""
        self.timestamp = ""
        self.address1 = ""
        self.city = ""
    }
}
