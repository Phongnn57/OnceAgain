//
//  AddItemViewController.swift
//  1Again
//
//  Created by Nam Phong on 6/27/15.
//  Copyright (c) 2015 Phong Nguyen Nam. All rights reserved.
//

import UIKit

class AddItemViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, ELCImagePickerControllerDelegate, UITextFieldDelegate, ItemInfoControllerDelegate, UIPickerViewDataSource, UIPickerViewDelegate, MBProgressHUDDelegate, CameraControllerDelegate, AddPhotoCellDelegate, UITextViewDelegate, PriceCellDelegate {

    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var menuBtn: UIBarButtonItem!

    private let addPhotoCellIdentifier = "AddPhotoCell"
    private let priceCellIdentifier = "PriceCell"
    private let attributeCellIdentifier = "AttributeCell"
    private let secondPriceCellIdentifier = "SecondPriceCell"
    private let itemInfoCellIdentifier = "ItemDescriptionCell"
    
    var cellIsHide: Bool = true
    var item: Item!
    var activeTextfield: UITextField!
    var pickerView: UIPickerView!
    var toolBar: UIToolbar!
    var selectedTextfield = -1
    var selectedImageIndex: Int = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setMenuButtonAction(menuBtn)
        item = Item()
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
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardDidHideNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardDidShowNotification, object: nil)
    }
    
    // MARK: TABLEVIEW METHODS
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier(addPhotoCellIdentifier) as! AddPhotoCell
            cell.delegate = self
            cell.setImageInCell(item)
            return cell
        } else if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCellWithIdentifier(itemInfoCellIdentifier) as! ItemDescriptionCell
            cell.title.delegate = self
            cell.descriptionTextview.delegate = self
            cell.configCellWithItem(self.item)
            return cell
        }
        else if indexPath.row == 2 {
            let cell = tableView.dequeueReusableCellWithIdentifier(priceCellIdentifier) as! PriceCell
            cell.setImageCell(item)
            cell.delegate = self
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
        if indexPath.row == 0 {return 130 + UIScreen.mainScreen().bounds.size.width * 2 / 3}
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
    
    // MARK: DELEGATE
    
    func changePriceCell(image: PriceImageView) {
        var isHide = cellIsHide
        
        if image.tag == 10 {item.consign = image.getValueOfItem(item)}
        else if image.tag == 11 {item.donate = image.getValueOfItem(item)}
        else if image.tag == 12 {item.sale = image.getValueOfItem(item)}
        
        if item.sale != "0" || item.consign != "0" {cellIsHide = false}
        else {cellIsHide = true}
        
        if isHide == cellIsHide && isHide == false {}
        else { reloadRowOfTableViewAtIndex(3)}
    }
    
    func clickImage(image: AddPhotoImageView, index: Int) {
        self.selectedImageIndex = index
        switch image.tag {
        case 555:
            createActionSheetType2(image)
        case 556:
            createActionSheetType1()
        default: break
        }
    }

    // MARK: ACTIONSHEET
    func createActionSheetType1() {
        let actionSheet = UIActionSheet(title: "Add Photo", delegate: self, cancelButtonTitle: "Cancel", destructiveButtonTitle: nil, otherButtonTitles: "Take Photo", "Photo Library")
        actionSheet.tag = 44
        actionSheet.showInView(self.view)
    }
    
    func createActionSheetType2(imageView: AddPhotoImageView) {
        let actionSheet = UIActionSheet(title: "Select Photo", delegate: self, cancelButtonTitle: "Cancel", destructiveButtonTitle: nil, otherButtonTitles: "Delete Photo", "Make as first photo", "Rotate photo 90 degree")
        actionSheet.tag = 45
        actionSheet.showInView(self.view)
    }
    
    func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int) {
        if actionSheet.tag == 44 {
            if buttonIndex == 1 {
                let cameraController = CameraController()
                cameraController.item = self.item
                cameraController.delegate = self
                self.presentViewController(cameraController, animated: true, completion: nil)
            } else if buttonIndex == 2 {
                var elcPicker = ELCImagePickerController(imagePicker: ())
                elcPicker.maximumImagesCount = 5 - self.item.numberOfImages()
                elcPicker.returnsOriginalImage = true
                elcPicker.returnsImage = true
                elcPicker.onOrder = true
                elcPicker.mediaTypes = [kUTTypeImage]
                elcPicker.imagePickerDelegate = self
                self.presentViewController(elcPicker, animated: true, completion: nil)
            }
        } else if actionSheet.tag == 45 {
            if buttonIndex == 1 {
                self.item.deleteImageAtIndex(self.selectedImageIndex)
                self.item.reOrderImageList()
            } else if buttonIndex == 2 {
                self.item.exchangeImageList(self.selectedImageIndex)
            } else if buttonIndex == 3 {
                var tmpImage = UIImage.imageRotateByDegree(90, image: self.item.getImageAtIndex(self.selectedImageIndex)!)
                self.item.setItemWithImage(tmpImage, index: self.selectedImageIndex)
            }
            self.reloadRowOfTableViewAtIndex(0)
        }
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
                    item.setItemWithImage(image)
                }
            }
        }
        reloadRowOfTableViewAtIndex(0)
    }
    
    // MARK: TEXTFIELD & TEXTVIEW METHODS
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        if textField.tag == Constant.TextFieldTag.addItemTitleTextfield {
            goToItemInformation(true)
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
    
    
    func textViewShouldBeginEditing(textView: UITextView) -> Bool {
        self.goToItemInformation(false)
        return false
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        if textField.tag == Constant.TextFieldTag.addItemBrandTextField {
            item.brand = textField.text
        } else if textField.tag == Constant.TextFieldTag.addItemPriceTextField {
            let tf = textField as! TSCurrencyTextField
            self.item.price = "\(tf.amount.doubleValue)"
            println(self.item.price)
        }
    }

    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        if string == "\n" {
            textField.resignFirstResponder()
            return false
        }
        return true
    }
    
    func moveToDescription() {
        self.goToItemInformation(false)
    }

    func updateImage() {
        self.createActionSheetType1()
    }
    
    func goToItemInformation(titleBecomeFirstResponse: Bool) {
        let itemInformationController = ItemInfoController()
        itemInformationController.titleFisrtResponse = titleBecomeFirstResponse
        itemInformationController.item = self.item
        itemInformationController.delegate = self
        self.presentViewController(itemInformationController, animated: true, completion: nil)
    }
    
    func pushItemBack(item: Item!) {
        reloadRowOfTableViewAtIndex(1)
    }
    
    func getIemFromCameraControl(item: Item!) {
        self.item = item
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
        self.item.ownerID = User.sharedUser.userID
        self.view.endEditing(true)
        if self.item.availableForUpload() {
            MRProgressOverlayView.showOverlayAddedTo(self.view, title: "Uploading...", mode: MRProgressOverlayViewMode.IndeterminateSmall, animated: true)
            ItemAPI.addNewItem(self.item, completion: { () -> Void in
                MRProgressOverlayView.dismissOverlayForView(self.view, animated: true)
                self.view.makeToast("Success!")
            }, failure: { (error) -> Void in
                self.view.makeToast(error)
                MRProgressOverlayView.dismissOverlayForView(self.view, animated: true)
            })
        } else {
            self.view.makeToast("Please fill all information before upload!")
        }
    }
}