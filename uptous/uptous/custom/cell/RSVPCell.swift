//
//  RSVPCell.swift
//  uptous
//
//  Created by Roshan Gita  on 9/24/16.
//  Copyright © 2016 SPA. All rights reserved.
//

import UIKit

class RSVPCell: UITableViewCell {

    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var rsvpLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        Custom.cornerView(cellView)
    }
    
    func updateView(_ data: Items) {
        rsvpLbl.text = data.name!
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
