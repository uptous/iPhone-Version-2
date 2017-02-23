//
//  CustomView.swift
//  PlaceFinder
//
//  Created by Abdul on 5/4/16.
//  Copyright © 2016 Virtual Employee Pvt Ltd. All rights reserved.
//

import UIKit

class CustomView: UIView {

//    self.layer.borderColor = UIColor(red: CGFloat(0.8), green: CGFloat(0.8), blue: CGFloat(0.8), alpha: CGFloat(1)).CGColor
//    self.layer.borderWidth = CGFloat(1.0)
//    self.layer.cornerRadius = 8.0
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = 8.0
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = 1.0
        }
    }
    
    @IBInspectable var borderColor: UIColor = UIColor.gray {
        didSet {
            layer.borderColor = UIColor(red: CGFloat(0.8), green: CGFloat(0.8), blue: CGFloat(0.8), alpha: CGFloat(1)).cgColor
        }
    }

}
