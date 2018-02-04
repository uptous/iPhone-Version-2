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
    
    //@IBOutlet weak var ownerPhotoImgView: CircularImageView!
    @IBOutlet weak var ownerPhotoImgView: UIImageView!
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
        //ownerPhotoImgView
        ownerPhotoImgView.layer.cornerRadius = 25.0
        ownerPhotoImgView.layer.masksToBounds = true
        
        if data.firstName != "" && data.lastName != "" {
            nameLbl.text = ("\(data.lastName!),") + (" \(data.firstName!)")//("\(data.firstName!)") + (" \(data.lastName!)")
            
            let firstName = data.firstName!.capitalized.characters.first
            let secondName = data.lastName!.capitalized.characters.first
            let resultString = ("\(secondName!)") + ("\(firstName!)") //("\(firstName!)") + ("\(secondName!)")
            ownerNameLbl.text = resultString
            
        }else if data.firstName != "" {
            nameLbl.text = ("\(data.firstName!)")
            let firstName = data.firstName!.capitalized.characters.first
            let resultString = ("\(firstName!)")
            ownerNameLbl.text = resultString
            
        }else if data.lastName != "" {
            nameLbl.text = (" \(data.lastName!)")
            let secondName = data.lastName!.capitalized.characters.first
            let resultString = ("\(secondName!)")
            ownerNameLbl.text = resultString
        }else {
            nameLbl.text = "- -"
            ownerNameLbl.text = "- -"
        }
        print("\(data.firstName!)")
        print("\(data.photo!)")
        if data.photo == "" {
            let color1 = Utility.hexStringToUIColor(hex: data.memberBackgroundColor!)
            let color2 = Utility.hexStringToUIColor(hex: data.memberTextColor!)
            ownerView.backgroundColor = color1
            ownerNameLbl.textColor = color2
            
        }else if data.photo != "https://dsnn35vlkp0h4.cloudfront.net/images/blank_image.gif" {
            ownerView.isHidden = true
            if let avatarUrl = data.photo {
                ownerPhotoImgView.isHidden = false
                ownerPhotoImgView.setShowActivityIndicator(true)
                ownerPhotoImgView.setIndicatorStyle(.gray)
                //ownerPhotoImgView.setUserAvatar(avatarUrl)
                let block: SDWebImageCompletionBlock = {(image: UIImage?, error: Error?, cacheType: SDImageCacheType!, imageURL: URL?) -> Void in
                    self.ownerPhotoImgView.image = image
                    self.ownerPhotoImgView.setShowActivityIndicator(false)
                }
                ownerPhotoImgView.sd_setImage(with: URL(string:avatarUrl) as URL!, completed:block)
            }
        }else {
            let color1 = Utility.hexStringToUIColor(hex: data.memberBackgroundColor!)
            let color2 = Utility.hexStringToUIColor(hex: data.memberTextColor!)
            ownerView.backgroundColor = color1
            ownerNameLbl.textColor = color2
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
    }
    
    @IBAction func expand(sender: UIButton) {
        delegate.expandClick(sender.tag)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
