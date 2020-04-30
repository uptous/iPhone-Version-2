//
//  AnnouncementCell.swift
//  uptous
//
//  Created by Roshan Gita  on 8/13/16.
//  Copyright © 2016 UpToUs. All rights reserved.
//

import UIKit
//import SwiftString
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


protocol AnnouncementCellDelegate {
    func announcementReplyTo(_: NSInteger)
    func announcementReplyAll(_: NSInteger)
    func announcementPost(_: NSInteger)
}

class AnnouncementCell: UITableViewCell {

    @IBOutlet weak var contentsView: UIView!
    @IBOutlet weak var groupNameLbl: UILabel!
    @IBOutlet weak var ownerPhotoImgView: UIImageView!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var newsItemDescriptionLbl: UILabel!
    @IBOutlet weak var newsItemNameLbl: UILabel!
    @IBOutlet weak var commentLbl: UILabel!
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var replyAllBtn: UIButton!
    @IBOutlet weak var postBtn: UIButton!
    @IBOutlet weak var replyToBtn: UIButton!
    @IBOutlet weak var ownerView: UIView!
    @IBOutlet weak var ownerNameLbl: UILabel!
    
    var delegate: AnnouncementCellDelegate!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //Custom.fullCornerView(ownerView)

        contentsView.layer.borderColor = UIColor(red: CGFloat(0.8), green: CGFloat(0.8), blue: CGFloat(0.8), alpha: CGFloat(1)).cgColor
        contentsView.layer.borderWidth = CGFloat(1.0)
        contentsView.layer.cornerRadius = 8.0
        //commentLbl.hidden = true
        _ = Custom.fullCornerView(ownerView)
        ownerPhotoImgView.layer.cornerRadius = 25.0
        ownerPhotoImgView.layer.masksToBounds = true
    }
    
    @IBAction func replyTo(_ sender: UIButton) {
        delegate.announcementReplyTo(sender.tag)
    }
    
    @IBAction func replyAll(_ sender: UIButton) {
        delegate.announcementReplyAll(sender.tag)
    }
    
    @IBAction func postClick(_ sender: UIButton) {
        delegate.announcementPost(sender.tag)
    }

    func attributedString(_ str: String) -> NSAttributedString? {
        let attributes = [
            convertFromNSAttributedStringKey(NSAttributedString.Key.foregroundColor) : UIColor.black,
            convertFromNSAttributedStringKey(NSAttributedString.Key.underlineStyle) : NSUnderlineStyle.single.rawValue
        ] as [String : Any]
        let attributedString = NSAttributedString(string: str, attributes: convertToOptionalNSAttributedStringKeyDictionary(attributes))
        return attributedString
    }
    
    func updateData(_ data: Feed) {
        
        if data.ownerPhotoUrl == "https://dsnn35vlkp0h4.cloudfront.net/images/blank_image.gif" {
            ownerView.isHidden = false
            ownerPhotoImgView.isHidden = true
            let stringArray = data.ownerName?.components(separatedBy: " ")
            let firstName = stringArray![0]
            let secondName = stringArray![1]
            //let resultString: String
            //let resultString = "\(firstName.characters.first!)\(secondName.characters.first!)"
            if firstName != "" && secondName != "" {
                ownerNameLbl.text = "\(firstName.prefix(1))\(secondName.prefix(1))"
            }else if firstName != "" {
                  ownerNameLbl.text = "\(firstName.prefix(1))"
            }else if secondName != "" {
                  ownerNameLbl.text = "\(secondName.prefix(1))"
            }
           
            //ownerNameLbl.text = resultString
            let color1 = Utility.hexStringToUIColor(hex: data.ownerBackgroundColor!)
            let color2 = Utility.hexStringToUIColor(hex: data.ownerTextColor!)
            ownerView.backgroundColor = color1
            ownerNameLbl.textColor = color2
            
        }else {
            ownerView.isHidden = true
            ownerPhotoImgView.isHidden = false
            if let avatarUrl = data.ownerPhotoUrl {
                ownerPhotoImgView.isHidden = false
                //ownerPhotoImgView.setUserAvatar(avatarUrl)
                let block: SDWebImageCompletionBlock = {(image: UIImage?, error: Error?, cacheType: SDImageCacheType!, imageURL: URL?) -> Void in
                    self.ownerPhotoImgView.image = image
                }
                //ownerPhotoImgView.sd_setImage(with: URL(string:avatarUrl) as URL!, completed:block)
                let url = URL(string: avatarUrl)
                ownerPhotoImgView.sd_setImage(with: url, completed: block)
            }
        }


        let replyName = data.ownerName?.components(separatedBy: " ")[0]
        replyToBtn.setTitle(("Reply to" + " " + replyName!), for: UIControl.State())
        
        let attributedStr = NSMutableAttributedString()
        if data.communityName != "" {
            let attributedString1 = NSAttributedString(string: ("\(data.ownerName!) in: "), attributes: nil)
            attributedStr.append(attributedString1)
            attributedStr.append(attributedString("\(data.communityName!)")!)
        }else{
            
            let attributedString1 = NSAttributedString(string: ("\(data.ownerName!)"), attributes: nil)
            attributedStr.append(attributedString1)
        }
        groupNameLbl.attributedText = attributedStr
        
        newsItemNameLbl.text = data.newsItemName
        //newsItemDescriptionLbl.text = data.newsItemDescription!.decodeHTML()
        
        
        DispatchQueue.main.async(execute: {
            let font = UIFont.init(name: "Helvetica Neue", size: 14.0)
            self.webView.loadHTMLString("<span style=\"font-family: \(font!.fontName); font-size: \(font!.pointSize); \">\(data.newsItemDescription!)</span>", baseURL: nil)

            //self.webView.loadHTMLString(data.newsItemDescription!,baseURL: nil)
        })
        
        if data.comments?.count > 0 {
            postBtn.isHidden = false
            if data.comments?.count == 1 {
                let text = ("\((data.comments?.count)!) post")
                postBtn.setTitle(text, for: UIControl.State())
            }else {
                let text = ("\((data.comments?.count)!) posts")
                postBtn.setTitle(text, for: UIControl.State())
            }
            
        }else{
            postBtn.isHidden = true
        }
        dateLbl.text = ("\(Custom.dayStringFromTime(data.modifiedDate!))")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromNSAttributedStringKey(_ input: NSAttributedString.Key) -> String {
	return input.rawValue
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToOptionalNSAttributedStringKeyDictionary(_ input: [String: Any]?) -> [NSAttributedString.Key: Any]? {
	guard let input = input else { return nil }
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (NSAttributedString.Key(rawValue: key), value)})
}
