//
//  PrivateThreadsCell.swift
//  uptous
//
//  Created by Roshan Gita  on 8/12/16.
//  Copyright © 2016 SPA. All rights reserved.
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


protocol PrivateThreadsCellDelegate {
    func privateThreadReplyTo(_: NSInteger)
    func privateThreadReplyAll(_: NSInteger)
    func privateThreadComment(_: NSInteger)
}


class PrivateThreadsCell: UITableViewCell {

    @IBOutlet weak var contentsView: UIView!
    @IBOutlet weak var groupNameLbl: UILabel!
    @IBOutlet weak var ownerPhotoImgView: UIImageView!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var newsItemDescriptionLbl: UILabel!
    @IBOutlet weak var newsItemNameLbl: UILabel!
    @IBOutlet weak var commentLbl: UILabel!
    @IBOutlet weak var replyToBtn: UIButton!
    @IBOutlet weak var replyAllBtn: UIButton!
    @IBOutlet weak var commentBtn: UIButton!
    @IBOutlet weak var webView: UIWebView!
    var delegate: PrivateThreadsCellDelegate!
    @IBOutlet weak var identifierView: GroupIdentifierView!
    @IBOutlet weak var ownerView: UIView!
    @IBOutlet weak var ownerNameLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        Custom.fullCornerView(ownerView)
        contentsView.layer.borderColor = UIColor(red: CGFloat(0.8), green: CGFloat(0.8), blue: CGFloat(0.8), alpha: CGFloat(1)).cgColor
        contentsView.layer.borderWidth = CGFloat(1.0)
        contentsView.layer.cornerRadius = 8.0
        ownerPhotoImgView.layer.cornerRadius = 30.0
        ownerPhotoImgView.layer.masksToBounds = true
    }
    
    @IBAction func replyTo(_ sender: UIButton) {
        delegate.privateThreadReplyTo(sender.tag)
    }
    
    @IBAction func replyALL(_ sender: UIButton) {
        delegate.privateThreadReplyAll(sender.tag)
    }
    
    @IBAction func comment(_ sender: UIButton) {
        delegate.privateThreadComment(sender.tag)
    }

    
    func attributedString(_ str: String) -> NSAttributedString? {
        let attributes = [
            NSForegroundColorAttributeName : UIColor.black,
            NSUnderlineStyleAttributeName : NSUnderlineStyle.styleSingle.rawValue
        ] as [String : Any]
        let attributedString = NSAttributedString(string: str, attributes: attributes)
        return attributedString
    }
    
    func updateData(_ data: Feed) {
        if data.ownerPhotoUrl == "https://dsnn35vlkp0h4.cloudfront.net/images/blank_image.gif" {
            ownerView.isHidden = false
            ownerPhotoImgView.isHidden = true
            let stringArray = data.ownerName?.components(separatedBy: " ")
            var firstName = stringArray![0]
            var secondName = stringArray![1]
            //let resultString: String
            //let resultString = "\(firstName.characters.first!)\(secondName.characters.first!)"
            if firstName != "" && secondName != "" {
                ownerNameLbl.text = "\(firstName.characters.first!)\(secondName.characters.first!)"
            }else if firstName != "" {
                ownerNameLbl.text = "\(firstName.characters.first!)"
            }else if secondName != "" {
                ownerNameLbl.text = "\(secondName.characters.first!)"
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
                ownerPhotoImgView.sd_setImage(with: URL(string:avatarUrl) as URL!, completed:block)
            }
        }

        let attributedStr = NSMutableAttributedString()
        if data.communityName != ""  {
            let attributedString1 = NSAttributedString(string: ("\(data.ownerName!) in: "), attributes: nil)
            attributedStr.append(attributedString1)
            attributedStr.append(attributedString(" \(data.communityName!)")!)
        }else{
            
            let attributedString1 = NSAttributedString(string: ("\(data.ownerName!)"), attributes: nil)
            attributedStr.append(attributedString1)
        }
        groupNameLbl.attributedText = attributedStr
        let replyName = data.ownerName?.components(separatedBy: " ")[0]
        replyToBtn.setTitle(("Reply to" + " " + replyName!), for: UIControlState())
        
        newsItemNameLbl.text = data.newsItemName
        DispatchQueue.main.async(execute: {
            self.webView.loadHTMLString(data.newsItemDescription!,baseURL: nil)
        })
        //webView.loadHTMLString(data.newsItemDescription!,baseURL: nil)
        
        //newsItemDescriptionLbl.text = data.newsItemDescription!.decodeHTML()
        //groupNameLbl.text = data.ownerName! + " in: " + data.communityName!
        dateLbl.text = ("\(Custom.dayStringFromTime(data.createDate!))")
        if data.comments?.count > 0 {
            commentBtn.isHidden = false
            if data.comments?.count == 1 {
                let text = ("\((data.comments?.count)!) comment")
                commentBtn.setTitle(text, for: UIControlState())
            }else {
                let text = ("\((data.comments?.count)!) comments")
                commentBtn.setTitle(text, for: UIControlState())
            }
        }else{
            commentBtn.isHidden = true
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
