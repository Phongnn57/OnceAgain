//
//  ItemActionViewController.swift
//  1Again
//
//  Created by Nam Phong Nguyen on 8/22/15.
//  Copyright (c) 2015 Phong Nguyen Nam. All rights reserved.
//

import UIKit

class ItemActionViewController: BaseSubViewController, UIActionSheetDelegate {

    @IBOutlet weak var itemImage: UIImageView!
    @IBOutlet weak var seller: UILabel!
    @IBOutlet weak var buyer: UILabel!
    @IBOutlet weak var itemName: UILabel!
    @IBOutlet weak var addedTime: UILabel!
    @IBOutlet weak var btnAction: UIButton!
    @IBOutlet weak var commentTextView: UITextView!
    @IBOutlet weak var btnSubmit: UIButton!

    var actionID: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.btnAction.imageEdgeInsets = UIEdgeInsetsMake(0, SCREEN_SIZE.width - 130, 0, 0)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    @IBAction func submitAction(sender: AnyObject) {
        
    }
    
    @IBAction func didSelectActionButton(sender: AnyObject) {
        let actionSheet = UIActionSheet(title: "Select action", delegate: self, cancelButtonTitle: "Cancel", destructiveButtonTitle: nil, otherButtonTitles: "Offered", "Consigned", "Sold")
        actionSheet.showInView(self.view)
    }
    
    func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int) {
        if buttonIndex == 1 {
            self.actionID = "A"
        } else if buttonIndex == 2 {
            self.actionID = "C"
        } else if buttonIndex == 3 {
            self.actionID = "S"
        }
    }

}
