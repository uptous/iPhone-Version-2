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
        Custom.cornerView(cellView)
    }
    
    func updateData(data: NSDictionary) {
        
        let name = data.objectForKey("firstName") as? String ?? ""
        let phone = data.objectForKey("phone") as? String ?? ""
        if phone == "" {
            nameLbl.text = name

        }else {
            let attributedStr = NSMutableAttributedString()
            let attributedString1 = NSAttributedString(string: name, attributes: nil)
            attributedStr.appendAttributedString(attributedString1)
            attributedStr.appendAttributedString(Custom.attributedString(("- \(phone)"),size: 16.0)!)
            
            nameLbl.attributedText = attributedStr
            //nameLbl.text = data.objectForKey("firstName") as? String ?? ""

        }
        
        //let eventDate = data.objectForKey("dateTime") as! String ?? ""
        dateLbl.text = ""
    }
    



    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
