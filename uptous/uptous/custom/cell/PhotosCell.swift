//
//  PhotosCell.swift
//  uptous
//
//  Created by Roshan Gita  on 8/12/16.
//  Copyright © 2016 SPA. All rights reserved.
//

import UIKit
import SwiftString

protocol PhotosCellDelegate {
    func photoReplyTo(_: NSInteger)
    func photoComment(_: NSInteger)
    func readMore(_: NSInteger)
    func photoComment1(_: NSInteger)
}

class PhotosCell: UITableViewCell {
    
    @IBOutlet weak var contentsView: UIView!
    @IBOutlet weak var groupNameLbl: UILabel!
    @IBOutlet weak var ownerPhotoImgView: CircularImageView!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var newsItemDescriptionLbl: UILabel!
    @IBOutlet weak var newsItemNameLbl: UILabel!
    @IBOutlet weak var newsItemPhotoImgView: UIImageView!
    @IBOutlet weak var commentLbl: UILabel!
    @IBOutlet weak var commentBtn: UIButton!
    @IBOutlet weak var comment1Btn: UIButton!
    @IBOutlet weak var replyToBtn: UIButton!
    @IBOutlet weak var readMoreBtn: UIButton!
    @IBOutlet weak var identifierView: GroupIdentifierView!
    
    var delegate: PhotosCellDelegate!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        contentsView.layer.borderColor = UIColor(red: CGFloat(0.8), green: CGFloat(0.8), blue: CGFloat(0.8), alpha: CGFloat(1)).CGColor
        contentsView.layer.borderWidth = CGFloat(1.0)
        contentsView.layer.cornerRadius = 8.0
        //commentLbl.hidden = true
        readMoreBtn.hidden = true
    }
    
    //Mark : Get Label Height with text
    func heightForView(text:String, font:UIFont, width:CGFloat) -> CGFloat{
        let label:UILabel = UILabel(frame: CGRectMake(0, 0, width, CGFloat.max))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.ByWordWrapping
        label.font = font
        label.text = text
        
        label.sizeToFit()
        return label.frame.height
    }
    
    @IBAction func replyTo(sender: UIButton) {
        delegate.photoReplyTo(sender.tag)
    }
    
    @IBAction func comment(sender: UIButton) {
        delegate.photoComment(sender.tag)
    }
    
    @IBAction func readMore(sender: UIButton) {
        delegate.readMore(sender.tag)
    }
    
    @IBAction func comment1(sender: UIButton) {
        delegate.photoComment1(sender.tag)
    }

    func attributedString(str: String) -> NSAttributedString? {
        let attributes = [
            NSForegroundColorAttributeName : UIColor.whiteColor(),
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
            let color2 = Utility.hexStringToUIColor(data.ownerTextColor!)
            identifierView.abbrLabel.textColor = color2
            identifierView.backgroundLayerColor = color1
            
        }else {
            identifierView.hidden = true
            ownerPhotoImgView.hidden = false
            if let avatarUrl = data.ownerPhotoUrl {
                ownerPhotoImgView.setUserAvatar(avatarUrl)
            }
        }
        
        let attributedStr = NSMutableAttributedString()
        if data.communityName != nil {
            let attributedString1 = NSAttributedString(string: ("\(data.ownerName!) in: "), attributes: nil)
            attributedStr.appendAttributedString(attributedString1)
            attributedStr.appendAttributedString(attributedString(" \(data.communityName!)")!)
        }else{
            
            let attributedString1 = NSAttributedString(string: ("\(data.ownerName!)"), attributes: nil)
            attributedStr.appendAttributedString(attributedString1)
        }
        groupNameLbl.attributedText = attributedStr
        
        let replyName = data.ownerName?.componentsSeparatedByString(" ")[0]
        replyToBtn.setTitle(("Reply to" + " " + replyName!), forState: .Normal)
        
        if let newsItemPhotoUrl = data.newsItemPhoto {
            CustomImgView.setUserAvatar(newsItemPhotoUrl,imgView: newsItemPhotoImgView)
        }
        
        if data.newsItemDescription != "" {
            let textHeight =  heightForView(data.newsItemDescription!, font: UIFont(name: "Helvetica Neue Regular", size: 16)!, width: self.frame.size.width - 20)
            
            if textHeight > 70 {
                readMoreBtn.hidden = false
            }else {
                readMoreBtn.hidden = true
            }
        }
        
        if data.comments?.count > 0 {
            comment1Btn.hidden = false
            let text = ("\((data.comments?.count)!) comments")
            comment1Btn.setTitle(text, forState: UIControlState.Normal)
        }else{
            comment1Btn.hidden = true
        }
        
        newsItemNameLbl.text = data.newsItemName
        newsItemDescriptionLbl.text = data.newsItemDescription!.decodeHTML()
        dateLbl.text = ("\(Custom.dayStringFromTime(data.createDate!))")
    }


    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}


