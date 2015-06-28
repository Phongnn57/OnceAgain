//
//  AddItemViewController.swift
//  1Again
//
//  Created by Nam Phong on 6/27/15.
//  Copyright (c) 2015 Phong Nguyen Nam. All rights reserved.
//

import UIKit

class AddItemViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, ELCImagePickerControllerDelegate, UITextFieldDelegate, ItemInfoControllerDelegate, UIPickerViewDataSource, UIPickerViewDelegate, MBProgressHUDDelegate, CameraControllerDelegate {

    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var menuBtn: UIBarButtonItem!

    private let addPhotoCellIdentifier = "AddPhotoCell"
    private let priceCellIdentifier = "PriceCell"
    private let attributeCellIdentifier = "AttributeCell"
    private let secondPriceCellIdentifier = "SecondPriceCell"
    private let itemInfoCellIdentifier = "ItemDescriptionCell"
    
    var cellIsHide: Bool = true
    var item: ItemObject!
    var activeTextfield: UITextField!
    var pickerView: UIPickerView!
    var toolBar: UIToolbar!
    var selectedTextfield = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setMenuButtonAction(menuBtn)
        item = ItemObject()
        initializePickerView()
        initializeToolbar()
        tableview.registerNib(UINib(nibName: addPhotoCellIdentifier, bundle: nil), forCellReuseIdentifier: addPhotoCellIdentifier)
        tableview.registerNib(UINib(nibName: priceCellIdentifier, bundle: nil), forCellReuseIdentifier: priceCellIdentifier)
        tableview.registerNib(UINib(nibName: attributeCellIdentifier, bundle: nil), forCellReuseIdentifier: attributeCellIdentifier)
        tableview.registerNib(UINib(nibName: secondPriceCellIdentifier, bundle: nil), forCellReuseIdentifier: secondPriceCellIdentifier)
        tableview.registerNib(UINib(nibName: itemInfoCellIdentifier, bundle: nil), forCellReuseIdentifier: itemInfoCellIdentifier)
        tableview.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "keyboardWillHide:"))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.view.endEditing(true)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardDidShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardDidHideNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "handleUploadResult:", name: Constant.CustomNotification.AddItemWithResult, object: nil)
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardDidHideNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardDidShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: Constant.CustomNotification.AddItemWithResult, object: nil)
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
            if item.sale != "0" || item.consign != "0" {
                let cell = tableView.dequeueReusableCellWithIdentifier(secondPriceCellIdentifier) as! SecondPriceCell
                
                cell.price.inputAccessoryView = toolBar
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
            cell.category.inputAccessoryView = toolBar
            cell.category.inputView = pickerView
            cell.condition.inputAccessoryView = toolBar
            cell.condition.inputView = pickerView
            cell.age.inputAccessoryView = toolBar
            cell.age.inputView = pickerView
            return cell
        }
        return UITableViewCell()
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row == 0 {return 130 + UIScreen.mainScreen().bounds.size.width/2}
        else if indexPath.row == 1 {return 200}
        else if indexPath.row == 2 {return 60 + UIScreen.mainScreen().bounds.size.width/3}
        else if indexPath.row == 3 {
            if item.sale != "0" || item.consign != "0" {return 60}
            else {return 0}
        }
        else if indexPath.row == 4 {return 275}
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
        
        if image.tag == 10 {item.consign = image.getValueOfItem(item)}
        else if image.tag == 11 {item.donate = image.getValueOfItem(item)}
        else if image.tag == 12 {item.sale = image.getValueOfItem(item)}
        
        if item.sale != "0" || item.consign != "0" {cellIsHide = false}
        else {cellIsHide = true}
        
        if isHide == cellIsHide && isHide == false {}
        else { reloadRowOfTableViewAtIndex(3)}
    }

    //Mark: ADD PHOTO IMAGE VIEW ACTION
    func choosePhoto(sender: AnyObject) {
        let imageView = (sender as! UITapGestureRecognizer).view as! AddPhotoImageView
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
            let cameraController = CameraController()
            cameraController.item = self.item
            cameraController.delegate = self
            self.presentViewController(cameraController, animated: true, completion: nil)
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
        } else if textField.tag >= Constant.TextFieldTag.addItemCategoryTextField && textField.tag <= Constant.TextFieldTag.addItemAgeTextField {
            selectedTextfield = textField.tag
            activeTextfield = textField
            pickerView.reloadAllComponents()
            pickerView.selectRow(0, inComponent: 0, animated: true)
            return true
        } else if textField.tag == Constant.TextFieldTag.addItemPriceTextField {
            activeTextfield = textField
            return true
        }
        return true
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        if textField.tag == Constant.TextFieldTag.addItemBrandTextField {
            item.brand = textField.text
        }
    }

    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        if string == "\n" {
            textField.resignFirstResponder()
            return false
        }
        
        if textField.tag == Constant.TextFieldTag.addItemPriceTextField {
            if item.price == nil {item.price = ""}
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
        reloadRowOfTableViewAtIndex(1)
    }
    
    func getIemFromCameraControl(item: ItemObject!) {
        reloadRowOfTableViewAtIndex(0)
    }
    
    func initializeToolbar() {
        toolBar = UIToolbar(frame: CGRectMake(0, 0, self.view.frame.size.width, 50))
        toolBar.barStyle = UIBarStyle.BlackTranslucent
        var doneBtn = UIBarButtonItem(title: "Done", style: .Bordered, target: self, action: "updatePrice:")
        toolBar.items = NSArray(objects: UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil),doneBtn) as [AnyObject]
    }
    
    func updatePrice(sender: AnyObject) {
        activeTextfield.resignFirstResponder()
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
        let contentInsets = UIEdgeInsetsZero
        if activeTextfield != nil {activeTextfield.resignFirstResponder()}
        UIView.animateWithDuration(0.2, animations: { () -> Void in
            self.tableview.contentInset = contentInsets
            self.tableview.scrollIndicatorInsets = contentInsets
        })
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
        switch selectedTextfield {
            case Constant.TextFieldTag.addItemCategoryTextField:
                return CategoryManager.sharedInstance.getCategoryList().count
            case Constant.TextFieldTag.addItemAgeTextField:
                return Constant.AgeData.ages.count
            case Constant.TextFieldTag.addItemConditionTextField:
                return Constant.ConditionData.conditions.count
            default: return 0
        }
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        switch selectedTextfield {
        case Constant.TextFieldTag.addItemCategoryTextField:
            return CategoryManager.sharedInstance.getCategoryList()[row].catDescription
        case Constant.TextFieldTag.addItemAgeTextField:
            return Constant.AgeData.ages[row]
        case Constant.TextFieldTag.addItemConditionTextField:
            return Constant.ConditionData.conditions[row]
        default: return ""
        }
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        activeTextfield.text = self.pickerView(pickerView, titleForRow: row, forComponent: component)
        switch selectedTextfield {
        case Constant.TextFieldTag.addItemCategoryTextField:
            item.category = "\(CategoryManager.sharedInstance.getCatIdFromCatDescription(activeTextfield.text))"
        case Constant.TextFieldTag.addItemAgeTextField:
            item.age = "\(row + 1)"
        case Constant.TextFieldTag.addItemConditionTextField:
            item.condition = "\(row + 1)"
        default: break
        }
    }
    
    @IBAction func postDataToServer(sender: AnyObject) {
        item.userId = 95
        
        if item.availableToUpload() {
            let hud = MBProgressHUD(view: self.view)
            hud.delegate = self
            hud.labelText = "Uploading"
            self.view.addSubview(hud)
            self.view.bringSubviewToFront(hud)
            hud.show(true)
            item.pushItemWithActivityIndicator(hud)
        } else {
            let alert = UIAlertView(title: "Alert", message: "Please fill all information before upload!", delegate: self, cancelButtonTitle: "OK")
            alert.show()
        }
    }
    
    func handleUploadResult(notification: NSNotification) {
        let userInfo:Dictionary<String,String!> = notification.userInfo as! Dictionary<String,String!>
        let messageString = userInfo["result"]
        if messageString == "success" {
            let alert = UIAlertView(title: "Success", message: "Your item has been submitted to our partners for consideration", delegate: self, cancelButtonTitle: "OK")
            alert.show()
        } else {
            let alert = UIAlertView(title: "Upload Fail", message: "Fail to upload! Try again later!", delegate: self, cancelButtonTitle: "Try again")
            alert.show()
        }
    }
}