//
//  Message.swift
//  1Again
//
//  Created by Nam Phong on 7/27/15.
//  Copyright (c) 2015 Phong Nguyen Nam. All rights reserved.
//

import UIKit

class Message {
    var id: String?
    var iid: String?
    var state: String?
    var address1: String?
    var zip: String?
    var entityId: String?
    var descrip: String?
    var image1: String?
    var timestamp: String?
    var type: String?
    var comment: String?
    var ownerstatus: String?
    var lat: String?
    var title: String?
    var city: String?
    var lng: String?
    var distance: String?
    var displayName: String?
    var status: String?
    var im_imd: String?
    var senderId: String?
    var receiverId: String?
    var message: String?
    var jsqMessage: JSQMessage!
    var newIndicator: Int
    
    init() {
        self.id = ""
        self.iid = ""
        self.state = ""
        self.address1 = ""
        self.zip = ""
        self.entityId = ""
        self.descrip = ""
        self.image1 = ""
        self.timestamp = ""
        self.type = ""
        self.comment = ""
        self.ownerstatus = ""
        self.lat = ""
        self.title = ""
        self.city = ""
        self.lng = ""
        self.distance = ""
        self.displayName = ""
        self.status = ""
        self.im_imd = ""
        self.senderId = ""
        self.receiverId = ""
        self.message = ""
        self.jsqMessage = nil
        self.newIndicator = 0
    }
}
