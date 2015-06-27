//
//  AgeObject.swift
//  1Again
//
//  Created by Nam Phong on 6/27/15.
//  Copyright (c) 2015 Phong Nguyen Nam. All rights reserved.
//

import UIKit

class AgeObject {
    var ageId: Int!
    var ageTitle: String!
    
    init() {
        ageId = -1
        ageTitle = ""
    }
    
    init(sAgeId: Int!, sAgeTitle: String!) {
        ageId = sAgeId
        ageTitle = sAgeTitle
    }
}
