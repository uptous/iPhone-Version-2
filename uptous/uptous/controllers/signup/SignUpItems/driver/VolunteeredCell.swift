//
//  VolunteeredCell.swift
//  uptous
//
//  Created by Roshan Gita  on 11/12/16.
//  Copyright © 2016 UpToUs. All rights reserved.
//

import UIKit

class VolunteeredCell: UITableViewCell {

    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var phoneLbl: UILabel!
    @IBOutlet weak var seatsLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //Custom.fullCornerView(ownerView)
        _ = Custom.cornerView(cellView)
    }
    
    func updateData(_ data: NSDictionary) {
        let name = data.object(forKey: "firstName") as? String ?? ""
        let phone = data.object(forKey: "phone") as? String ?? ""
        let seats = data.object(forKey: "comment") as? String ?? ""
        nameLbl.text = name
        if phone.isEmpty {phoneLbl.text = ""} else {phoneLbl.text = "Phone: " + phone}
        print ("seats = " + seats)
        if seats.isEmpty {seatsLbl.text = ""} else if seats.isNumeric {seatsLbl.text = "# of seats: " + seats} else {seatsLbl.text = "Comment: " + seats}
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}


