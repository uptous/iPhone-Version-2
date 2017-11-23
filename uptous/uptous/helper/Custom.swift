//
//  Custom.swift
//  uptous
//
//  Created by Roshan Gita  on 9/10/16.
//  Copyright © 2016 SPA. All rights reserved.
//

import UIKit

class Custom: NSObject {
    
    class func heightForView(text:String, font:UIFont, width:CGFloat) -> CGFloat{
        let rect = CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude)
        let label:UILabel = UILabel(frame: rect)
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = text
        
        label.sizeToFit()
        return label.frame.height
    }
    
    class func setGIFImage(name: String) -> UIImage {
        let imageData = try? Data(contentsOf: Bundle.main.url(forResource: ("\(name)"), withExtension: "gif")!)
        let advTimeGif = UIImage.gifImageWithData(imageData!)
        //gifImageView.image = advTimeGif
        
        return advTimeGif!
    }
    
    class func dayStringFromTime12(_ unixTime: Double) -> String {
        let epocTime = TimeInterval(unixTime) / 1000
        let dateFormatter = DateFormatter()
        let myDate = Date(timeIntervalSince1970:  epocTime)
        //dateFormatter.locale = Locale(identifier: "en")
        dateFormatter.timeZone = NSTimeZone(name: "PST") as TimeZone!
        //dateFormatter.locale = Locale(identifier: Locale.current.identifier)
        dateFormatter.dateFormat = "yyyy-dd-mm hh:mm:SSS"
        
        return dateFormatter.string(from: myDate)
    }
    
    class func dayStringSignupItems(_ unixTime: Double) -> String {
        let epocTime = TimeInterval(unixTime) / 1000
        let dateFormatter = DateFormatter()
        let myDate = Date(timeIntervalSince1970:  epocTime)
        dateFormatter.timeZone = NSTimeZone(name: "PST") as TimeZone!
        //dateFormatter.locale = Locale(identifier: Locale.current.identifier)
        dateFormatter.dateFormat = "MMM d"
        
        return dateFormatter.string(from: myDate)
    }

    class func dayStringFromTime(_ unixTime: Double) -> String {
        let epocTime = TimeInterval(unixTime) / 1000
        let dateFormatter = DateFormatter()
        let myDate = Date(timeIntervalSince1970:  epocTime)
        dateFormatter.timeZone = NSTimeZone(name: "PST") as TimeZone!
        //dateFormatter.locale = Locale(identifier: Locale.current.identifier)
        dateFormatter.dateFormat = "MMM d, yyyy, h:mm a"
        
        return dateFormatter.string(from: myDate)
    }
    
    class func dayStringFromTime1(_ unixTime: Double) -> String {
        let epocTime = TimeInterval(unixTime) / 1000
        let dateFormatter = DateFormatter()
        let myDate = Date(timeIntervalSince1970:  epocTime)
        //dateFormatter.locale = Locale(identifier: "en")
        dateFormatter.timeZone = NSTimeZone(name: "PST") as TimeZone!
        //dateFormatter.locale = Locale(identifier: Locale.current.identifier)
        dateFormatter.dateFormat = "MMM d"
        
        return dateFormatter.string(from: myDate)
    }
    
    class func dayStringFromTime2(_ unixTime: Double) -> String {
        let epocTime = TimeInterval(unixTime) / 1000
        let dateFormatter = DateFormatter()
        let myDate = Date(timeIntervalSince1970:  epocTime)
        //dateFormatter.locale = Locale(identifier: "en")
        dateFormatter.timeZone = NSTimeZone(name: "PST") as TimeZone!
        //dateFormatter.locale = Locale(identifier: Locale.current.identifier)
        dateFormatter.dateFormat = "EEE, MMM d"
        //dateFormatter.timeZone = NSTimeZone() as TimeZone!
        return dateFormatter.string(from: myDate as Date)
    }
    
    class func dayStringFromTime3(_ unixTime: Double) -> String {
        let epocTime = TimeInterval(unixTime) / 1000
        let dateFormatter = DateFormatter()
        let myDate = Date(timeIntervalSince1970:  epocTime)
        //dateFormatter.locale = Locale(identifier: "en")
        dateFormatter.timeZone = NSTimeZone(name: "PST") as TimeZone!
        //dateFormatter.locale = Locale(identifier: Locale.current.identifier)
        dateFormatter.dateFormat = "EEE, MMM d"
        
        return dateFormatter.string(from: myDate as Date)
    }
    
    class func dayStringFromTime4(_ unixTime: Double) -> String {
        let epocTime = TimeInterval(unixTime) / 1000
        let dateFormatter = DateFormatter()
        let myDate = Date(timeIntervalSince1970:  epocTime)
        //dateFormatter.locale = Locale(identifier: "en")
        dateFormatter.timeZone = NSTimeZone(name: "PST") as TimeZone!
        //dateFormatter.locale = Locale(identifier: Locale.current.identifier)
        dateFormatter.dateFormat = "h:mma"
        //dateFormatter.timeZone = NSTimeZone() as TimeZone!
        return dateFormatter.string(from: myDate as Date)
    }

    class func dayStringFromTime5(_ unixTime: Double) -> String {
        let epocTime = TimeInterval(unixTime) / 1000
        let dateFormatter = DateFormatter()
        let myDate = Date(timeIntervalSince1970:  epocTime)
        //dateFormatter.locale = Locale(identifier: "en")
        dateFormatter.timeZone = NSTimeZone(name: "PST") as TimeZone!
        //dateFormatter.locale = Locale(identifier: Locale.current.identifier)
        dateFormatter.dateFormat = "MM/dd/yyyy"
        
        return dateFormatter.string(from: myDate)
    }

    
    //Mark:- Get Label Width with text
    class func widthSize(_ text:String, fontName:String, fontSize:CGFloat) -> CGFloat{
        let textSize: CGSize = text.size(attributes: [NSFontAttributeName: UIFont(name: fontName, size: fontSize)!])
        
        return textSize.width
    }
    
    //MARK:- Bold String
    class func attributedString(_ str: String,size:CGFloat) -> NSAttributedString? {
        let attributes = [
            NSForegroundColorAttributeName : UIColor.black,
            NSFontAttributeName: UIFont.boldSystemFont(ofSize: size)
            //NSUnderlineStyleAttributeName : NSUnderlineStyle.StyleSingle.rawValue
        ]
        let attributedString = NSAttributedString(string: str, attributes: attributes)
        return attributedString
    }
    
    class func attributedString1(_ str: String,size:CGFloat) -> NSAttributedString? {
        let attributes = [
            NSForegroundColorAttributeName : UIColor.red,
            NSFontAttributeName: UIFont.boldSystemFont(ofSize: size)
            //NSUnderlineStyleAttributeName : NSUnderlineStyle.StyleSingle.rawValue
        ]
        let attributedString = NSAttributedString(string: str, attributes: attributes)
        return attributedString
    }
    
    class func fullCornerView(_ ownerView: UIView) ->UIView {
        ownerView.layer.borderColor = UIColor.clear.cgColor
        ownerView.layer.borderWidth = CGFloat(1.0)
        ownerView.layer.cornerRadius = 30
        
        return ownerView
    }
    
    class func fullCornerView1(_ ownerView: UIView) ->UIView {
        ownerView.layer.borderColor = UIColor.clear.cgColor
        ownerView.layer.borderWidth = CGFloat(1.0)
        ownerView.layer.cornerRadius = 25
        
        return ownerView
    }
    
    class func cornerView(_ contentsView: UIView) ->UIView {
        contentsView.layer.borderColor = UIColor(red: CGFloat(0.8), green: CGFloat(0.8), blue: CGFloat(0.8), alpha: CGFloat(1)).cgColor
        contentsView.layer.borderWidth = CGFloat(1.0)
        contentsView.layer.cornerRadius = 8.0
        
        return contentsView
    }
    
    class func buttonCorner(_ button: UIButton) ->UIButton {
        button.layer.borderColor = UIColor.clear.cgColor
        button.layer.borderWidth = CGFloat(1.0)
        button.layer.cornerRadius = 8.0
        
        return button
    }

}
