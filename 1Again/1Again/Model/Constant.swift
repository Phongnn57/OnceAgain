//
//  Constant.swift
//  1Again
//
//  Created by Nam Phong on 6/27/15.
//  Copyright (c) 2015 Phong Nguyen Nam. All rights reserved.
//

import UIKit

class Constant: NSObject {
    struct MyUrl {
        static let homeURL = "http://www.theconsignmentclub.com/"
    }
    
    struct KeyUserDefaults {
        static let userName = "username"
    }
    
    struct UploadImageSize {
        static let uploadImageSizePortrait = CGSizeMake(120, 160)
        static let uploadImageSizeLandscape = CGSizeMake(160, 120)
    }

    
    struct AddItemPhotoMode {
        static let ImageViewAlreadyHasImage = 0
        static let ImageViewHasCameraImage = 1
        static let ImageViewHasDefaultImage = 2
    }
    
    struct TextFieldTag {
        static let addItemTitleTextfield = 20
        static let addItemDescriptionTextview = 21
    }
}


