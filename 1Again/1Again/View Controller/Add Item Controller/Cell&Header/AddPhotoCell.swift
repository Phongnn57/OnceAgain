//
//  AddPhotoCell.swift
//  1Again
//
//  Created by Nam Phong on 6/27/15.
//  Copyright (c) 2015 Phong Nguyen Nam. All rights reserved.
//

import UIKit

protocol AddPhotoCellDelegate {
    func clickImage(image: AddPhotoImageView, index: Int)
    func updateImage()
}

class AddPhotoCell: UITableViewCell {

    @IBOutlet weak var image1: AddPhotoImageView!
    @IBOutlet weak var image2: AddPhotoImageView!
    @IBOutlet weak var image3: AddPhotoImageView!
    @IBOutlet weak var image4: AddPhotoImageView!
    @IBOutlet weak var image5: AddPhotoImageView!
    @IBOutlet weak var btnUpdateImage: UIButton!
    
    var delegate: AddPhotoCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.image1.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "updateImage:"))
        self.image2.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "updateImage:"))
        self.image3.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "updateImage:"))
        self.image4.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "updateImage:"))
        self.image5.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "updateImage:"))
    }

    @IBAction func UpdateImageAction(sender: AnyObject) {
        self.delegate?.updateImage()
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func updateImage(sender: AnyObject) {
        let imageView = (sender as! UITapGestureRecognizer).view as! AddPhotoImageView
        if imageView.isEqual(self.image1) {
            self.delegate?.clickImage(imageView, index: 0)
        } else if imageView.isEqual(self.image2) {
            self.delegate?.clickImage(imageView, index: 1)
        } else if imageView.isEqual(self.image3) {
            self.delegate?.clickImage(imageView, index: 2)
        } else if imageView.isEqual(self.image4) {
            self.delegate?.clickImage(imageView, index: 3)
        } else if imageView.isEqual(self.image5) {
            self.delegate?.clickImage(imageView, index: 4)
        }
    }
    
    func setImageInCell(item: Item!) {
        
        let imageArr: [UIImage?] = [item.image1, item.image2, item.image3, item.image4, item.image5]
        let imageViewArr: [AddPhotoImageView!] = [self.image1, self.image2, self.image3, self.image4, self.image5]
        
        var currentImage: Int = 5
        
        for var i = 0; i < imageArr.count; i++ {
            if imageArr[i] == nil {
                currentImage = i
                break
            }
        }
        
        for var i = 0; i < imageViewArr.count; i++ {
            if i < currentImage {
                imageViewArr[i].image = imageArr[i]
                imageViewArr[i].tag = 555
            } else if i == currentImage {
                imageViewArr[i].image = UIImage(named: "image:add-item-camera.png")
                imageViewArr[i].tag = 556
            } else {
                imageViewArr[i].image = UIImage(named: "image:add-item-default.png")
                imageViewArr[i].tag = 557
            }
        }
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
