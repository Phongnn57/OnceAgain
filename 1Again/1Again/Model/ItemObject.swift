//
//  NewItemObject.swift
//  1Again
//
//  Created by Nam Phong on 6/27/15.
//  Copyright (c) 2015 Phong Nguyen Nam. All rights reserved.
//

import UIKit

class ItemObject {
    var image1: UIImage!
    var image2: UIImage!
    var image3: UIImage!
    var image4: UIImage!
    var image5: UIImage!
    var title: String!
    var description: String!
    var donate: String = "0"
    var consign: String = "0"
    var price: String!
    var sale: String = "0"
    var ownerId: Int!
    var category: String!
    var condition: String!
    var age: String!
    var brand: String!
    var compensation: String!
    var status: String!
    var timestamp: String!
    var id: String!
    var miles: String!
    var imageStr1: String!
    var imageStr2: String!
    var imageStr3: String!
    var imageStr4: String!
    var imageStr5: String!
    
    init() {
        consign = "0"
        donate = "0"
        sale = "0"
    }
    
    func getNumberOfEmptyImage() -> Int {
        if image1 == nil {return 5}
        if image2 == nil {return 4}
        if image3 == nil {return 3}
        if image4 == nil {return 2}
        if image5 == nil {return 1}
        return 0
    }
    
    func passToEmptyImageInOrderWithImage(image: UIImage!) {
        if image1 == nil {image1 = image}
        else if image2 == nil {image2 = image}
        else if image3 == nil {image3 = image}
        else if image4 == nil {image4 = image}
        else if image5 == nil {image5 = image}
    }
    
    func reOrderImageList() {
        var images:[UIImage] = []
        if image1 != nil {images.append(image1)}
        if image2 != nil {images.append(image2)}
        if image3 != nil {images.append(image3)}
        if image4 != nil {images.append(image4)}
        if image5 != nil {images.append(image5)}
        
        removeAllImage()
        
        for var i = 0; i < images.count; i++ {
            if i == 0 {image1 = images[0] }
            else if i == 1 {image2 = images[1] }
            else if i == 2 {image3 = images[2] }
            else if i == 3 {image4 = images[3] }
            else if i == 4 {image5 = images[4] }
        }
    }
    
    func removeImageAtByTag(tag: Int) {
        if tag == 13 {image1 = nil}
        else if tag == 14 {image2 = nil}
        else if tag == 15 {image3 = nil}
        else if tag == 16 {image4 = nil}
        else if tag == 17 {image5 = nil}
    }
    
    func removeAllImage() {
        image1 = nil
        image2 = nil
        image3 = nil
        image4 = nil
        image5 = nil
    }
    
    func exChangeImageByTag(tag: Int) {
        var tmpImage: UIImage! = self.image1
        if tag == 14 {
            self.image1 = self.image2
            self.image2 = tmpImage
        }
        else if tag == 15 {
            self.image1 = self.image3
            self.image3 = tmpImage
        }
        else if tag == 16 {
            self.image1 = self.image4
            self.image4 = tmpImage
        }
        else if tag == 17 {
            self.image1 = self.image5
            self.image5 = tmpImage
        }
    }
    
    func availableToUpload() -> Bool {
        if image1 != nil && title != "" && description != "" && category != "" && condition != "" && brand != "" && age != "" && (consign != "0" || donate != "0" || sale != "0") {
            return true
        }
        return false
    }
    
