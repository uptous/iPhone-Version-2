//
//  CustomTextField.swift
//  PlaceFinder
//
//  Created by Abdul on 5/4/16.
//  Copyright © 2016 Virtual Employee Pvt Ltd. All rights reserved.
//

import UIKit

class CustomTextField: UITextField {

    @IBInspectable var placeholderColor: UIColor = UIColor.white {
        didSet {
            let canEditPlaceholderColor = self.responds(to: #selector(setter: UITextField.attributedPlaceholder))
            
            if (canEditPlaceholderColor) {
                self.attributedPlaceholder = NSAttributedString(string: placeholder!, attributes:[NSForegroundColorAttributeName: placeholderColor])
            }
        }
    }

}
