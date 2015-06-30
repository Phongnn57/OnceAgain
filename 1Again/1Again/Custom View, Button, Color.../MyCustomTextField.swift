//
//  MyCustomTextField.swift
//  1Again
//
//  Created by Nam Phong on 6/27/15.
//  Copyright (c) 2015 Phong Nguyen Nam. All rights reserved.
//

import UIKit

class MyCustomTextField: UITextField {

    override func awakeFromNib() {

    }
    
    override func textRectForBounds(bounds: CGRect) -> CGRect {
        return CGRectInset(bounds, 10, 10)
    }
    
    override func editingRectForBounds(bounds: CGRect) -> CGRect {
        return CGRectInset(bounds, 10, 10)
    }
    
    override func rightViewRectForBounds(bounds: CGRect) -> CGRect {
        var textRect = super.rightViewRectForBounds(bounds)
        textRect.origin.x -= 10
        return textRect
    }
    
    func addImageToRightViewWithImage(image: UIImage!) {
        self.rightViewMode = UITextFieldViewMode.Always
        self.rightView = UIImageView(image: image)
    }
}


