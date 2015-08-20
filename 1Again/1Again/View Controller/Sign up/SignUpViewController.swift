//
//  SignUpViewController.swift
//  1Again
//
//  Created by Nam Phong on 6/29/15.
//  Copyright (c) 2015 Phong Nguyen Nam. All rights reserved.
//

import UIKit

protocol SignUpViewControllerDelegate {
    func didFinishSignupWithEmail(email: String)
}

class SignUpViewController: BaseSubViewController, UITextFieldDelegate, MBProgressHUDDelegate, UIScrollViewDelegate, SHMultipleSelectDelegate {

    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var city: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var confirmPassword: UITextField!
    @IBOutlet weak var btnSignup: UIButton!
    @IBOutlet weak var displayName: MyCustomTextField!
    @IBOutlet weak var address1: MyCustomTextField!
    @IBOutlet weak var address2: MyCustomTextField!
    @IBOutlet weak var state: MyCustomTextField!
    @IBOutlet weak var zip: MyCustomTextField!
    @IBOutlet weak var phone: MyCustomTextField!
    @IBOutlet weak var confirmDisplayName: MyCustomTextField!
    @IBOutlet weak var btnSubmit: UIButton!
    @IBOutlet weak var btnNothank: UIButton!
    @IBOutlet weak var btnConsign: UIButton!
    @IBOutlet weak var btnDonate: UIButton!
    @IBOutlet weak var btnForSale: UIButton!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet var firstContentView: UIView!
    @IBOutlet var secondContentView: UIView!
    @IBOutlet var thirdContentView: UIView!
    @IBOutlet var fourthContentView: UIView!
    @IBOutlet var fifthContentView: UIView!
    
    var delegate: SignUpViewControllerDelegate?
    
    var currentPage: Int = 0
    var userType: String!
    
