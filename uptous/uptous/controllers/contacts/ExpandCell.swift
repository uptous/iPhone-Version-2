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
                
    }
    
    func updateView(_ data: Contacts) {
        let attributedStr = NSMutableAttributedString()
        let attributedString1 = NSAttributedString(string: ("email: "), attributes: nil)
        attributedStr.append(attributedString1)
        attributedStr.append(attributedString("\(data.email!)")!)
        emailLbl.attributedText = attributedStr
        
        // Initialization code
        
        let attributedStr1 = NSMutableAttributedString()
        let attributedString2 = NSAttributedString(string: ("phone: "), attributes: nil)
        attributedStr1.append(attributedString2)
        attributedStr1.append(attributedString("\(data.phone!)")!)
        phoneLbl.attributedText = attributedStr1
        kidsLbl.text = ""
        //let childrens = NSMutableArray()


       /* for i in 0..<data.children?.count {
            let result = data.children.object(at: i) as? NSDictionary
            let data = resul
            if data.newsType == "File" || data.newsType == "Private Threads" || data.newsType == "Announcement" || data.newsType == "Photos" || data.newsType == "Opportunity" {
                self.newsTypeList.append(data)
            }
        }*/

        nameLbl.text = ("\(data.firstName!)") + (" \(data.lastName!)")
        teamLbl.text = data.address!

        
        if data.photo == "https://dsnn35vlkp0h4.cloudfront.net/images/blank_image.gif" {
            ownerView.isHidden = false
            ownerNameLbl.isHidden = false
            ownerPhotoImgView.isHidden = true
            
            let stringArray = nameLbl.text?.components(separatedBy: " ")
            let firstName = stringArray![0]
            let secondName = stringArray![1]
            let resultString = "\(firstName.characters.first!)\(secondName.characters.first!)"
            
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
        }
        
        
        
    }

    
    @IBAction func collapse(sender: UIButton) {
        delegate.collapseClick(sender.tag)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
