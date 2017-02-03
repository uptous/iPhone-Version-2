//
//  BaseButton.swift
//  E-Grocery
//
//  Created by Muneeba on 1/12/15.
//  Copyright (c) 2015 cubixlabs. All rights reserved.
//

import UIKit

class BaseUIButton: UIButton {
    
    @IBInspectable var boarder:Int = 0;
    @IBInspectable var cornerRadius:Int = 0;
    
    @IBInspectable var hasDropShadow:Bool = false
    @IBInspectable var bgColorStyle:String! = DEFAULT
    @IBInspectable var bgSelectedColorStyle:String! = DEFAULT
    @IBInspectable var boarderColorStyle:String! = DEFAULT
    @IBInspectable var rounded:Bool = false
    @IBInspectable var fontStyle:String = "Regular"
    @IBInspectable var fontColorStyle:String! = DEFAULT
    @IBInspectable var fontSelectedColorStyle:String! = DEFAULT
    @IBInspectable var sizeForIPad:Bool = false
    
    override var isSelected:Bool {
        get {
            return super.isSelected;
        }
        set {
            super.isSelected = newValue;
            if (bgColorStyle != nil && bgSelectedColorStyle != nil) {
                //self.backgroundColor = Utility.color(ColorStyle(rawValue: (newValue == true) ?bgSelectedColorStyle:bgColorStyle));
            }
        }
    }
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        //self.updateView()
        self.isExclusiveTouch = true;
        self.imageView?.contentMode = UIViewContentMode.scaleAspectFit;
        
        for view:UIView in self.subviews {
            view.contentMode = UIViewContentMode.scaleAspectFit;
        }
    }
    
    /*func updateView()
    {
        //self.titleLabel?.font = UIFont(name: self.titleLabel!.font.fontName, size: Utility.convertFontSizeToRatio(self.titleLabel!.font.pointSize, fontStyle: FontStyle(rawValue:fontStyle),sizedForIPad:self.sizeForIPad));
        
        if (fontColorStyle != nil)
        {
            self.setTitleColor(Utility.color(ColorStyle(rawValue: fontColorStyle)), for: UIControlState.Normal);
        }
        
        if (fontSelectedColorStyle != nil)
        {
            self.setTitleColor(Utility.color(ColorStyle(rawValue: fontSelectedColorStyle)), for: UIControlState.Selected);
        }
        
        if (boarder > 0) {
            self.addBorder(Utility.color(boarderColorStyle), width: boarder)
        }
        
        if (bgColorStyle != nil) {
            self.backgroundColor = Utility.color(ColorStyle(rawValue: bgColorStyle));
        }
        
        if (cornerRadius != 0) {
            self.addRoundedCorners(Utility.convertToRatio(CGFloat(cornerRadius), sizedForIPad: sizeForIPad));
        }
        
        if (hasDropShadow) {
            self.addDropShadow();
        }
    }*/
    
    override func layoutSubviews() {
        super.layoutSubviews()
                if rounded {
            self.addRoundedCorners()
        }
    }
}
