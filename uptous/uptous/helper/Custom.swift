//
//  Custom.swift
//  uptous
//
//  Created by Roshan Gita  on 9/10/16.
//  Copyright © 2016 SPA. All rights reserved.
//

import UIKit

class Custom: NSObject {

    class func dayStringFromTime(unixTime: Double) -> String {
        let epocTime = NSTimeInterval(unixTime) / 1000
        let dateFormatter = NSDateFormatter()
        let myDate = NSDate(timeIntervalSince1970:  epocTime)
        dateFormatter.locale = NSLocale(localeIdentifier: NSLocale.currentLocale().localeIdentifier)
        dateFormatter.dateFormat = "MMM d, yyyy"
        
        return dateFormatter.stringFromDate(myDate)
    }
    
    class func dayStringFromTime1(unixTime: Double) -> String {
        let epocTime = NSTimeInterval(unixTime) / 1000
        let dateFormatter = NSDateFormatter()
        let myDate = NSDate(timeIntervalSince1970:  epocTime)
        dateFormatter.locale = NSLocale(localeIdentifier: NSLocale.currentLocale().localeIdentifier)
        dateFormatter.dateFormat = "MMM d"
        
        return dateFormatter.stringFromDate(myDate)
    }
    
    //Mark:- Get Label Width with text
    class func widthSize(text:String, fontName:String, fontSize:CGFloat) -> CGFloat{
        let textSize: CGSize = text.sizeWithAttributes([NSFontAttributeName: UIFont(name: fontName, size: fontSize)!])
        
        return textSize.width
    }
    
    //MARK:- Bold String
    class func attributedString(str: String,size:CGFloat) -> NSAttributedString? {
        let attributes = [
            NSForegroundColorAttributeName : UIColor.blackColor(),
            NSFontAttributeName: UIFont.boldSystemFontOfSize(size)
            //NSUnderlineStyleAttributeName : NSUnderlineStyle.StyleSingle.rawValue
        ]
        let attributedString = NSAttributedString(string: str, attributes: attributes)
        return attributedString
    }
    
    class func attributedString1(str: String,size:CGFloat) -> NSAttributedString? {
        let attributes = [
            NSForegroundColorAttributeName : UIColor.redColor(),
            NSFontAttributeName: UIFont.boldSystemFontOfSize(size)
            //NSUnderlineStyleAttributeName : NSUnderlineStyle.StyleSingle.rawValue
        ]
        let attributedString = NSAttributedString(string: str, attributes: attributes)
        return attributedString
    }
    
    class func fullCornerView(ownerView: UIView) ->UIView {
        ownerView.layer.borderColor = UIColor.clearColor().CGColor
        ownerView.layer.borderWidth = CGFloat(1.0)
        ownerView.layer.cornerRadius = ownerView.frame.size.width/2
        
        return ownerView
    }
    
    class func cornerView(contentsView: UIView) ->UIView {
        contentsView.layer.borderColor = UIColor(red: CGFloat(0.8), green: CGFloat(0.8), blue: CGFloat(0.8), alpha: CGFloat(1)).CGColor
        contentsView.layer.borderWidth = CGFloat(1.0)
        contentsView.layer.cornerRadius = 8.0
        
        return contentsView
    }
    
    class func buttonCorner(button: UIButton) ->UIButton {
        button.layer.borderColor = UIColor.clearColor().CGColor
        button.layer.borderWidth = CGFloat(1.0)
        button.layer.cornerRadius = 8.0
        
        return button
    }

}
