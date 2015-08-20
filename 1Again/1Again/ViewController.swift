//
//  ViewController.swift
//  1Again
//
//  Created by Nam Phong on 6/26/15.
//  Copyright (c) 2015 Phong Nguyen Nam. All rights reserved.
//

import UIKit

class ViewController: BaseViewController {

    @IBOutlet weak var menuBarBtn: UIBarButtonItem!
//    
    var shopLocalButton: MIBadgeButton!
    var favoriteButton: MIBadgeButton!
    var myItemButton: MIBadgeButton!
    var addItemButton: MIBadgeButton!
    var messageButton: MIBadgeButton!
    var profilelButton: MIBadgeButton!
    var notificationlButton: MIBadgeButton!
    var myStoreButton: MIBadgeButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.translucent = false
        self.setMenuButtonAction(menuBarBtn)
        
        self.initialize()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        println("User name: \(User.sharedUser.userName)")
        println("User type: \(User.sharedUser.userType)")
        println("User ID: \(User.sharedUser.userID)")
        
        if User.sharedUser.userType == "B" {
            self.notificationlButton.hidden = false
            self.myStoreButton.hidden = false
        } else if User.sharedUser.userType == "P" {
            self.notificationlButton.hidden = true
            self.myStoreButton.hidden = true
        }
        
        if User.sharedUser.userID.isEmpty {
            let loginController = LoginViewController()
            self.presentViewController(loginController, animated: true, completion: nil)
        } else {
            
            UserAPI.loadHomePage({ (notiCount, messCount) -> Void in
                self.notificationlButton.badgeString = "\(notiCount)"
                self.messageButton.badgeString = "\(messCount)"
            }, failure: { (error) -> Void in
                self.view.makeToast(error)
            })
        }
    }
    
    func initialize() {
        let buttonWidth: CGFloat = (SCREEN_SIZE.width - 48)/2
        let buttonHeigh: CGFloat = 60
        
        shopLocalButton = MIBadgeButton(frame: CGRectMake(16, 30, buttonWidth, buttonHeigh))
        favoriteButton = MIBadgeButton(frame: CGRectMake(32 + buttonWidth, 30, buttonWidth, buttonHeigh))
        myItemButton = MIBadgeButton(frame: CGRectMake(16, 106, buttonWidth, buttonHeigh))
        addItemButton = MIBadgeButton(frame: CGRectMake(32 + buttonWidth, 106, buttonWidth, buttonHeigh))
        messageButton = MIBadgeButton(frame: CGRectMake(16, 182, buttonWidth, buttonHeigh))
        profilelButton = MIBadgeButton(frame: CGRectMake(32 + buttonWidth, 182, buttonWidth, buttonHeigh))
        
        
        
        notificationlButton = MIBadgeButton(frame: CGRectMake(16, 268, buttonWidth, buttonHeigh))
        myStoreButton = MIBadgeButton(frame: CGRectMake(32 + buttonWidth, 268, buttonWidth, buttonHeigh))
        
        shopLocalButton.setTitle("Shop Locally", forState: .Normal)
        favoriteButton.setTitle("My Favorites", forState: .Normal)
        myItemButton.setTitle("My Items", forState: .Normal)
        addItemButton.setTitle("Add Item", forState: .Normal)
        messageButton.setTitle("Messages", forState: .Normal)
        profilelButton.setTitle("Profile", forState: .Normal)
        notificationlButton.setTitle("Notifications", forState: .Normal)
        myStoreButton.setTitle("My Store", forState: .Normal)
        
        shopLocalButton.layer.cornerRadius = 16
        favoriteButton.layer.cornerRadius = 16
        myItemButton.layer.cornerRadius = 16
        addItemButton.layer.cornerRadius = 16
        messageButton.layer.cornerRadius = 16
        profilelButton.layer.cornerRadius = 16
        notificationlButton.layer.cornerRadius = 16
        myStoreButton.layer.cornerRadius = 16
        
        notificationlButton.badgeEdgeInsets = UIEdgeInsetsMake(10, 0, 0, 10)
        messageButton.badgeEdgeInsets = UIEdgeInsetsMake(10, 0, 0, 10)
        
        self.view.addSubview(shopLocalButton)
        self.view.addSubview(favoriteButton)
        self.view.addSubview(myItemButton)
        self.view.addSubview(addItemButton)
        self.view.addSubview(messageButton)
        self.view.addSubview(profilelButton)
        self.view.addSubview(notificationlButton)
        self.view.addSubview(myStoreButton)
        
        self.addItemButton.addTarget(self, action: "movetoAddItem", forControlEvents: UIControlEvents.TouchUpInside)
        self.notificationlButton.addTarget(self, action: "movetoNotification", forControlEvents: UIControlEvents.TouchUpInside)
        self.myItemButton.addTarget(self, action: "movetoItems", forControlEvents: UIControlEvents.TouchUpInside)
        self.messageButton.addTarget(self, action: "movetoMessage", forControlEvents: UIControlEvents.TouchUpInside)
        self.favoriteButton.addTarget(self, action: "movetoFavorite", forControlEvents: UIControlEvents.TouchUpInside)
        self.shopLocalButton.addTarget(self, action: "movetoShopLocalView", forControlEvents: UIControlEvents.TouchUpInside)
        self.profilelButton.addTarget(self, action: "movetoProfile", forControlEvents: UIControlEvents.TouchUpInside)
//        self.addItemButton.addTarget(self, action: "movetoAddItem", forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    func movetoAddItem() {
        let addItem = STORYBOARD.instantiateViewControllerWithIdentifier("addItemView") as! AddItemViewController
        self.navigationController?.pushViewController(addItem, animated: true)
    }
    
    func movetoNotification() {
        let notificationView = STORYBOARD.instantiateViewControllerWithIdentifier("notificationView") as! NotificationViewController
        self.navigationController?.pushViewController(notificationView, animated: true)
    }
    
    func movetoItems() {
        let itemView = STORYBOARD.instantiateViewControllerWithIdentifier("itemView") as! ItemListViewController
        self.navigationController?.pushViewController(itemView, animated: true)
    }
    func movetoMessage() {
        let messageView = STORYBOARD.instantiateViewControllerWithIdentifier("messageView") as! MessageTableViewController
        self.navigationController?.pushViewController(messageView, animated: true)
    }
    func movetoFavorite() {
        let favoriteView = STORYBOARD.instantiateViewControllerWithIdentifier("favoriteView") as! FavoriteViewController
        self.navigationController?.pushViewController(favoriteView, animated: true)
    }
    func movetoShopLocalView() {
        let shopLocalView = STORYBOARD.instantiateViewControllerWithIdentifier("shopLocalView") as! ShopLocalViewController
        self.navigationController?.pushViewController(shopLocalView, animated: true)
    }
    func movetoProfile() {
        let profileView = STORYBOARD.instantiateViewControllerWithIdentifier("profileView") as! ProfileViewController
        self.navigationController?.pushViewController(profileView, animated: true)
    }


}