    func pushItemWithActivityIndicator(hud: MBProgressHUD!) ->Bool {
        var uploadStatus: Bool = false
        let manager = AFHTTPRequestOperationManager()
        manager.responseSerializer = AFHTTPResponseSerializer()
        
        var postURL = Constant.MyUrl.homeURL.stringByAppendingString("item_insert_ac.V2.php")
        
        manager.POST(postURL, parameters: nil, constructingBodyWithBlock: { (data: AFMultipartFormData!) -> Void in
            
            var imageData: NSData = NSData()
            if (self.image1 != nil) {
                imageData = getDataFromImage(self.image1)
                data.appendPartWithFileData(imageData, name: "files[]", fileName: "image1.jpg", mimeType: "image/jpeg")
            }
            if (self.image2 != nil) {
                imageData = getDataFromImage(self.image2)
                data.appendPartWithFileData(imageData, name: "files[]", fileName: "image2.jpg", mimeType: "image/jpeg")
            }
            if (self.image3 != nil) {
                imageData = getDataFromImage(self.image1)
                data.appendPartWithFileData(imageData, name: "files[]", fileName: "image3.jpg", mimeType: "image/jpeg")
            }
            if (self.image4 != nil) {
                imageData = getDataFromImage(self.image1)
                data.appendPartWithFileData(imageData, name: "files[]", fileName: "image4.jpg", mimeType: "image/jpeg")
            }
            if (self.image5 != nil) {
                imageData = getDataFromImage(self.image1)
                data.appendPartWithFileData(imageData, name: "files[]", fileName: "image5.jpg", mimeType: "image/jpeg")
            }
            
            data.appendPartWithFormData("\(self.ownerId)".dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false), name: "ownerId")
            data.appendPartWithFormData(self.category.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false), name: "category")
            data.appendPartWithFormData(self.title.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false), name: "title")
            data.appendPartWithFormData(self.condition.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false), name: "conditionA")
            data.appendPartWithFormData(self.brand.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false), name: "brand")
            data.appendPartWithFormData(self.age.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false), name: "age")
            data.appendPartWithFormData(self.description.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false), name: "description")
            data.appendPartWithFormData(self.donate.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false), name: "donate")
            data.appendPartWithFormData(self.consign.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false), name: "consign")
            data.appendPartWithFormData(self.sale.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false), name: "sale")
            data.appendPartWithFormData("\(formatCurrency(self.price))".dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false), name: "price")
            
            }, success: { (request: AFHTTPRequestOperation!, obj: AnyObject!) -> Void in
                hud.hide(true)
                NSNotificationCenter.defaultCenter().postNotificationName(Constant.CustomNotification.AddItemWithResult, object: nil, userInfo: ["result" : "success"])
            }) { (request: AFHTTPRequestOperation!, error: NSError!) -> Void in
                hud.hide(true)
                NSNotificationCenter.defaultCenter().postNotificationName(Constant.CustomNotification.AddItemWithResult, object: nil, userInfo: ["result" : "fail"])
        }
        
        return uploadStatus
    }
    
    //Class function for shop local
    
    class func getShopLocalDataFromStringURL(str: String!, completionClosure: (resultItems :[ItemObject], totalRecord: String!, nextLink: String!) ->()) {
        var url = NSURL(string: str)
        var data: NSData = NSData(contentsOfURL: url!)!
        var tmpItems: [ItemObject]! = []
        var tmpTotalRecord: String!
        var tmpNextLink: String!
        
        if let jsonData = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as? NSDictionary {
            if let response = jsonData["paging"] as? NSArray {
                if response.count > 0 {
                    tmpTotalRecord = response[0]["totalRecords"] as! String!
                    tmpNextLink = response[0]["next"] as! String
                }
            }
            
            if let items = jsonData["items"] as? NSArray {
                for item in items {
                    var thisItem = ItemObject()
                    thisItem.miles = item["miles"] as! String
                    thisItem.id = item["id"] as! String
                    thisItem.ownerId = (item["ownerId"] as! String).toInt()
                    thisItem.category = item["category"] as! String
                    thisItem.title = item["title"] as! String!
                    thisItem.description = item["description"] as! String!
                    thisItem.imageStr1 = item["image1"] as! String!
                    thisItem.timestamp = item["timestamp"] as! String!
                    thisItem.price = item["price"] as! String!
                    tmpItems.append(thisItem)
                }
            }
        }
        
        completionClosure(resultItems: tmpItems, totalRecord: tmpTotalRecord, nextLink: tmpNextLink)
    }
    
    
    
    class func getShopLocalFilteredItems(urlStr: String!, postStr: String!, compleationHandle: (filteredItems: [ItemObject], totalRecord: String!, nextLink: String!) -> ()) {
        let postURl = NSURL(string: urlStr)
        let postData: NSData = postStr.dataUsingEncoding(NSASCIIStringEncoding, allowLossyConversion: true)!
        let postlength = String(postData.length)
        
        var request: NSMutableURLRequest = NSMutableURLRequest(URL: postURl!)
        request.HTTPMethod = "POST"
        request.HTTPBody = postData
        request.setValue(postlength, forHTTPHeaderField: "Content_Length")
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        var reponseError: NSError?
        var response: NSURLResponse?
        var tmpItems: [ItemObject]! = []
        var tmpTotalRecord: String!
        var tmpNextLink: String!
        var urlData: NSData? = NSURLConnection.sendSynchronousRequest(request, returningResponse:&response, error:&reponseError)
        if urlData != nil {
            var error: NSError?
            if let jsonData:NSDictionary = NSJSONSerialization.JSONObjectWithData(urlData!, options:NSJSONReadingOptions.MutableContainers , error: &error) as? NSDictionary {
                if let response = jsonData["paging"] as? NSArray {
                    if response.count > 0 {
                        tmpTotalRecord = response[0]["totalRecords"] as! String!
                        tmpNextLink = response[0]["next"] as! String
                    }
                }
                
                if let items = jsonData["items"] as? NSArray {
                    for item in items {
                        var thisItem = ItemObject()
                        thisItem.miles = item["miles"] as! String
                        thisItem.id = item["id"] as! String
                        thisItem.ownerId = (item["ownerId"] as! String).toInt()
                        thisItem.category = item["category"] as! String
                        thisItem.title = item["title"] as! String!
                        thisItem.description = item["description"] as! String!
                        thisItem.imageStr1 = item["image1"] as! String!
                        thisItem.timestamp = item["timestamp"] as! String!
                        thisItem.price = item["price"] as! String!
                        tmpItems.append(thisItem)
                    }
                }
            }
        }
        
        compleationHandle(filteredItems: tmpItems, totalRecord: tmpTotalRecord, nextLink: tmpNextLink)
    }
}

