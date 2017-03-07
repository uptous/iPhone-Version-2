//
//  PersonalAnnouncementCell.swift
//  uptous
//
//  Created by Roshan Gita  on 8/17/16.
//  Copyright © 2016 SPA. All rights reserved.
//

import UIKit
//import SwiftString


class PersonalAnnouncementCell: UITableViewCell {

    @IBOutlet weak var contentsView: UIView!
    @IBOutlet weak var groupNameLbl: UILabel!
    @IBOutlet weak var ownerPhotoImgView: UIImageView!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var newsItemDescriptionLbl: UILabel!
    @IBOutlet weak var newsItemNameLbl: UILabel!
    @IBOutlet weak var commentLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        contentsView.layer.borderColor = UIColor(red: CGFloat(0.8), green: CGFloat(0.8), blue: CGFloat(0.8), alpha: CGFloat(1)).cgColor
        contentsView.layer.borderWidth = CGFloat(1.0)
        contentsView.layer.cornerRadius = 8.0
        
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
        
        let attributedString1 = NSAttributedString(string: ("\(data.ownerName!)"), attributes: nil)
        
        let attributedStr = NSMutableAttributedString()
        attributedStr.append(attributedString1)
        if data.communityName != nil {
            attributedStr.append(attributedString("in:\(data.communityName!)")!)
        }
        
        groupNameLbl.attributedText = attributedStr
        if let avatarUrl = data.ownerPhotoUrl {
            let block: SDWebImageCompletionBlock = {(image: UIImage?, error: Error?, cacheType: SDImageCacheType!, imageURL: URL?) -> Void in
                self.ownerPhotoImgView.image = image
            }
            ownerPhotoImgView.sd_setImage(with: URL(string:avatarUrl) as URL!, completed:block)
            
        }else {
            ownerPhotoImgView.image = nil
            let color1 = Utility.hexStringToUIColor(hex: data.ownerBackgroundColor!)
            ownerPhotoImgView.backgroundColor = color1
        }
        newsItemNameLbl.text = data.newsItemName
        newsItemDescriptionLbl.text = data.newsItemDescription!
        //groupNameLbl.text = data.ownerName! + " in: " + data.communityName!
        if data.comments?.count == 1 {
            let text = ("\((data.comments?.count)!) comment")
            commentLbl.text = text
        }else {
            let text = ("\((data.comments?.count)!) comments")
            commentLbl.text = text
        }
        
    }


    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
