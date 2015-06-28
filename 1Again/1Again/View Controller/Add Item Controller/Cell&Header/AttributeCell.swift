//
//  AttributeCell.swift
//  1Again
//
//  Created by Nam Phong on 6/27/15.
//  Copyright (c) 2015 Phong Nguyen Nam. All rights reserved.
//

import UIKit

class AttributeCell: UITableViewCell {

    @IBOutlet weak var category: MyCustomTextField!
    @IBOutlet weak var brand: MyCustomTextField!
    @IBOutlet weak var condition: MyCustomTextField!
    @IBOutlet weak var age: MyCustomTextField!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        configTextfield(category)
        configTextfield(condition)
        configTextfield(age)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configTextfield(textField: UITextField!) {
        textField.rightViewMode = UITextFieldViewMode.Always
        textField.rightView = UIImageView(image: UIImage(named: "textfield:add-item-down-arrow.png"))
    }
    
}
