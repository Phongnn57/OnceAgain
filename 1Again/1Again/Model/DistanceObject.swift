//
//  DistanceObject.swift
//  1Again
//
//  Created by Nam Phong on 7/10/15.
//  Copyright (c) 2015 Phong Nguyen Nam. All rights reserved.
//

import UIKit

class DistanceObject {
    var title: String
    var id: String
    var selected: Bool
    
    init() {
        self.title = ""
        self.id = ""
        self.selected = false
    }
    
    init(sTitle: String, sId: String) {
        self.id = sId
        self.title = sTitle
        self.selected = false
    }
}
