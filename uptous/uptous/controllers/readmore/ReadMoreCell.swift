//
//  ReadMoreCell.swift
//  uptous
//
//  Created by Roshan Gita  on 8/28/16.
//  Copyright © 2016 SPA. All rights reserved.
//

import UIKit

class ReadMoreCell: UITableViewCell {
    
    @IBOutlet weak var ownerPhotoImgView: CircularImageView!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var commentDescriptionLbl: UILabel!
    @IBOutlet weak var commentPersonNameLbl: UILabel!
    @IBOutlet weak var ownerView: UIView!
    @IBOutlet weak var ownerNameLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        Custom.fullCornerView(ownerView)
        
    }
    
    func updateData(data: Comment) {
        
        if data.ownerPhotoUrl == "https://dsnn35vlkp0h4.cloudfront.net/images/blank_image.gif" {
            ownerView.hidden = false
            ownerPhotoImgView.hidden = true
            let stringArray = data.ownerName?.componentsSeparatedByString(" ")
            let firstName = stringArray![0]
            let secondName = stringArray![1]
            let resultString = "\(firstName.characters.first!)\(secondName.characters.first!)"
            
            ownerNameLbl.text = resultString
            let color1 = Utility.hexStringToUIColor(data.ownerBackgroundColor!)
            let color2 = Utility.hexStringToUIColor(data.ownerTextColor!)
            ownerView.backgroundColor = color1
            ownerNameLbl.textColor = color2
            
            
        }else {
            ownerView.hidden = true
            ownerPhotoImgView.hidden = false
            if let avatarUrl = data.ownerPhotoUrl {
                ownerPhotoImgView.setUserAvatar(avatarUrl)
            }
        }

        commentPersonNameLbl.text = data.ownerName
        commentDescriptionLbl.text = data.body!.decodeHTML()
        //groupNameLbl.text = data.ownerName! + " in: " + data.communityName!
        //commentLbl.text = ("\((data.comments?.count)!) comments")
        dateLbl.text = ("\(Custom.dayStringFromTime(data.createDate!))")
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
