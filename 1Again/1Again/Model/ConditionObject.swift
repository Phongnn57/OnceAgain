//
//  ConditionObject.swift
//  1Again
//
//  Created by Nam Phong on 6/27/15.
//  Copyright (c) 2015 Phong Nguyen Nam. All rights reserved.
//

import UIKit

class ConditionObject {
    var conTitle: String!
    var conId: Int!
    
    init() {
        conId = -1
        conTitle = ""
    }
    
    init(sConId: Int, sConTitle: String) {
        conId = sConId
        conTitle = sConTitle
    }
}
