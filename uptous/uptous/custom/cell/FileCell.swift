//
//  FileCell.swift
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


protocol FileCellDelegate {
    func fileReplyTo(_: NSInteger)
    func fileComment(_: NSInteger)
    func downloadPDF(_: NSInteger)
    func commentBtn(_: NSInteger)
}


class FileCell: UITableViewCell {

    @IBOutlet weak var contentsView: UIView!
    @IBOutlet weak var groupNameLbl: UILabel!
    @IBOutlet weak var ownerPhotoImgView: UIImageView!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var newsItemPDFLbl: UILabel!
    @IBOutlet weak var newsItemNameLbl: UILabel!
    @IBOutlet weak var commentLbl: UILabel!
    @IBOutlet weak var commentBtn: UIButton!
    @IBOutlet weak var comment1Btn: UIButton!
    @IBOutlet weak var replyToBtn: UIButton!
    @IBOutlet weak var pdfDownloadBtn: UIButton!
    @IBOutlet weak var ownerView: UIView!
    @IBOutlet weak var ownerNameLbl: UILabel!
    
    var delegate: FileCellDelegate!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        contentsView.layer.borderColor = UIColor(red: CGFloat(0.8), green: CGFloat(0.8), blue: CGFloat(0.8), alpha: CGFloat(1)).cgColor
        contentsView.layer.borderWidth = CGFloat(1.0)
        contentsView.layer.cornerRadius = 8.0
        Custom.fullCornerView(ownerView)
        ownerPhotoImgView.layer.cornerRadius = 25.0
        ownerPhotoImgView.layer.masksToBounds = true
    }
    
    @IBAction func replyTo(_ sender: UIButton) {
        delegate.fileReplyTo(sender.tag)
    }
    
    @IBAction func comment(_ sender: UIButton) {
        delegate.fileComment(sender.tag)
    }

    @IBAction func download(_ sender: UIButton){
        delegate.downloadPDF(sender.tag)
    }
    
    @IBAction func comment1(_ sender: UIButton){
        delegate.commentBtn(sender.tag)
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

        
        let replyName = data.ownerName?.components(separatedBy: " ")[0]
        replyToBtn.setTitle(("Reply to" + " " + replyName!), for: UIControlState())
        
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


        newsItemPDFLbl.text = data.newsItemName
        newsItemNameLbl.text = data.newsItemName
        //newsItemDescriptionLbl.text = data.newsItemDescription!.decodeHTML()
        //groupNameLbl.text = data.ownerName! + " in: " + data.communityName!
        if data.comments?.count > 0 {
            comment1Btn.isHidden = false
            if data.comments?.count == 1 {
                let text = ("\((data.comments?.count)!) comment")
                comment1Btn.setTitle(text, for: UIControlState())
            }else {
                let text = ("\((data.comments?.count)!) comments")
                comment1Btn.setTitle(text, for: UIControlState())
            }
        }else{
            comment1Btn.isHidden = true
        }
        
        dateLbl.text = ("\(Custom.dayStringFromTime(data.modifiedDate!))")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
