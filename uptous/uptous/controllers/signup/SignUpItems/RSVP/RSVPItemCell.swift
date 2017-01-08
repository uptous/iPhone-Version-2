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

    override func awakeFromNib() {
        super.awakeFromNib()
        //Custom.cornerView(cellView)
    }
    
    func updateData(_ data: NSDictionary) {
        print(data)
        //commentDescriptionLbl.text = data.object(forKey: "comment") as? String
        commentDescriptionLbl.text = data.object(forKey: "phone") as? String
        let name = data.object(forKey: "firstName") as? String
        let attendes = data.object(forKey: "attendees") as? Int
        nameLbl.text = name! + (" - \(attendes!)")
        //let eventDate = data.object(forKey: "dateTime") as? Double ?? 0
        //dateLbl.text = Custom.dayStringFromTime1(eventDate)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
