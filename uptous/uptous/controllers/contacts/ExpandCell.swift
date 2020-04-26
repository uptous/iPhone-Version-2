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
    //@IBOutlet weak var ownerPhotoImgView: CircularImageView!
    @IBOutlet weak var ownerPhotoImgView: UIImageView!
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
            convertFromNSAttributedStringKey(NSAttributedString.Key.foregroundColor) : UIColor.blue,
            convertFromNSAttributedStringKey(NSAttributedString.Key.underlineStyle) : NSUnderlineStyle.single.rawValue
            ] as [String : Any]
        let attributedString = NSAttributedString(string: str, attributes: convertToOptionalNSAttributedStringKeyDictionary(attributes))
        return attributedString
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        _ = Custom.fullCornerView(ownerView)
        ownerView.isHidden = false
        ownerNameLbl.isHidden = false
        ownerPhotoImgView.isHidden = true
    }
    
    func updateView(_ data: Contacts) {
        ownerView.isHidden = false
        ownerNameLbl.isHidden = false
        ownerPhotoImgView.isHidden = true
        ownerPhotoImgView.layer.cornerRadius = 25.0
        ownerPhotoImgView.layer.masksToBounds = true
        
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
        
        if data.firstName != "" && data.lastName != "" {
            nameLbl.text = ("\(data.lastName!),") + (" \(data.firstName!)") //("\(data.firstName!)") + (" \(data.lastName!)")
            
            let firstName = data.firstName!.capitalized.prefix(1)
            let secondName = data.lastName!.capitalized.prefix(1)
            let resultString = ("\(secondName)") + ("\(firstName)") //("\(firstName!)") + ("\(secondName!)")
            ownerNameLbl.text = resultString
            
        }else if data.firstName != "" {
            nameLbl.text = ("\(data.firstName!)")
            let firstName = data.firstName!.capitalized.prefix(1)
            let resultString = ("\(firstName)")
            ownerNameLbl.text = resultString
            
        }else if data.lastName != "" {
            nameLbl.text = (" \(data.lastName!)")
            let secondName = data.lastName!.capitalized.prefix(1)
            let resultString = ("\(secondName)")
            ownerNameLbl.text = resultString
        }else {
            nameLbl.text = "- -"
            ownerNameLbl.text = "- -"
        }
        //print("\(data.firstName!)")
        //print("\(data.photo!)")
        if data.photo == "" {
            let color1 = Utility.hexStringToUIColor(hex: data.memberBackgroundColor!)
            let color2 = Utility.hexStringToUIColor(hex: data.memberTextColor!)
            ownerView.backgroundColor = color1
            ownerNameLbl.textColor = color2
            
        }else if data.photo != "https://dsnn35vlkp0h4.cloudfront.net/images/blank_image.gif" {
            ownerView.isHidden = true
            if let avatarUrl = data.photo {
                ownerPhotoImgView.isHidden = false
                //ownerPhotoImgView.setUserAvatar(avatarUrl)
                ownerPhotoImgView.setShowActivityIndicator(true)
                ownerPhotoImgView.setIndicatorStyle(.gray)
                let block: SDWebImageCompletionBlock = {(image: UIImage?, error: Error?, cacheType: SDImageCacheType!, imageURL: URL?) -> Void in
                    self.ownerPhotoImgView.image = image
                    self.ownerPhotoImgView.setShowActivityIndicator(false)
                }
                let url = URL(string: avatarUrl)
                ownerPhotoImgView.sd_setImage(with: url, completed: block)
                //ownerPhotoImgView.sd_setImage(with: URL(string:avatarUrl) as URL!, completed:block)
            }
        }else {
            let color1 = Utility.hexStringToUIColor(hex: data.memberBackgroundColor!)
            let color2 = Utility.hexStringToUIColor(hex: data.memberTextColor!)
            ownerView.backgroundColor = color1
            ownerNameLbl.textColor = color2
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

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromNSAttributedStringKey(_ input: NSAttributedString.Key) -> String {
	return input.rawValue
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToOptionalNSAttributedStringKeyDictionary(_ input: [String: Any]?) -> [NSAttributedString.Key: Any]? {
	guard let input = input else { return nil }
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (NSAttributedString.Key(rawValue: key), value)})
}