func getItemListWithURLstr(str: String, completionClosure: (items :[ItemObject]) ->()) {
    let url = NSURL(string: str)
    let data = NSData(contentsOfURL: url!)
    var itemList: [ItemObject] = []
    
    if let jsonData = NSJSONSerialization.JSONObjectWithData(data!, options: nil, error: nil) as? NSDictionary {
        println("json: \(jsonData)")
        if let items = jsonData["items"] as? NSArray {
            for item in items {
                var thisItem = ItemObject()
                thisItem.title = item["title"] as! String
                thisItem.id = item["id"] as! String
                thisItem.ownerId = (item["ownerId"] as! String).toInt()
                thisItem.category = item["category"] as! String
                thisItem.brand = item["brand"] as! String!
                thisItem.condition = item["conditionA"] as! String!
                thisItem.compensation = item["compensation"] as! String!
                thisItem.description = item["description"] as! String!
                thisItem.imageStr1 = item["image1"] as! String!
                thisItem.imageStr2 = item["image2"] as! String!
                thisItem.imageStr3 = item["image3"] as! String!
                thisItem.imageStr4 = item["image4"] as! String!
                thisItem.imageStr5 = item["image5"] as! String!
                thisItem.status = item["status"] as! String!
                thisItem.timestamp = item["timestamp"] as! String!
                itemList.append(thisItem)
            }
        }
    }
    
    completionClosure(items: itemList)
}

func archiveItem(item:String){
    var postURL = Constant.MyUrl.homeURL.stringByAppendingString("item_update.php?status=I&id=\(item)")
    
    var url=NSURL(string:postURL)
    
    var data=NSData(contentsOfURL:url!)
    
    var datastring: String = NSString(data:data!, encoding:NSUTF8StringEncoding)! as String
    
    //  println(datastring)
    
    if let json = NSJSONSerialization.JSONObjectWithData(data!, options: nil, error: nil) as? NSDictionary {
        //print
        if let feed = json["return_code"] as? NSArray {
            
            if let feed = json["return_code"] as? NSString {
                //     println(feed )
            }
        }
    }
}


