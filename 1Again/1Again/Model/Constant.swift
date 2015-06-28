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
        static let addItemCategoryTextField = 22
        static let addItemBrandTextField = 23
        static let addItemConditionTextField = 24
        static let addItemAgeTextField = 25
        static let addItemPriceTextField = 26
    }
    
    struct ConditionData {
        static let conditions = ["New with tags", "New", "Like New", "Very Good", "Good", "Satisfactory"]
    }
    
    struct AgeData {
        static let ages = ["0 - 6 months", "7 - 12 months", "13 - 18 months", "19 - 24 months", "2+ years", "Not Specified"]
    }
    
    struct FormatCurrency {
        func formatCurrency(string: String) -> Double {
            let formatter = NSNumberFormatter()
            formatter.numberStyle = NSNumberFormatterStyle.CurrencyStyle
            formatter.locale = NSLocale(localeIdentifier: "en_US")
            var numberFromField = (NSString(string: string).doubleValue)/100
            return numberFromField
        }
    }
    
    struct CustomNotification {
        static let AddItemWithResult = "addItemResult"
    }
}