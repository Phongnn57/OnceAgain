//
//  AddPhotoCell.swift
//  1Again
//
//  Created by Nam Phong on 6/27/15.
//  Copyright (c) 2015 Phong Nguyen Nam. All rights reserved.
//

import UIKit

class AddPhotoCell: UITableViewCell {

    @IBOutlet weak var image1: AddPhotoImageView!
    @IBOutlet weak var image2: AddPhotoImageView!
    @IBOutlet weak var image3: AddPhotoImageView!
    @IBOutlet weak var image4: AddPhotoImageView!
    @IBOutlet weak var image5: AddPhotoImageView!

    @IBOutlet weak var btnUpdateImage: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setImageInCell(item: ItemObject!) {
        if item.image1 == nil {
            setCameraImage(image1)
            setDefaultImage(image2)
            setDefaultImage(image3)
            setDefaultImage(image4)
            setDefaultImage(image5)
        } else if item.image1 != nil && item.image2 == nil {
            image1.image = item.image1
            setCameraImage(image2)
            setDefaultImage(image3)
            setDefaultImage(image4)
            setDefaultImage(image5)
            image1.imageMode = Constant.AddItemPhotoMode.ImageViewAlreadyHasImage
        } else if item.image2 != nil && item.image3 == nil {
            image1.image = item.image1
            image2.image = item.image2
            setCameraImage(image3)
            setDefaultImage(image4)
            setDefaultImage(image5)
            image1.imageMode = Constant.AddItemPhotoMode.ImageViewAlreadyHasImage
            image2.imageMode = Constant.AddItemPhotoMode.ImageViewAlreadyHasImage
        } else if item.image3 != nil && item.image4 == nil {
            image1.image = item.image1
            image2.image = item.image2
            image3.image = item.image3
            setCameraImage(image4)
            setDefaultImage(image5)
            image1.imageMode = Constant.AddItemPhotoMode.ImageViewAlreadyHasImage
            image2.imageMode = Constant.AddItemPhotoMode.ImageViewAlreadyHasImage
            image3.imageMode = Constant.AddItemPhotoMode.ImageViewAlreadyHasImage
        } else if item.image4 != nil && item.image5 == nil {
            image1.image = item.image1
            image2.image = item.image2
            image3.image = item.image3
            image4.image = item.image4
            setCameraImage(image5)
            image1.imageMode = Constant.AddItemPhotoMode.ImageViewAlreadyHasImage
            image2.imageMode = Constant.AddItemPhotoMode.ImageViewAlreadyHasImage
            image3.imageMode = Constant.AddItemPhotoMode.ImageViewAlreadyHasImage
            image4.imageMode = Constant.AddItemPhotoMode.ImageViewAlreadyHasImage
        } else if item.image5 != nil {
            image1.image = item.image1
            image2.image = item.image2
            image3.image = item.image3
            image4.image = item.image4
            image5.image = item.image5
            image1.imageMode = Constant.AddItemPhotoMode.ImageViewAlreadyHasImage
            image2.imageMode = Constant.AddItemPhotoMode.ImageViewAlreadyHasImage
            image3.imageMode = Constant.AddItemPhotoMode.ImageViewAlreadyHasImage
            image4.imageMode = Constant.AddItemPhotoMode.ImageViewAlreadyHasImage
            image5.imageMode = Constant.AddItemPhotoMode.ImageViewAlreadyHasImage
        }
    }
    
    func setCameraImage(image: AddPhotoImageView) {
        image.imageName("image:add-item-camera.png")
        image.imageMode = Constant.AddItemPhotoMode.ImageViewHasCameraImage
        
    }
    func setDefaultImage(image: AddPhotoImageView) {
        image.imageName("image:add-item-default.png")
        image.imageMode = Constant.AddItemPhotoMode.ImageViewHasDefaultImage
    }
}

class AddPhotoImageView: UIImageView {
    var imageMode: Int!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.borderWidth = 1.0
        self.layer.borderColor = UIColor(rgba: "#e0e0e0").CGColor
    }
    
    func imageName(name: String) {
        self.image = UIImage(named: name)
    }
    
    func image(image: UIImage) {
        self.image = image
    }
}
