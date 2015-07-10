//
//  AddNewCommentCell.swift
//  1Again
//
//  Created by Nam Phong on 7/2/15.
//  Copyright (c) 2015 Phong Nguyen Nam. All rights reserved.
//

import UIKit

protocol AddNewCommentCellDelegate {
    func doPostComment(cell: AddNewCommentCell)
}

class AddNewCommentCell: UITableViewCell {
    
    @IBOutlet weak var comment: MyCustomTextField!
    var delegate: AddNewCommentCellDelegate?
    
    @IBAction func doPostComment(sender: AnyObject) {
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    @IBAction func postComment(sender: AnyObject) {
        self.delegate?.doPostComment(self)
    }
}
