//
//  ItemInfoController.swift
//  1Again
//
//  Created by Nam Phong on 6/27/15.
//  Copyright (c) 2015 Phong Nguyen Nam. All rights reserved.
//

import UIKit

protocol ItemInfoControllerDelegate {
    func pushItemBack(item: Item!)
}

class ItemInfoController: BaseSubViewController, UITextViewDelegate {

    var delegate: ItemInfoControllerDelegate!
    
    @IBOutlet weak var titleTextView: UITextView!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    var item: Item!
    
    var prev:UIBarButtonItem!
    var next:UIBarButtonItem!
    var done:UIBarButtonItem!
    
    var titleFisrtResponse: Bool = false
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if item.title == nil || item.title == "" {
            setUpTextView(titleTextView, sText: "Title", sColor: UIColor.lightGrayColor())
        } else {
            titleTextView.textColor = UIColor.blackColor()
            titleTextView.text = item.title
        }
        
        if item.description == nil || item.description == "" {
            setUpTextView(descriptionTextView, sText: "Description", sColor: UIColor.lightGrayColor())
        } else {
            descriptionTextView.textColor = UIColor.blackColor()
            descriptionTextView.text = item.description
        }

        setUpInput()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setUpTextView(sTextView: UITextView!, sText: String!, sColor: UIColor!) {
        sTextView.textColor = sColor
        sTextView.text = sText
    }
    
    func setUpInput() {
        var toolBar = UIToolbar(frame: CGRectMake(0, 0, 320, 40))
        toolBar.barStyle = UIBarStyle.Black
        toolBar.sizeToFit()
        
        var barArrays1 = NSMutableArray()
        
        prev = UIBarButtonItem(title: "PREV", style: UIBarButtonItemStyle.Bordered, target: self, action: "prevAction")
        barArrays1.addObject(prev)
        
        next = UIBarButtonItem(title: "NEXT", style: UIBarButtonItemStyle.Bordered, target: self, action: "nextAction")
        barArrays1.addObject(next)
        
        var flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: self, action: nil)
        barArrays1.addObject(flexSpace)
        
        done = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Done, target: self, action: "doneAction")
        barArrays1.addObject(done)
        
        toolBar.setItems(barArrays1 as [AnyObject], animated: true)
        titleTextView.inputAccessoryView = toolBar
        descriptionTextView.inputAccessoryView = toolBar
        
        if titleFisrtResponse { titleTextView.becomeFirstResponder() }
        else {descriptionTextView.becomeFirstResponder()}
        
    }
    
    func backToAddItem() {
        println("\(__FUNCTION__)")
        self.view.endEditing(true)
        saveItemInformation()
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func doneAction() {
        self.view.endEditing(true)
        
        if titleTextView.text.isEmpty {
            setUpTextView(titleTextView, sText: "Title", sColor: UIColor.lightGrayColor())

        }
        
        if descriptionTextView.text.isEmpty {
            setUpTextView(descriptionTextView, sText: "Description", sColor: UIColor.lightGrayColor())
        }
        saveItemInformation()
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func prevAction() {
        titleTextView.becomeFirstResponder()
        descriptionTextView.resignFirstResponder()
        if descriptionTextView.text.isEmpty {
            setUpTextView(descriptionTextView, sText: "Description", sColor: UIColor.lightGrayColor())
        }
    }
    
    func nextAction() {
        titleTextView.resignFirstResponder()
        descriptionTextView.becomeFirstResponder()
        if titleTextView.text.isEmpty {
            setUpTextView(titleTextView, sText: "Description", sColor: UIColor.lightGrayColor())
        }
    }
    
    func textViewShouldBeginEditing(textView: UITextView) -> Bool {
        if textView.isEqual(titleTextView) {
            prev.enabled = false
            next.enabled = true
        } else if textView.isEqual(descriptionTextView) {
            prev.enabled = true
            next.enabled = false
        }
        return true
    }
    
    func textViewDidBeginEditing(textView: UITextView) {
        if textView.textColor == UIColor.lightGrayColor() {
            textView.text = nil
            textView.textColor = UIColor.blackColor()
        }
    }
    
    func saveItemInformation() {
        if titleTextView.text.isEmpty || titleTextView.text == "Title" {item.title = ""}
        else {item.title = titleTextView.text}
        if descriptionTextView.text.isEmpty || descriptionTextView.text == "Description" {item.description = ""}
        else {item.description = descriptionTextView.text}
        
        delegate.pushItemBack(item)
    }

}
