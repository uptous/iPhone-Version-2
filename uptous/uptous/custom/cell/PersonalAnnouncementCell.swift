//
//  PersonalAnnouncementCell.swift
//  uptous
//
//  Created by Roshan Gita  on 8/17/16.
//  Copyright © 2016 SPA. All rights reserved.
//

import UIKit
import SwiftString


class PersonalAnnouncementCell: UITableViewCell {

    @IBOutlet weak var contentsView: UIView!
    @IBOutlet weak var groupNameLbl: UILabel!
    @IBOutlet weak var ownerPhotoImgView: CircularImageView!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var newsItemDescriptionLbl: UILabel!
    @IBOutlet weak var newsItemNameLbl: UILabel!
    @IBOutlet weak var commentLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        contentsView.layer.borderColor = UIColor(red: CGFloat(0.8), green: CGFloat(0.8), blue: CGFloat(0.8), alpha: CGFloat(1)).CGColor
        contentsView.layer.borderWidth = CGFloat(1.0)
        contentsView.layer.cornerRadius = 8.0
        
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
        
        let attributedString1 = NSAttributedString(string: ("\(data.ownerName!)"), attributes: nil)
        
        let attributedStr = NSMutableAttributedString()
        attributedStr.appendAttributedString(attributedString1)
        if data.communityName != nil {
            attributedStr.appendAttributedString(attributedString("in: \(data.communityName!)")!)
        }
        
        groupNameLbl.attributedText = attributedStr
        if let avatarUrl = data.ownerPhotoUrl {
            ownerPhotoImgView.setUserAvatar(avatarUrl)
            
        }else {
            ownerPhotoImgView.image = nil
            let color1 = Utility.hexStringToUIColor(data.ownerBackgroundColor!)
            ownerPhotoImgView.backgroundColor = color1
        }
        newsItemNameLbl.text = data.newsItemName
        newsItemDescriptionLbl.text = data.newsItemDescription!.decodeHTML()
        //groupNameLbl.text = data.ownerName! + " in: " + data.communityName!
        commentLbl.text = ("\((data.comments?.count)!) comments")
    }


    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
