//
//  ActivityIndicator.swift
//  PlaceFinder
//
//  Created by Abdul on 5/11/16.
//  Copyright © 2016 Virtual Employee Pvt Ltd. All rights reserved.
//

import UIKit
import RappleProgressHUD

class ActivityIndicator: NSObject {

    class func show() {
       RappleActivityIndicatorView.startAnimatingWithLabel("Loading...", attributes: RappleModernAttributes)
    }

    class func showWithText(text: String) {
        RappleActivityIndicatorView.startAnimatingWithLabel(text, attributes: RappleModernAttributes)
    }
    
    class func hide() {
        RappleActivityIndicatorView.stopAnimating()
    }

}
