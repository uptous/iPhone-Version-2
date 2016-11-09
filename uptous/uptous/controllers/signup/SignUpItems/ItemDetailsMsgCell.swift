//
//  ItemDetailsMsgCell.swift
//  uptous
//
//  Created by Roshan Gita  on 10/8/16.
//  Copyright © 2016 SPA. All rights reserved.
//

import UIKit

class ItemDetailsMsgCell: UITableViewCell {

    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var commentDescriptionLbl: UILabel!
    @IBOutlet weak var ownerPhotoImgView: CircularImageView!
    @IBOutlet weak var identifierView: GroupIdentifierView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        Custom.cornerView(cellView)
        
    }
    
    func updateData(_ data: NSDictionary) {
        print(data)
        identifierView.isHidden = true
        ownerPhotoImgView.isHidden = false
        let name = data.object(forKey: "firstName") as? String ?? ""
        let phone = data.object(forKey: "phone") as? String ?? ""
        if phone == "" {
            nameLbl.text = name
            
        }else {
            let attributedStr = NSMutableAttributedString()
            let attributedString1 = NSAttributedString(string: name, attributes: nil)
            attributedStr.append(attributedString1)
            attributedStr.append(Custom.attributedString(("- \(phone)"),size: 16.0)!)
            
            nameLbl.attributedText = attributedStr
            //nameLbl.text = data.objectForKey("firstName") as? String ?? ""
            
        }
        
        //let eventDate = data.objectForKey("dateTime") as! String ?? ""
        dateLbl.text = ""
        commentDescriptionLbl.text = phone
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
