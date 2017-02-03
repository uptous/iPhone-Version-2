//
//  ExpandCell.swift
//  uptous
//
//  Created by Roshan Gita  on 10/23/16.
//  Copyright © 2016 SPA. All rights reserved.
//

import UIKit

protocol ExpandCellDelegate {
    func collapseClick(_: NSInteger)
    func openEmailClick(_: NSInteger)
    func openPhoneClick(_: NSInteger)
}

class ExpandCell: UITableViewCell {
    @IBOutlet weak var ownerPhotoImgView: CircularImageView!
    @IBOutlet weak var ownerView: UIView!
    @IBOutlet weak var ownerNameLbl: UILabel!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var teamLbl: UILabel!
    @IBOutlet weak var emailLbl: UILabel!
    @IBOutlet weak var phoneLbl: UILabel!
    @IBOutlet weak var kidsLbl: UILabel!
    @IBOutlet weak var collapseBtn: UIButton!
    @IBOutlet weak var emailBtn: UIButton!
    @IBOutlet weak var phoneBtn: UIButton!
    var delegate: ExpandCellDelegate!
    
    func attributedString(_ str: String) -> NSAttributedString? {
        let attributes = [
            NSForegroundColorAttributeName : UIColor.blue,
            NSUnderlineStyleAttributeName : NSUnderlineStyle.styleSingle.rawValue
            ] as [String : Any]
        let attributedString = NSAttributedString(string: str, attributes: attributes)
        return attributedString
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        Custom.fullCornerView(ownerView)
       
    }
    
    func updateView(_ data: Contacts) {
        if data.email != nil {
            let attributedStr = NSMutableAttributedString()
            let attributedString1 = NSAttributedString(string: ("email: "), attributes: nil)
            attributedStr.append(attributedString1)
            attributedStr.append(attributedString("\(data.email!)")!)
            emailLbl.attributedText = attributedStr
        }
        
        if data.mobile != nil {
            let attributedStr1 = NSMutableAttributedString()
            let attributedString2 = NSAttributedString(string: ("mobile: "), attributes: nil)
            attributedStr1.append(attributedString2)
            attributedStr1.append(attributedString("\(data.mobile!)")!)
            phoneLbl.attributedText = attributedStr1
        }
        
        // Initialization code
        
        
        kidsLbl.text = ""
        var childrens = [String]()
        if data.children != nil {
            for i in 0..<(data.children?.count)! {
                let dic = data.children?.object(at: i) as! NSDictionary
                childrens.append("\((dic.object(forKey: "firstName"))!)")
            }
            let stringRepresentation1 = childrens.joined(separator: ", ")
            kidsLbl.text = "kids: \(stringRepresentation1)"
            
        }
    
        
        if data.address != nil {
            teamLbl.text = data.address!
        }

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
        
               
    }

    
    @IBAction func collapse(sender: UIButton) {
        delegate.collapseClick(sender.tag)
    }
    
    @IBAction func emailClick(_ sender: UIButton) {
        delegate.openEmailClick(sender.tag)
    }
    
    @IBAction func phoneClick(_ sender: UIButton) {
        delegate.openPhoneClick(sender.tag)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
