//
//  AnnouncementCell.swift
//  uptous
//
//  Created by Roshan Gita  on 8/13/16.
//  Copyright © 2016 SPA. All rights reserved.
//

import UIKit
import SwiftString

protocol AnnouncementCellDelegate {
    func announcementReplyTo(_: NSInteger)
    func announcementReplyAll(_: NSInteger)
    func announcementPost(_: NSInteger)
}

class AnnouncementCell: UITableViewCell {

    @IBOutlet weak var contentsView: UIView!
    @IBOutlet weak var groupNameLbl: UILabel!
    @IBOutlet weak var ownerPhotoImgView: CircularImageView!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var newsItemDescriptionLbl: UILabel!
    @IBOutlet weak var newsItemNameLbl: UILabel!
    @IBOutlet weak var commentLbl: UILabel!
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var replyAllBtn: UIButton!
    @IBOutlet weak var postBtn: UIButton!
    @IBOutlet weak var replyToBtn: UIButton!
    @IBOutlet weak var identifierView: GroupIdentifierView!
    
    var delegate: AnnouncementCellDelegate!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        contentsView.layer.borderColor = UIColor(red: CGFloat(0.8), green: CGFloat(0.8), blue: CGFloat(0.8), alpha: CGFloat(1)).CGColor
        contentsView.layer.borderWidth = CGFloat(1.0)
        contentsView.layer.cornerRadius = 8.0
        //commentLbl.hidden = true
    }
    
    @IBAction func replyTo(sender: UIButton) {
        delegate.announcementReplyTo(sender.tag)
    }
    
    @IBAction func replyAll(sender: UIButton) {
        delegate.announcementReplyAll(sender.tag)
    }
    
    @IBAction func postClick(sender: UIButton) {
        delegate.announcementPost(sender.tag)
    }

    func attributedString(str: String) -> NSAttributedString? {
        let attributes = [
            NSForegroundColorAttributeName : UIColor.blackColor(),
            NSUnderlineStyleAttributeName : NSUnderlineStyle.StyleSingle.rawValue
        ]
        let attributedString = NSAttributedString(string: str, attributes: attributes)
        return attributedString
    }
    
    func updateData(data: Feed) {
        
        if data.ownerPhotoUrl == "https://dsnn35vlkp0h4.cloudfront.net/images/blank_image.gif" {
            identifierView.hidden = false
            ownerPhotoImgView.hidden = true
            let stringArray = data.ownerName?.componentsSeparatedByString(" ")
            let firstName = stringArray![0]
            let secondName = stringArray![1]
            
            let resultString = "\(firstName.characters.first!)\(secondName.characters.first!)"
            
            identifierView.abbrLabel.text = resultString
            let color1 = Utility.hexStringToUIColor(data.ownerBackgroundColor!)
            identifierView.backgroundLayerColor = color1
            let color2 = Utility.hexStringToUIColor(data.ownerTextColor!)
            identifierView.abbrLabel.textColor = color2

        }else {
            identifierView.hidden = true
            ownerPhotoImgView.hidden = false
            if let avatarUrl = data.ownerPhotoUrl {
                ownerPhotoImgView.setUserAvatar(avatarUrl)
            }
        }

        let replyName = data.ownerName?.componentsSeparatedByString(" ")[0]
        replyToBtn.setTitle(("Reply to" + " " + replyName!), forState: .Normal)
        
        let attributedStr = NSMutableAttributedString()
        if data.communityName != "" {
            let attributedString1 = NSAttributedString(string: ("\(data.ownerName!) in: "), attributes: nil)
            attributedStr.appendAttributedString(attributedString1)
            attributedStr.appendAttributedString(attributedString(" \(data.communityName!)")!)
        }else{
            
            let attributedString1 = NSAttributedString(string: ("\(data.ownerName!)"), attributes: nil)
            attributedStr.appendAttributedString(attributedString1)
        }
        groupNameLbl.attributedText = attributedStr
        
        newsItemNameLbl.text = data.newsItemName
        //newsItemDescriptionLbl.text = data.newsItemDescription!.decodeHTML()
        webView.loadHTMLString(data.newsItemDescription!,baseURL: nil)
        
        if data.comments?.count > 0 {
            postBtn.hidden = false
            let text = ("\((data.comments?.count)!) posts")
            postBtn.setTitle(text, forState: UIControlState.Normal)
        }else{
            postBtn.hidden = true
        }
        dateLbl.text = ("\(Custom.dayStringFromTime(data.createDate!))")
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
