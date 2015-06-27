//
//  CategoryObject.swift
//  1Again
//
//  Created by Nam Phong on 6/27/15.
//  Copyright (c) 2015 Phong Nguyen Nam. All rights reserved.
//

import UIKit

class CategoryObject {
    var catId: Int!
    var catDescription: String!
    
    init() {
        catId = -1
        catDescription = ""
    }
    
    init(sCatId: Int!, sCatDescription: String!) {
        catId = sCatId
        catDescription = sCatDescription
    }
}
