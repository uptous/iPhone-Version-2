//
//  RSVPItemCell.swift
//  uptous
//
//  Created by Roshan Gita  on 10/2/16.
//  Copyright © 2016 SPA. All rights reserved.
//

import UIKit

class RSVPItemCell: UITableViewCell {

    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var commentDescriptionLbl: UILabel!
    @IBOutlet weak var ownerPhotoImgView: CircularImageView!
    @IBOutlet weak var identifierView: GroupIdentifierView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //Custom.cornerView(cellView)
    }
    
    func updateData(data: NSDictionary) {
        print(data)
        identifierView.hidden = true
        ownerPhotoImgView.hidden = false
        /*if data.ownerPhotoUrl == "https://dsnn35vlkp0h4.cloudfront.net/images/blank_image.gif" {
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
         }*/
        
        commentDescriptionLbl.text = data.objectForKey("comment") as? String ?? "No Comment"
        nameLbl.text = data.objectForKey("firstName") as? String
        let eventDate = data.objectForKey("dateTime") as? Double ?? 0
        dateLbl.text = Custom.dayStringFromTime1(eventDate)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
