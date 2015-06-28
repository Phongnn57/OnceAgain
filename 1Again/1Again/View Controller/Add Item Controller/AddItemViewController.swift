//
//  AddItemViewController.swift
//  1Again
//
//  Created by Nam Phong on 6/27/15.
//  Copyright (c) 2015 Phong Nguyen Nam. All rights reserved.
//

import UIKit

class AddItemViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, ELCImagePickerControllerDelegate, UITextFieldDelegate, ItemInfoControllerDelegate, UIPickerViewDataSource, UIPickerViewDelegate {

    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var menuBtn: UIBarButtonItem!

    private let addPhotoCellIdentifier = "AddPhotoCell"
    private let priceCellIdentifier = "PriceCell"
    private let attributeCellIdentifier = "AttributeCell"
    private let secondPriceCellIdentifier = "SecondPriceCell"
    private let itemInfoCellIdentifier = "ItemDescriptionCell"
    var cellIsHide: Bool = true
    
    var item: ItemObject!
    
    var pickerView: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setMenuButtonAction(menuBtn)

        tableview.registerNib(UINib(nibName: addPhotoCellIdentifier, bundle: nil), forCellReuseIdentifier: addPhotoCellIdentifier)
        tableview.registerNib(UINib(nibName: priceCellIdentifier, bundle: nil), forCellReuseIdentifier: priceCellIdentifier)
        tableview.registerNib(UINib(nibName: attributeCellIdentifier, bundle: nil), forCellReuseIdentifier: attributeCellIdentifier)
        tableview.registerNib(UINib(nibName: secondPriceCellIdentifier, bundle: nil), forCellReuseIdentifier: secondPriceCellIdentifier)
        tableview.registerNib(UINib(nibName: itemInfoCellIdentifier, bundle: nil), forCellReuseIdentifier: itemInfoCellIdentifier)
        tableview.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "keyboardWillHide:"))
        item = ItemObject()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func viewWillAppear(animated: Bool) {
        println(__FUNCTION__)
        super.viewWillAppear(animated)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardDidShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardDidHideNotification, object: nil)
    }
    
    override func viewDidDisappear(animated: Bool) {
        println(__FUNCTION__)
        super.viewDidDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardDidHideNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardDidShowNotification, object: nil)
    }
    
    //Mark: TABLEVIEW METHODS -----------------------------------------------------
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier(addPhotoCellIdentifier) as! AddPhotoCell
            
            cell.setImageInCell(item)
            cell.btnUpdateImage.addTarget(self, action: "createActionSheetType1", forControlEvents: UIControlEvents.TouchUpInside)
            cell.image1.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "choosePhoto:"))
            cell.image2.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "choosePhoto:"))
            cell.image3.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "choosePhoto:"))
            cell.image4.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "choosePhoto:"))
            cell.image5.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "choosePhoto:"))
            return cell
        } else if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCellWithIdentifier(itemInfoCellIdentifier) as! ItemDescriptionCell
            cell.title.delegate = self
            cell.descriptionItem.delegate = self
            cell.title.text = item.title
            cell.descriptionItem.text = item.description
            return cell
        }
        else if indexPath.row == 2 {
            let cell = tableView.dequeueReusableCellWithIdentifier(priceCellIdentifier) as! PriceCell
            cell.setImageCell(item)
            cell.donate.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "priceCellClicked:"))
            cell.consign.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "priceCellClicked:"))
            cell.sale.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "priceCellClicked:"))
            return cell
        } else if indexPath.row == 3 {
            if item.sale != nil || item.consign != nil {
                let cell = tableView.dequeueReusableCellWithIdentifier(secondPriceCellIdentifier) as! SecondPriceCell
                cell.price.inputAccessoryView = configPriceInputView()
                cell.price.delegate = self
                return cell
            }
        }
        else if indexPath.row == 4 {
            let cell = tableView.dequeueReusableCellWithIdentifier(attributeCellIdentifier) as! AttributeCell
            cell.category.delegate = self
            cell.age.delegate = self
            cell.brand.delegate = self
            cell.condition.delegate = self
            return cell
        }
        return UITableViewCell()
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row == 0 {return 130 + UIScreen.mainScreen().bounds.size.width/2}
        else if indexPath.row == 1 {return 200}
        else if indexPath.row == 2 {return 60 + UIScreen.mainScreen().bounds.size.width/3}
        else if indexPath.row == 3 {
            if item.sale != nil || item.consign != nil {return 44}
            else {return 0}
        }
        else if indexPath.row == 4 {return 220}
        return 44
    }
    
    func reloadRowOfTableViewAtIndex(index: Int) {
        self.tableview.beginUpdates()
        self.tableview.reloadRowsAtIndexPaths(NSMutableArray(object: NSIndexPath(forRow: index, inSection: 0)) as [AnyObject], withRowAnimation: UITableViewRowAnimation.None)
        self.tableview.endUpdates()
    }
    
    //Mark: DONATE , CONSIGN, FOR SALE BUTTON ACTION -----------------------------------
    func priceCellClicked(sender: AnyObject) {
        let image = (sender as! UITapGestureRecognizer).view as! PriceImageView
        
        var isHide = cellIsHide
        
        if image.tag == 10 {
            if item.consign == nil {
                item.consign = "1"
                image.imageName("image:add-item-consign-selected.png")
            }
            else {
                item.consign = nil
                image.imageName("image:add-item-consign.png")
            }
        } else if image.tag == 11 {
            if item.donate == nil {
                item.donate = "1"
                image.imageName("image:add-item-donate-selected.png")
            }
            else {
                item.donate = nil
                image.imageName("image:add-item-donate.png")
            }
        } else if image.tag == 12 {
            if item.sale == nil {
                item.sale = "1"
                image.imageName("image:add-item-for-sale-selected.png")
            }
            else {
                item.sale = nil
                image.imageName("image:add-item-for-sale.png")
            }
        }
        
        if item.sale != nil || item.consign != nil {cellIsHide = false}
        else {cellIsHide = true}
        
        if isHide == cellIsHide && isHide == false {
            
        } else {
            reloadRowOfTableViewAtIndex(3)
        }
        
        
    }
    

    
    //Mark: ADD PHOTO IMAGE VIEW ACTION
    func choosePhoto(sender: AnyObject) {
        let imageView = (sender as! UITapGestureRecognizer).view as! AddPhotoImageView
        println("SELECT IMAGE WITH TAG = \(imageView.tag)")
        
        switch imageView.imageMode {
            case Constant.AddItemPhotoMode.ImageViewAlreadyHasImage:
                createActionSheetType2(imageView)
            case Constant.AddItemPhotoMode.ImageViewHasCameraImage:
                createActionSheetType1()
            default: break
        }
    }
    
    
    //Mark: CUSTOM ACTION SHEET
    func createActionSheetType1() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        
        var actionSheet = UIAlertController(title: "Add Photo", message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Take Photo", style: UIAlertActionStyle.Default, handler: { (alert:UIAlertAction!) -> Void in
            
            //To be added
            
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Photo Library", style: UIAlertActionStyle.Default, handler: { (alert:UIAlertAction!) -> Void in
            var elcPicker = ELCImagePickerController(imagePicker: ())
            elcPicker.maximumImagesCount = self.item.getNumberOfEmptyImage()
            elcPicker.returnsOriginalImage = true
            elcPicker.returnsImage = true
            elcPicker.onOrder = true
            elcPicker.mediaTypes = [kUTTypeImage]
            elcPicker.imagePickerDelegate = self
            self.presentViewController(elcPicker, animated: true, completion: nil)
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
        
        self.presentViewController(actionSheet, animated: true, completion: nil)
    }
    
    func createActionSheetType2(imageView: AddPhotoImageView) {
        
        var actionSheet = UIAlertController(title: "Select Photo", message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        actionSheet.addAction(UIAlertAction(title: "Delete Photo", style: UIAlertActionStyle.Default, handler: { (alert:UIAlertAction!) -> Void in
            
            self.item.removeImageAtByTag(imageView.tag)
            
            self.item.reOrderImageList()
            self.reloadRowOfTableViewAtIndex(0)
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Make As First Image", style: UIAlertActionStyle.Default, handler: { (alert:UIAlertAction!) -> Void in
           self.item.exChangeImageByTag(imageView.tag)
            self.reloadRowOfTableViewAtIndex(0)
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Rotate Image", style: UIAlertActionStyle.Default, handler: { (alert:UIAlertAction!) -> Void in
            
            var tmpImage = self.item.scaleDownImageWith(imageView.image!, newSize: CGSizeMake(imageView.frame.size.width, imageView.frame.size.height))
            imageView.image = self.item.imageRotateByDegree(90, image: tmpImage)
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
        
        self.presentViewController(actionSheet, animated: true, completion: nil)
    }
    
    
    func elcImagePickerControllerDidCancel(picker: ELCImagePickerController!) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func elcImagePickerController(picker: ELCImagePickerController!, didFinishPickingMediaWithInfo info: [AnyObject]!) {
        self.dismissViewControllerAnimated(true, completion: nil)
        
        for dict in info {
            var dictionary = dict as! NSDictionary
            if dictionary.objectForKey(UIImagePickerControllerMediaType) as? NSString == ALAssetTypePhoto {
                if (dictionary.objectForKey(UIImagePickerControllerOriginalImage) != nil) {
                    var image: UIImage = dictionary.objectForKey(UIImagePickerControllerOriginalImage) as! UIImage
                    item.passToEmptyImageInOrderWithImage(image)
                }
            }
        }
        reloadRowOfTableViewAtIndex(0)
    }
    
    //Mark: TEXTFIELD & TEXTVIEW METHODS
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        if textField.tag == Constant.TextFieldTag.addItemTitleTextfield {
            goToItemInformation(true)
            return false
        } else if textField.tag == Constant.TextFieldTag.addItemDescriptionTextview {
            goToItemInformation(false)
            return false
        }
        return true
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        if string == "\n" {
            textField.resignFirstResponder()
            return false
        }
        
        if textField.tag == Constant.TextFieldTag.addItemPriceTextField {
            if item.price == nil {item.price = ""}
            println("THE STRING: \(string)")
            switch string {
            case "0","1","2","3","4","5","6","7","8","9":
                item.price  = item.price.stringByAppendingString(string)
                println("CURRENT STRING: \(item.price)")
                textField.text =  "$\(formatCurrency(item.price))"
            default:
                var array = Array(string)
                var currentStringarray = Array(item.price)
                if array.count == 0 && currentStringarray.count != 0 {
                    currentStringarray.removeLast()
                    item.price = ""
                    for character in currentStringarray {
                        item.price = item.price.stringByAppendingString(String(character))
                    }
                    textField.text =  "$\(formatCurrency(item.price))"
                }
            }
            return false
        }
        
        return true
    }
    
    func formatCurrency(string: String) -> Double {
        
        let formatter = NSNumberFormatter()
        formatter.numberStyle = NSNumberFormatterStyle.CurrencyStyle
        formatter.locale = NSLocale(localeIdentifier: "en_US")
        var numberFromField = (NSString(string: string).doubleValue)/100
        return numberFromField
    }
    
    func goToItemInformation(titleBecomeFirstResponse: Bool) {
        let itemInformationController = ItemInfoController()
        itemInformationController.titleFisrtResponse = titleBecomeFirstResponse
        itemInformationController.item = self.item
        itemInformationController.delegate = self
        self.presentViewController(itemInformationController, animated: true, completion: nil)
    }
    
    func pushItemBack(item: ItemObject!) {
        println(item.description)
        reloadRowOfTableViewAtIndex(1)
    }
    
    func configPriceInputView() -> UIToolbar{
        var numberToolbar = UIToolbar(frame: CGRectMake(0, 0, self.view.frame.size.width, 50))
        numberToolbar.barStyle = UIBarStyle.BlackTranslucent
//        var cancelBtn = UIBarButtonItem(title: "Cancel", style: .Bordered, target: self, action: nil)
        var doneBtn = UIBarButtonItem(title: "Done", style: .Bordered, target: self, action: "updatePrice:")
        numberToolbar.items = NSArray(objects: UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil),doneBtn) as [AnyObject]
        
        return numberToolbar
    }
    
    func updatePrice(sender: AnyObject) {
        self.view.endEditing(true)
    }
    
    func cancelUpdatePrice(sender: AnyObject) {
        self.view.endEditing(true)
    }
    
    //KEYBOARD HANDLE
    func keyboardWillShow(notification: NSNotification) {
        println(__FUNCTION__)
        let userInfo = notification.userInfo!
        var keyboardSize = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
        
        var contentInsets = UIEdgeInsetsMake(0, 0, keyboardSize.size.height, 0)
        self.tableview.contentInset = contentInsets
        self.tableview.scrollIndicatorInsets = contentInsets
    }
    
    func keyboardWillHide(notification: NSNotification) {
        println(__FUNCTION__)
        self.view.endEditing(true)
        let contentInsets = UIEdgeInsetsZero
        self.tableview.contentInset = contentInsets
        self.tableview.scrollIndicatorInsets = contentInsets
    }
    
    //Mark: PICKER VIEW METHODS
    func initializePickerView() {
        pickerView = UIPickerView(frame: CGRectMake(0, 50, 320, 480))
        pickerView.dataSource = self
        pickerView.delegate = self
        pickerView.showsSelectionIndicator = false
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 10
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        return ""
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
    }
}