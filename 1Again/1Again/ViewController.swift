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
    
    
    @IBOutlet weak var btnShopLocal: MIBadgeButton!
    @IBOutlet weak var btnMyFavorites: MIBadgeButton!
    @IBOutlet weak var btnMyItems: MIBadgeButton!
    @IBOutlet weak var btnAddItem: MIBadgeButton!
    @IBOutlet weak var btnMessages: MIBadgeButton!
    @IBOutlet weak var btnProfile: MIBadgeButton!
    @IBOutlet weak var btnNotifications: MIBadgeButton!
    @IBOutlet weak var btnMyStore: MIBadgeButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.translucent = false
        self.setMenuButtonAction(menuBarBtn)
        
        
        self.btnNotifications.badgeEdgeInsets = UIEdgeInsetsMake(20, 0, 0, 20)
        self.btnMessages.badgeEdgeInsets = UIEdgeInsetsMake(20, 0, 0, 20)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        if User.sharedUser.userType == "B" {
            self.btnNotifications.hidden = false
            self.btnMyStore.hidden = false
        } else if User.sharedUser.userType == "P" {
            self.btnNotifications.hidden = true
            self.btnMyStore.hidden = true
        }
        
        if User.sharedUser.userID.isEmpty {
            let loginController = LoginViewController()
            self.presentViewController(loginController, animated: true, completion: nil)
        } else {
            SellerManager.sharedInstance.getAllSellers()
            UserAPI.loadHomePage({ (notiCount, messCount) -> Void in
                if notiCount > 0 {
                    self.btnNotifications.badgeString = "\(notiCount)"
                }
                
                if messCount > 0 {
                    self.btnMessages.badgeString = "\(messCount)"
                }
            }, failure: { (error) -> Void in
                self.view.makeToast(error)
            })
        }
    }

    @IBAction func gotoShopLocal(sender: AnyObject) {
        let shopLocalView = STORYBOARD.instantiateViewControllerWithIdentifier("shopLocalView") as! ShopLocalViewController
        self.navigationController?.pushViewController(shopLocalView, animated: true)
    }
    
    @IBAction func gotoMyFavorite(sender: AnyObject) {
        let favoriteView = STORYBOARD.instantiateViewControllerWithIdentifier("favoriteView") as! FavoriteViewController
        self.navigationController?.pushViewController(favoriteView, animated: true)
    }
    
    @IBAction func gotoMyItems(sender: AnyObject) {
        let itemView = STORYBOARD.instantiateViewControllerWithIdentifier("itemView") as! ItemListViewController
        self.navigationController?.pushViewController(itemView, animated: true)
    }

    @IBAction func gotoAddItem(sender: AnyObject) {
        let addItem = STORYBOARD.instantiateViewControllerWithIdentifier("addItemView") as! AddItemViewController
        self.navigationController?.pushViewController(addItem, animated: true)
    }
    
    @IBAction func gotoMessage(sender: AnyObject) {
        let messageView = STORYBOARD.instantiateViewControllerWithIdentifier("messageView") as! MessageTableViewController
        self.navigationController?.pushViewController(messageView, animated: true)
    }
    
    @IBAction func gotoProfile(sender: AnyObject) {
        let profileView = STORYBOARD.instantiateViewControllerWithIdentifier("profileView") as! ProfileViewController
        self.navigationController?.pushViewController(profileView, animated: true)
    }
    
    @IBAction func gotoNotifications(sender: AnyObject) {
        let notificationView = STORYBOARD.instantiateViewControllerWithIdentifier("notificationView") as! NotificationViewController
        self.navigationController?.pushViewController(notificationView, animated: true)
    }
    
    
    @IBAction func gotoMyStore(sender: AnyObject) {
        let itemActionView = ItemActionViewController()
        self.navigationController?.pushViewController(itemActionView, animated: true)
    }
}