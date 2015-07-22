//
//  Category.swift
//  1Again
//
//  Created by Nam Phong on 7/18/15.
//  Copyright (c) 2015 Phong Nguyen Nam. All rights reserved.
//

import UIKit

class Category {
    var catID: String?
    var catDescription: String?
    var selected: Bool
    
    init() {
        self.catID = ""
        self.catDescription = ""
        self.selected = false
    }
}
