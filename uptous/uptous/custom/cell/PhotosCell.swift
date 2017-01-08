//
//  PhotosCell.swift
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


protocol PhotosCellDelegate {
    func photoReplyTo(_: NSInteger)
    func photoComment(_: NSInteger)
    func readMore(_: NSInteger)
    func photoComment1(_: NSInteger)
    func openAlbumPage(_: NSInteger)
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
    @IBOutlet weak var albumPageBtn: UIButton!
    @IBOutlet weak var comment1Btn: UIButton!
    @IBOutlet weak var replyToBtn: UIButton!
    @IBOutlet weak var readMoreBtn: UIButton!
    //@IBOutlet weak var identifierView: GroupIdentifierView!
    @IBOutlet weak var ownerView: UIView!
    @IBOutlet weak var ownerNameLbl: UILabel!

    
    var delegate: PhotosCellDelegate!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        contentsView.layer.borderColor = UIColor(red: CGFloat(0.8), green: CGFloat(0.8), blue: CGFloat(0.8), alpha: CGFloat(1)).cgColor
        contentsView.layer.borderWidth = CGFloat(1.0)
        contentsView.layer.cornerRadius = 8.0
        //commentLbl.hidden = true
        readMoreBtn.isHidden = true
        Custom.fullCornerView(ownerView)
    }
    
    //Mark : Get Label Height with text
    func heightForView(_ text:String, font:UIFont, width:CGFloat) -> CGFloat{
        let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = text
        
        label.sizeToFit()
        return label.frame.height
    }
    
    @IBAction func replyTo(_ sender: UIButton) {
        delegate.photoReplyTo(sender.tag)
    }
    
    @IBAction func comment(_ sender: UIButton) {
        delegate.photoComment(sender.tag)
    }
    
    @IBAction func readMore(_ sender: UIButton) {
        delegate.readMore(sender.tag)
    }
    
    @IBAction func comment1(_ sender: UIButton) {
        delegate.photoComment1(sender.tag)
    }
    
    @IBAction func openAlbumPage(_ sender: UIButton) {
        delegate.openAlbumPage(sender.tag)
    }
    
    func attributedString(_ str: String) -> NSAttributedString? {
        let attributes = [
            NSForegroundColorAttributeName : UIColor.white,
            NSUnderlineStyleAttributeName : NSUnderlineStyle.styleSingle.rawValue
            ] as [String : Any]
        let attributedString = NSAttributedString(string: str, attributes: attributes)
        return attributedString
    }
    
    func updateData(_ data: Feed) {
        
        /*if data.ownerPhotoUrl == "https://dsnn35vlkp0h4.cloudfront.net/images/blank_image.gif" {
            identifierView.isHidden = false
            ownerPhotoImgView.isHidden = true
            let stringArray = data.ownerName?.components(separatedBy: " ")
            let firstName = stringArray![0]
            let secondName = stringArray![1]
            
            let resultString = "\(firstName.characters.first!)\(secondName.characters.first!)"
            
            identifierView.abbrLabel.text = resultString
            let color1 = Utility.hexStringToUIColor(hex: data.ownerBackgroundColor!)
            let color2 = Utility.hexStringToUIColor(hex: data.ownerTextColor!)
            identifierView.abbrLabel.textColor = color2
            identifierView.backgroundLayerColor = color1
            
        }else {
            identifierView.isHidden = true
            ownerPhotoImgView.isHidden = false
            if let avatarUrl = data.ownerPhotoUrl {
                ownerPhotoImgView.setUserAvatar(avatarUrl)
            }
        }*/
        
        if data.ownerPhotoUrl == "https://dsnn35vlkp0h4.cloudfront.net/images/blank_image.gif" {
            ownerView.isHidden = false
            ownerPhotoImgView.isHidden = true
            let stringArray = data.ownerName?.components(separatedBy: " ")
            let firstName = stringArray![0]
            let secondName = stringArray![1]
            let resultString = "\(firstName.characters.first!)\(secondName.characters.first!)"
            
            ownerNameLbl.text = resultString
            let color1 = Utility.hexStringToUIColor(hex: data.ownerBackgroundColor!)
            let color2 = Utility.hexStringToUIColor(hex: data.ownerTextColor!)
            ownerView.backgroundColor = color1
            ownerNameLbl.textColor = color2
            
            
        }else {
            ownerView.isHidden = true
            ownerPhotoImgView.isHidden = false
            if let avatarUrl = data.ownerPhotoUrl {
                ownerPhotoImgView.setUserAvatar(avatarUrl)
            }
        }
        
        let attributedStr = NSMutableAttributedString()
        if data.communityName != nil {
            let attributedString1 = NSAttributedString(string: ("\(data.ownerName!) in: "), attributes: nil)
            attributedStr.append(attributedString1)
            attributedStr.append(attributedString("\(data.communityName!)")!)
        }else{
            
            let attributedString1 = NSAttributedString(string: ("\(data.ownerName!)"), attributes: nil)
            attributedStr.append(attributedString1)
        }
        groupNameLbl.attributedText = attributedStr
        
        let replyName = data.ownerName?.components(separatedBy: " ")[0]
        replyToBtn.setTitle(("Reply to" + " " + replyName!), for: UIControlState())
        
        if let newsItemPhotoUrl = data.newsItemPhoto {
            //CustomImgView.setUserAvatar(newsItemPhotoUrl,imgView: newsItemPhotoImgView)
            
            let block: SDWebImageCompletionBlock = {(image: UIImage?, error: Error?, cacheType: SDImageCacheType!, imageURL: URL?) -> Void in
                self.newsItemPhotoImgView.image = image
                //self.newsItemPhotoImgView.image = self.cropToBounds(image: image!,width:Double(self.contentsView.frame.size.width),height:195)
            }
            self.newsItemPhotoImgView.sd_setImage(with: URL(string:newsItemPhotoUrl) as URL!, completed:block)
            
            
        }
        
        if data.newsItemDescription != "" {
            let textHeight =  heightForView(data.newsItemDescription!, font: UIFont(name: "Helvetica Neue Regular", size: 16)!, width: self.frame.size.width - 20)
            
            if textHeight > 70 {
                readMoreBtn.isHidden = false
            }else {
                readMoreBtn.isHidden = true
            }
        }
        
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
        
        newsItemNameLbl.text = data.newsItemName
        // newsItemDescriptionLbl.text = data.newsItemDescription!
        dateLbl.text = ("\(Custom.dayStringFromTime(data.createDate!))")
    }
    
    //MARK: - Crop Photo
    func cropToBounds(image: UIImage, width: Double, height: Double) -> UIImage {
        
        let contextImage: UIImage = UIImage(cgImage: image.cgImage!)
        
        let contextSize: CGSize = contextImage.size
        
        var posX: CGFloat = 0.0
        var posY: CGFloat = 0.0
        var cgwidth: CGFloat = CGFloat(width)
        var cgheight: CGFloat = CGFloat(height)
        
        // See what size is longer and create the center off of that
        if contextSize.width > contextSize.height {
            posX = ((contextSize.width - contextSize.height) / 2)
            posY = 0
            cgwidth = contextSize.height
            cgheight = contextSize.height
        } else {
            posX = 0
            posY = ((contextSize.height - contextSize.width) / 2)
            cgwidth = contextSize.width
            cgheight = contextSize.width
        }
        
        let rect: CGRect = CGRect(x: posX, y: posY, width: cgwidth, height: cgheight)//CGRectMake(posX, posY, cgwidth, cgheight)
        
        // Create bitmap image from context using the rect
        let imageRef: CGImage = contextImage.cgImage!.cropping(to: rect)!
        
        // Create a new image based on the imageRef and rotate back to the original orientation
        let image: UIImage = UIImage(cgImage: imageRef, scale: image.scale, orientation: image.imageOrientation)
        
        return image
    }
    
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}


