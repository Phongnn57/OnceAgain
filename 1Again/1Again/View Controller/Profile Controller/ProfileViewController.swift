//
//  ProfileViewController.swift
//  1Again
//
//  Created by Nam Phong on 6/30/15.
//  Copyright (c) 2015 Phong Nguyen Nam. All rights reserved.
//

import UIKit

class ProfileViewController: BaseViewController, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var menuBtn: UIBarButtonItem!
    
    @IBOutlet weak var changePhoto: UIButton!
    @IBOutlet weak var changePassword: UIButton!
    @IBOutlet weak var changeAddress: UIButton!
    @IBOutlet weak var username: UIButton!
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var email: UIButton!
    
    var user = User()
    
    var firstLoad: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setMenuButtonAction(menuBtn)
        
        self.changePhoto.imageEdgeInsets = UIEdgeInsetsMake(0, SCREEN_SIZE.width - 30, 0, 0)
        self.changePassword.imageEdgeInsets = UIEdgeInsetsMake(0, SCREEN_SIZE.width - 30, 0, 0)
        self.changeAddress.imageEdgeInsets = UIEdgeInsetsMake(0, SCREEN_SIZE.width - 30, 0, 0)
        self.username.imageEdgeInsets = UIEdgeInsetsMake(0, SCREEN_SIZE.width - 30, 0, 0)
        
        self.avatar.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "choosePhoto"))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
//        if self.firstLoad {
            UserAPI.getUserProfile({ () -> Void in
                self.username.setTitle(User.sharedUser.displayName, forState: UIControlState.Normal)
                self.email.setTitle(User.sharedUser.email, forState: .Normal)
                let urlStr = Constant.MyUrl.ImageURL + User.sharedUser.imageURL
                self.avatar.sd_setImageWithURL(NSURL(string: urlStr), placeholderImage: UIImage(named: "avatar_default"))
                self.firstLoad = false
                }, failure: { (error) -> Void in
                    self.view.makeToast(error)
            })
//        }
    }
    
    // MARK: BUTTON ACTION
    
    @IBAction func changePhotoAction(sender: AnyObject) {
        self.choosePhoto()
    }
    
    @IBAction func changePasswordAction(sender: AnyObject) {
        let changePassViewController = ChangePasswordViewController()
        self.navigationController?.pushViewController(changePassViewController, animated: true)
    }

    @IBAction func changeAddressAction(sender: AnyObject) {
        let changeAddressController = ChangeAddressViewController()
        self.navigationController?.pushViewController(changeAddressController, animated: true)
    }
    
    @IBAction func changeUserInfoAction(sender: AnyObject) {
    }
    
    func choosePhoto() {
        let actionSheet = UIActionSheet(title: "Select Photo", delegate: self, cancelButtonTitle: "Cancel", destructiveButtonTitle: nil, otherButtonTitles: "Take Photo", "Choose from Library")
        actionSheet.showInView(self.view)
    }
    
    // MARK: ACTION SHEET
    func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int) {
        if buttonIndex != 0 {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            if buttonIndex == 1 {
                imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
            } else if buttonIndex == 2 {
                imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            }
            self.presentViewController(imagePicker, animated: true, completion: nil)
        }
    }
    
    // MARK: IMAGE PICKER CONTROLLER DELEGATE
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        self.dismissViewControllerAnimated(true, completion: { () -> Void in
            let image: UIImage = info[UIImagePickerControllerOriginalImage] as! UIImage
            MRProgressOverlayView.showOverlayAddedTo(self.view, title: "Updating...", mode: MRProgressOverlayViewMode.IndeterminateSmall, animated: true)
            UserAPI.updatePhotoProfile(image, completion: { () -> Void in
                MRProgressOverlayView.dismissOverlayForView(self.view, animated: true)
                self.avatar.image = image
                let urlStr = Constant.MyUrl.ImageURL + User.sharedUser.imageURL
//                self.avatar.sd_setImageWithURL(NSURL(string: urlStr), placeholderImage: UIImage(named: "avatar_default"))
                }) { (error) -> Void in
                    MRProgressOverlayView.dismissOverlayForView(self.view, animated: true)
                    self.view.makeToast(error)
            }
        })
    }

}
