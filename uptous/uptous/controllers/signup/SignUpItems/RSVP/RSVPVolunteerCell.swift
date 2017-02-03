//
//  RSVPVolunteerCell.swift
//  uptous
//
//  Created by Roshan Gita  on 12/4/16.
//  Copyright © 2016 SPA. All rights reserved.
//

import UIKit

class RSVPVolunteerCell: UITableViewCell  {
    
    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var phoneLbl: UILabel!
    @IBOutlet weak var commentLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        Custom.cornerView(cellView)
    }
    
    func updateData(_ data: NSDictionary) {
        let attendees = data.object(forKey: "attendees") as? Int
        let name = data.object(forKey: "firstName") as? String ?? ""
        if attendees == 0 {
            nameLbl.text = name
        }else {
            nameLbl.text = name + " - \(attendees!)"
        }
        
        
        let phone = data.object(forKey: "phone") as? String ?? ""
        let comment = data.object(forKey: "comment") as? String ?? ""
        
        phoneLbl.text = phone
        commentLbl.text = comment
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}