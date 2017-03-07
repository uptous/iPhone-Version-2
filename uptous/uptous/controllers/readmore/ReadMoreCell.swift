//
//  ReadMoreCell.swift
//  uptous
//
//  Created by Roshan Gita  on 8/28/16.
//  Copyright © 2016 SPA. All rights reserved.
//

import UIKit

class ReadMoreCell: UITableViewCell {
    
    @IBOutlet weak var ownerPhotoImgView: UIImageView!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var commentDescriptionLbl: UILabel!
    @IBOutlet weak var commentPersonNameLbl: UILabel!
    @IBOutlet weak var ownerView: UIView!
    @IBOutlet weak var ownerNameLbl: UILabel!
    @IBOutlet weak var webView: UIWebView!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        Custom.fullCornerView(ownerView)
        ownerPhotoImgView.layer.cornerRadius = 30.0
        ownerPhotoImgView.layer.masksToBounds = true
    }
    
    func updateData(_ data: Comment) {
        
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
                ownerPhotoImgView.isHidden = false
                //ownerPhotoImgView.setUserAvatar(avatarUrl)
                let block: SDWebImageCompletionBlock = {(image: UIImage?, error: Error?, cacheType: SDImageCacheType!, imageURL: URL?) -> Void in
                    self.ownerPhotoImgView.image = image
                }
                ownerPhotoImgView.sd_setImage(with: URL(string:avatarUrl) as URL!, completed:block)
            }
        }
        //webView.loadHTMLString(data.body!,baseURL: nil)
        let attrStr = try! NSAttributedString(
            data: (data.body!).data(using: String.Encoding.unicode, allowLossyConversion: true)!,
            options: [ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType],
            documentAttributes: nil)
        //commentDescriptionLbl.attributedText = attrStr
        commentDescriptionLbl.text = (data.body!).html2String
        commentPersonNameLbl.text = data.ownerName
        //commentDescriptionLbl.text = data.body!
        //groupNameLbl.text = data.ownerName! + " in: " + data.communityName!
        //commentLbl.text = ("\((data.comments?.count)!) comments")
        dateLbl.text = ("\(Custom.dayStringFromTime(data.createDate!))")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
