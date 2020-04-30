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
    @IBOutlet weak var commentLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //Custom.fullCornerView(ownerView)
        _ = Custom.cornerView(cellView)
    }
    
    func updateData(_ data: NSDictionary) {
        let name = data.object(forKey: "firstName") as? String ?? ""
        
        let phone = data.object(forKey: "phone") as? String ?? ""
        let comment = data.object(forKey: "comment") as? String ?? ""
        nameLbl.text = name
        phoneLbl.text = phone
        commentLbl.text = comment
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