    var consign:Bool = false
    var donate:Bool = false
    var forSale:Bool = false
    var categories:[String] = []
    
    
    var keyboardIsShown: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "endEditingView:"))
        
        self.configScrollView()
        self.btnConsign.setBackgroundImage(UIImage(color: UIColor.whiteColor(), size: CGSizeMake(1, 1)), forState: UIControlState.Highlighted)
        self.btnDonate.setBackgroundImage(UIImage(color: UIColor.whiteColor(), size: CGSizeMake(1, 1)), forState: UIControlState.Highlighted)
        self.btnForSale.setBackgroundImage(UIImage(color: UIColor.whiteColor(), size: CGSizeMake(1, 1)), forState: UIControlState.Highlighted)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "handleSignUpResult:", name: Constant.CustomNotification.SignUpResult, object: nil)
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: Constant.CustomNotification.SignUpResult, object: nil)
    }
    
    //
    
    func configScrollView() {
        self.scrollView.frame = CGRectMake(0, 73, SCREEN_SIZE.width, 288)
        
        let scrollViewWidth:CGFloat = self.scrollView.frame.width
        let scrollViewHeight:CGFloat = self.scrollView.frame.height
        
        self.firstContentView.frame = CGRectMake(0, 0, scrollViewWidth, scrollViewHeight)
        self.secondContentView.frame = CGRectMake(scrollViewWidth, 0, scrollViewWidth, scrollViewHeight)
        self.thirdContentView.frame = CGRectMake(scrollViewWidth*2, 0, scrollViewWidth, scrollViewHeight)
        self.fourthContentView.frame = CGRectMake(scrollViewWidth*3, 0, scrollViewWidth, scrollViewHeight)
        self.fifthContentView.frame = CGRectMake(scrollViewWidth*4, 0, scrollViewWidth, scrollViewHeight)
        
        self.scrollView.addSubview(self.firstContentView)
        self.scrollView.addSubview(self.secondContentView)
        self.scrollView.addSubview(self.thirdContentView)
        self.scrollView.addSubview(self.fourthContentView)
        self.scrollView.addSubview(self.fifthContentView)
        
        self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.width * 5, self.scrollView.frame.height)
    }
    
    func moveToNextPage (){
        
        self.view.endEditing(true)
        
        // Move to next page
        var pageWidth:CGFloat = CGRectGetWidth(self.scrollView.frame)
        let maxWidth:CGFloat = pageWidth * 5
        var contentOffset:CGFloat = self.scrollView.contentOffset.x

        if  contentOffset + pageWidth == maxWidth{

        } else {
            var slideToX = contentOffset + pageWidth
            self.scrollView.scrollRectToVisible(CGRectMake(slideToX, 0, pageWidth, CGRectGetHeight(self.scrollView.frame)), animated: true)
            self.checkCurrentPage()
            self.currentPage++
        }
    }
    
    func checkCurrentPage() -> Int {
        var pageWidth:CGFloat = CGRectGetWidth(self.scrollView.frame)
        var currentPage:CGFloat = floor((self.scrollView.contentOffset.x-pageWidth/2)/pageWidth) + 2
        if Int(currentPage) == 0{
            self.btnSignup.setTitle("NEXT", forState: .Normal)
        }else if Int(currentPage) == 1{
            self.btnSignup.hidden = true
        }else if Int(currentPage) == 2{
            self.btnSignup.hidden = false
            self.btnSignup.setTitle("NEXT", forState: .Normal)
        }else if Int(currentPage) == 3{
            self.btnSignup.hidden = false
            self.confirmDisplayName.text = self.displayName.text
            self.btnSignup.setTitle("CONTINUE", forState: .Normal)
        }else if Int(currentPage) == 4{
            self.btnSignup.hidden = true
            self.btnNothank.hidden = false
            self.btnSubmit.hidden = false
        }
        return Int(currentPage)
    }
    
    
    @IBAction func didSelectConsign(sender: AnyObject) {
        self.consign = !self.consign
        if self.consign {
            self.btnConsign.setImage(UIImage(named: "image:add-item-consign-selected"), forState: .Normal)
        } else {
            self.btnConsign.setImage(UIImage(named: "image:add-item-consign"), forState: .Normal)
        }
    }

    @IBAction func didSelectDonate(sender: AnyObject) {
        self.donate = !self.donate
        if self.donate {
            self.btnDonate.setImage(UIImage(named: "image:add-item-donate-selected"), forState: .Normal)
        } else {
            self.btnDonate.setImage(UIImage(named: "image:add-item-donate"), forState: .Normal)
        }
    }
    
    @IBAction func didSelectForSale(sender: AnyObject) {
        self.forSale = !self.forSale
        if self.forSale {
            self.btnForSale.setImage(UIImage(named: "image:add-item-for-sale-selected"), forState: .Normal)
        } else {
            self.btnForSale.setImage(UIImage(named: "image:add-item-for-sale"), forState: .Normal)
        }
    }
    
    @IBAction func chooseCategories(sender: AnyObject) {
        
        let selectCategory = SHMultipleSelect()
        selectCategory.delegate = self
        selectCategory.rowsCount = CategoryManager.sharedInstance.categories.count
        selectCategory.show()
    }
    

    @IBAction func didSelectHaveItem(sender: AnyObject) {
        self.userType = "P"
        self.moveToNextPage()
    }

    @IBAction func didSelectHaveStore(sender: AnyObject) {
        self.userType = "B"
        self.moveToNextPage()
    }
    
    @IBAction func didSelectSubmit(sender: AnyObject) {
        UserAPI.subcribeInterestedcategory(self.forSale, consign: self.consign, donate: self.donate, categories: self.categories, completion: { () -> Void in
            self.dismissViewControllerAnimated(true, completion: { () -> Void in
                self.delegate?.didFinishSignupWithEmail(self.email.text)
            })
        }) { (error) -> Void in
            self.view.makeToast(error, duration: 2, position: CSToastPositionTop)
            MRProgressOverlayView.dismissOverlayForView(self.view, animated: true)
        }
    }
    
    @IBAction func didSelectNoThank(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: { () -> Void in
            self.delegate?.didFinishSignupWithEmail(self.email.text)
        })
    }
    
    func endEditingView(sender: AnyObject) {
        self.view.endEditing(true)
    }
    
    @IBAction func signUpTapped(sender: AnyObject) {
        if self.currentPage == 0 {
            if self.firstViewISFilled() {
                MRProgressOverlayView.showOverlayAddedTo(self.view, title: "", mode: MRProgressOverlayViewMode.IndeterminateSmall, animated: true)
                UserAPI.checkDuplicateUser(self.email.text, displayName: self.displayName.text, completion: { (success) -> Void in
                    MRProgressOverlayView.dismissOverlayForView(self.view, animated: true)
                    if success {
                        self.moveToNextPage()
                    }
                    }, failure: { (error) -> Void in
                        self.view.makeToast(error, duration: 2, position: CSToastPositionTop)
                        MRProgressOverlayView.dismissOverlayForView(self.view, animated: true)
                })
            }
        } else if self.currentPage == 2 {
            
            if self.thirdViewIsFilled() {
                MRProgressOverlayView.showOverlayAddedTo(self.view, title: "", mode: MRProgressOverlayViewMode.IndeterminateSmall, animated: true)
                UserAPI.signup(self.firstName.text, lastName: self.lastName.text, address1: self.address1.text, address2: self.address2.text, city: self.city.text, state: self.state.text, zip: self.zip.text, displayName: self.displayName.text, email: self.email.text, password: self.password.text, cPassword: self.confirmPassword.text, phone: self.phone.text, userType: self.userType, completion: { () -> Void in
                    
                    MRProgressOverlayView.dismissOverlayForView(self.view, animated: true)
                    
                    if self.userType == "P" {
                        self.dismissViewControllerAnimated(true, completion: { () -> Void in
                            self.delegate?.didFinishSignupWithEmail(self.email.text)
                        })
                    } else if self.userType == "B" {
                        self.moveToNextPage()
                    }
                }, failure: { (error) -> Void in
                    MRProgressOverlayView.dismissOverlayForView(self.view, animated: true)
                    self.view.makeToast(error, duration: 2, position: CSToastPositionTop)
                })
            }
        } else if self.currentPage == 3 {
            if self.displayName.text != self.confirmDisplayName.text {
                UserAPI.updateProfile(self.confirmDisplayName.text, completion: { () -> Void in
                    self.moveToNextPage()
                }, failure: { (error) -> Void in
                    MRProgressOverlayView.dismissOverlayForView(self.view, animated: true)
                    self.view.makeToast(error, duration: 2, position: CSToastPositionTop)
                })
            } else {
                self.moveToNextPage()
            }
        }
    }
    
    @IBAction func backToLogin(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func handleSignUpResult(notification: NSNotification!) {
        let userInfo:Dictionary<String,String!> = notification.userInfo as! Dictionary<String,String!>
        let result = userInfo["result"]
        if result == "success" {
            self.dismissViewControllerAnimated(true, completion: nil)
        } else {
            let alert = UIAlertView(title: "Error", message: userInfo["error"], delegate: self, cancelButtonTitle: "OK")
            alert.show()
        }
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        if string == "\n" {
            textField.resignFirstResponder()
            return false
        }
        return true
    }
    
    func firstViewISFilled() ->Bool {
        if self.firstName.text.isEmpty || self.lastName.text.isEmpty || self.email.text.isEmpty || self.password.text.isEmpty || self.confirmPassword.text.isEmpty || self.displayName.text.isEmpty {
            self.view.makeToast("Please fill all fields", duration: 3, position: CSToastPositionTop)
            return false
        } else if self.password.text != self.confirmPassword.text {
            self.view.makeToast("Password does not match", duration: 3, position: CSToastPositionTop)
            return false
        }
        return true
    }
    
    func thirdViewIsFilled() ->Bool {
        
        var check: Bool = false
        
        if !self.address2.text.isEmpty || (!self.city.text.isEmpty && !self.zip.text.isEmpty && !self.state.text.isEmpty) {
            check = true
        } else {
            check = false
        }
        
        if self.address1.text.isEmpty || !check {
            self.view.makeToast("Please fill all fields (if you enter address 2, city state and zip are not required)", duration: 3, position: CSToastPositionTop)
            return false
        }
        return true
    }
    
    // MARK: SHOW MULTIPLE CATEGORY
    func multipleSelectView(multipleSelectView: SHMultipleSelect!, clickedBtnAtIndex clickedBtnIndex: Int, withSelectedIndexPaths selectedIndexPaths: [AnyObject]!) {
        if clickedBtnIndex == 1 {
            var selected: [String] = []
            
            if selectedIndexPaths != nil {
                for _indexpath in selectedIndexPaths {
                    
                    let indexpath: NSIndexPath = _indexpath as! NSIndexPath
                    let idStr = CategoryManager.sharedInstance.categories[indexpath.row].catId
                    selected.append("\(idStr)")
                }
                self.categories = selected
            }
            
            
        }
    }
    
    func multipleSelectView(multipleSelectView: SHMultipleSelect!, setSelectedForRowAtIndexPath indexPath: NSIndexPath!) -> Bool {
        var canSelect = false
        if indexPath.row == CategoryManager.sharedInstance.categories.count - 1 {
            canSelect = true
        }
        return false
    }
    
    func multipleSelectView(multipleSelectView: SHMultipleSelect!, titleForRowAtIndexPath indexPath: NSIndexPath!) -> String! {
        return CategoryManager.sharedInstance.categories[indexPath.row].catDescription
    }

}
