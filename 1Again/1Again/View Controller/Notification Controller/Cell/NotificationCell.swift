//
//  NotificationCell.swift
//  1Again
//
//  Created by Nam Phong on 6/28/15.
//  Copyright (c) 2015 Phong Nguyen Nam. All rights reserved.
//

import UIKit

class NotificationCell: UITableViewCell {

    @IBOutlet weak var imageView1: UIImageView!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var descriptionTextview: UITextView!
    @IBOutlet weak var displayNameTextfield: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configCellWithNotification(notification: Notification) {
        self.distanceLabel.text = notification.timestamp
        self.displayNameTextfield.text = notification.displayName
        self.descriptionLabel.text = notification.title
        self.categoryLabel.text = notification.category
        
        //If description is more than 75 charaters,this code will truncate after the last word.
        var myTrimmedDescription: String = notification.desc!
        var lastChar: Character = "A"
        
        if (count(myTrimmedDescription) > 75) {
            myTrimmedDescription =  myTrimmedDescription.substringToIndex(advance(myTrimmedDescription.startIndex, 75))
            do {
                lastChar =  myTrimmedDescription[advance(myTrimmedDescription.startIndex, count(myTrimmedDescription)-1)]
                myTrimmedDescription =  myTrimmedDescription.substringToIndex(myTrimmedDescription.endIndex.predecessor())
            } while lastChar != " "
            self.descriptionTextview.text  = myTrimmedDescription + " ... (more)"
        } else {
            self.descriptionTextview.text  = myTrimmedDescription
        }
        print(notification.image1)
        
        let imgURL = Constant.MyUrl.homeURL + "uploads/" + notification.image1!
        
        self.imageView1.sd_setImageWithURL(NSURL(string: imgURL), placeholderImage: UIImage(named: "image:add-item-camera.png"))
    }
}
