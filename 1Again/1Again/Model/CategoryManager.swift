//
//  CategoryManager.swift
//  1Again
//
//  Created by Nam Phong on 6/27/15.
//  Copyright (c) 2015 Phong Nguyen Nam. All rights reserved.
//

class CategoryManager {
    
    var categories:[CategoryObject]!
	
    class var sharedInstance: CategoryManager {
        struct Singleton {
            static let instance = CategoryManager()
        }
        return Singleton.instance
    }
	
    init() {
        if categories == nil {
            categories = []
            let postURL = Constant.MyUrl.homeURL.stringByAppendingString("categoryJSON.php")
            let catUrl = NSURL(string: postURL)
            
            
            let data = NSData(contentsOfURL: catUrl!)
            if let json = NSJSONSerialization.JSONObjectWithData(data!, options: nil, error: nil) as? NSDictionary {
                if let feed = json["category"] as? NSArray {
                    for obj in feed {
                        var catDescription = obj["description"] as! String
                        var catId = obj["id"] as! String
                        categories.append(CategoryObject(sCatId: catId.toInt(), sCatDescription: catDescription))
                    }
                }
            }
        }
    }
    
    func getCategoryList() -> [CategoryObject]! {
        return categories
    }
    
    func getCatIdFromCatDescription(scatDescription: String!) -> Int {
        if categories != nil {
            for cat in categories {
                if cat.catDescription == scatDescription {return cat.catId}
            }
        }
        return -1
    }
    
    func getCatDescriptionFromCatId(catId: Int) -> String! {
        if categories != nil {
            for cat in categories {
                if cat.catId == catId {return cat.catDescription}
            }
        }
        
        return nil
    }
    

}
