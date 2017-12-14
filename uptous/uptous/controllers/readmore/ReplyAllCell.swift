//
//  ReplyAllCell.swift
//  uptous
//
//  Created by Roshan Gita  on 9/25/16.
//  Copyright © 2016 SPA. All rights reserved.
//

import UIKit

class ReplyAllCell: UITableViewCell {

    @IBOutlet weak var ownerPhotoImgView: UIImageView!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var commentDescriptionLbl: UILabel!
    @IBOutlet weak var commentPersonNameLbl: UILabel!
    @IBOutlet weak var ownerView: UIView!
    @IBOutlet weak var ownerNameLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        Custom.fullCornerView(ownerView)
        ownerPhotoImgView.layer.cornerRadius = 25.0
        ownerPhotoImgView.layer.masksToBounds = true
    }
    
    func updateData(_ data: Comment) {
        
        if data.ownerPhotoUrl == "https://dsnn35vlkp0h4.cloudfront.net/images/blank_image.gif" {
            ownerView.isHidden = false
            ownerPhotoImgView.isHidden = true
            let stringArray = data.createdByUserName?.components(separatedBy: " ")
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

        commentPersonNameLbl.text = data.createdByUserName
        commentDescriptionLbl.text = data.body!
        dateLbl.text = ("\(Custom.dayStringFromTime(data.createTime!))")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
