//
//  RSVPVolunteerCell.swift
//  uptous
//
//  Created by Roshan Gita  on 12/4/16.
//  Copyright © 2016 UpToUs. All rights reserved.
//

import UIKit

class RSVPVolunteerCell: UITableViewCell  {
    
    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var phoneLbl: UILabel!
    @IBOutlet weak var commentLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        _ = Custom.cornerView(cellView)
    }
    
    func updateData(_ data: NSDictionary, type:String) {
        //let attendees = data.object(forKey: "attendees") as? Int ?? 0
        let name = data.object(forKey: "firstName") as? String ?? ""
        //if attendees == 0 {
            nameLbl.text = name
        //}else {
        //    if type != "Vote" {
        //        nameLbl.text = name + " - \(attendees) attendees"

        //    }else {
        //        nameLbl.text = name
        //   }
        //}
        
        
       // let phone = data.object(forKey: "phone") as? String ?? ""
        let comment = data.object(forKey: "comment") as? String ?? ""
        
        //phoneLbl.text = phone
        commentLbl.text = comment
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
