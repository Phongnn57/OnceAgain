//
//  PriceCell.swift
//  1Again
//
//  Created by Nam Phong on 6/27/15.
//  Copyright (c) 2015 Phong Nguyen Nam. All rights reserved.
//

import UIKit

class PriceCell: UITableViewCell {

    @IBOutlet weak var consign: PriceImageView!
    @IBOutlet weak var donate: PriceImageView!
    @IBOutlet weak var sale: PriceImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configImageView()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configImageView() {
        consign.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "changeState:"))
        donate.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "changeState:"))
        sale.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "changeState:"))
    }
    
    func changeState(sender: AnyObject) {
        let image = (sender as! UITapGestureRecognizer).view as! PriceImageView
        image.changeState(nil)
    }
    
    func setImageCell(item: ItemObject!) {
        if item.consign == "0" {consign.imageName("image:add-item-consign.png")}
        else {consign.imageName("image:add-item-consign-selected.png")}
        
        if item.donate == "0" {donate.imageName("image:add-item-donate.png")}
        else {donate.imageName("image:add-item-donate-selected.png")}
        
        if item.sale == "0" {sale.imageName("image:add-item-for-sale.png")}
        else {sale.imageName("image:add-item-for-sale-selected.png")}
    }
}

class PriceImageView:UIImageView {
    
    var isSelect: Bool = false
    var shouldShowPrice: Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func changeImageTo(imageName: String) {
        self.image = UIImage(named: imageName)
    }
    
    func changeState(sender: AnyObject!) {
        isSelect = !isSelect
        
        switch self.tag {
            case 10:
                isSelect == true ? changeImageTo("image:add-item-consign-selected.png") : changeImageTo("image:add-item-consign.png")
            case 11:
                isSelect == true ? changeImageTo("image:add-item-donate-selected.png") : changeImageTo("image:add-item-donate.png")
            case 12:
                isSelect == true ? changeImageTo("image:add-item-for-sale-selected.png") : changeImageTo("image:add-item-for-sale.png")
            default: break
        }
    }
    
    func imageName(name: String) {
        self.image = UIImage(named: name)
    }
    
    func image(image: UIImage) {
        self.image = image
    }

    func getValueOfItem(item: ItemObject!) -> String! {
        if tag == 10 {
            if item.consign == "0" {
                self.imageName("image:add-item-consign-selected.png")
                return "1"
            } else {
                self.imageName("image:add-item-consign.png")
                return "0"
            }
        } else if tag == 11 {
            if item.donate == "0" {
                self.imageName("image:add-item-donate-selected.png")
                return "1"
            }
            else {
                self.imageName("image:add-item-donate.png")
                return "0"
            }
        } else if tag == 12 {
            if item.sale == "0" {
                self.imageName("image:add-item-for-sale-selected.png")
                return "1"
            }
            else {
                self.imageName("image:add-item-for-sale.png")
                return "0"
            }
        } else { return nil }
    }
    
}