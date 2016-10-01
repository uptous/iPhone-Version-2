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

}
