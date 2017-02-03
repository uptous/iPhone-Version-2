//
//  LandingCell.swift
//  uptous
//
//  Created by Roshan Gita  on 10/23/16.
//  Copyright © 2016 SPA. All rights reserved.
//

import UIKit

protocol LandingCellDelegate {
    func expandClick(_: NSInteger)
}

class LandingCell: UITableViewCell {
    
    @IBOutlet weak var ownerPhotoImgView: CircularImageView!
    @IBOutlet weak var ownerView: UIView!
    @IBOutlet weak var ownerNameLbl: UILabel!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var teamLbl: UILabel!
    @IBOutlet weak var expandBtn: UIButton!
    var delegate: LandingCellDelegate!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        Custom.fullCornerView(ownerView)
    }
    
    func updateView(_ data: Contacts) {
        ownerView.isHidden = false
        ownerNameLbl.isHidden = false
        ownerPhotoImgView.isHidden = true
        
        if data.firstName != nil &&  data.lastName != nil {
            nameLbl.text = ("\(data.firstName!)") + (" \(data.lastName!)")
            
            if data.firstName != "" && data.lastName != "" {
                let firstName = data.firstName!.capitalized.characters.first
                let secondName = data.lastName!.capitalized.characters.first
                let resultString = ("\(firstName!)") + ("\(secondName!)")
                ownerNameLbl.text = resultString
            }
            
            
        }
        
        if data.photo == "https://dsnn35vlkp0h4.cloudfront.net/images/blank_image.gif" {
            let color1 = Utility.hexStringToUIColor(hex: data.memberBackgroundColor!)
            let color2 = Utility.hexStringToUIColor(hex: data.memberTextColor!)
            ownerView.backgroundColor = color1
            ownerNameLbl.textColor = color2
            
        }else {
            ownerView.isHidden = true
            ownerPhotoImgView.isHidden = false
            if let avatarUrl = data.photo {
                ownerPhotoImgView.setUserAvatar(avatarUrl)
            }
        }
        teamLbl.text = ""
        var childrens = [String]()
        
        if data.children != nil {
            for i in 0..<(data.children?.count)! {
                let dic = data.children?.object(at: i) as! NSDictionary
                childrens.append("\((dic.object(forKey: "firstName"))!)")
            }
            let stringRepresentation1 = childrens.joined(separator: ", ")
            teamLbl.text = "\(stringRepresentation1)"
            
        }
        
        
       /* //if data.photo == "https://dsnn35vlkp0h4.cloudfront.net/images/blank_image.gif" {
            ownerView.isHidden = false
            ownerNameLbl.isHidden = false
            ownerPhotoImgView.isHidden = true
            
            let firstName = data.firstName!.capitalized.characters.first
            let secondName = data.lastName!.capitalized.characters.first
            let resultString = ("\(firstName!)") + ("\(secondName!)")
            
            ownerNameLbl.text = resultString
            let color1 = Utility.hexStringToUIColor(hex: data.memberBackgroundColor!)
            let color2 = Utility.hexStringToUIColor(hex: data.memberTextColor!)
            ownerView.backgroundColor = color1
            ownerNameLbl.textColor = color2
            
            
        }else {
            ownerView.isHidden = true
            ownerPhotoImgView.isHidden = false
            if let avatarUrl = data.photo {
                ownerPhotoImgView.setUserAvatar(avatarUrl)
            }
        }*/
        
    }

    
    @IBAction func expand(sender: UIButton) {
        delegate.expandClick(sender.tag)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
