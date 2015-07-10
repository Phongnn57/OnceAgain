//
//  ConditionObject.swift
//  1Again
//
//  Created by Nam Phong on 6/27/15.
//  Copyright (c) 2015 Phong Nguyen Nam. All rights reserved.
//

import UIKit

class ConditionObject {
    var conTitle: String
    var conId: String
    var selected: Bool
    
    init() {
        conId = ""
        conTitle = ""
        self.selected = false
    }
    
    init(sConId: String, sConTitle: String) {
        conId = sConId
        conTitle = sConTitle
        self.selected = false
    }
}
