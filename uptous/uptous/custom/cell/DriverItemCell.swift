//
//  DriverItemCell.swift
//  uptous
//
//  Created by Roshan Gita  on 10/1/16.
//  Copyright © 2016 SPA. All rights reserved.
//

import UIKit

class DriverItemCell: UITableViewCell {

    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //Custom.fullCornerView(ownerView)
        Custom.cornerView(cellView)
    }
    
    func updateData(_ data: NSDictionary) {
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
        }
        
        //let eventDate = data.objectForKey("dateTime") as! String ?? ""
        dateLbl.text = ""
    }
    



    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
