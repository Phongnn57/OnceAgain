//
//  CommentCell.swift
//  1Again
//
//  Created by Nam Phong on 7/2/15.
//  Copyright (c) 2015 Phong Nguyen Nam. All rights reserved.
//

import UIKit

class CommentCell: UITableViewCell {

    @IBOutlet weak var user: UILabel!
    @IBOutlet weak var comment: UILabel!
    @IBOutlet weak var avatar: UIImageView!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupCellWithComment(comment: CommentObject) {
        let commentTitle = "\(comment.displayName) (\(getDateFromString(comment.timestamp)) days ago)"
        self.user.text = commentTitle
        self.comment.text = comment.comment
        self.avatar.sd_setImageWithURL(NSURL(string: Constant.MyUrl.ImageURL + comment.profileImage), placeholderImage: UIImage(named: "avatar_default"))
    }
}
