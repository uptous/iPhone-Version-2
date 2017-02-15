//
//  BaseView.swift
//  E-Grocery
//
//  Created by Muneeba on 1/14/15.
//  Copyright (c) 2015 cubixlabs. All rights reserved.
//

import UIKit

class BaseUIView: UIView {

    @IBInspectable var boarder:Int = 0;
    @IBInspectable var cornerRadius:Int = 0;
    
    @IBInspectable var hasDropShadow:Bool = false;
    
    @IBInspectable var bgColorStyle:String! = DEFAULT;
    @IBInspectable var boarderColorStyle:String! = DEFAULT;
    
    @IBInspectable var rounded:Bool = false;
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        //--
        
    } //F.E.
    

    
    override func layoutSubviews() {
        super.layoutSubviews();
        //--
        if rounded {
            self.addRoundedCorners();
        }
    } //F.E.
    
} //CLS END
