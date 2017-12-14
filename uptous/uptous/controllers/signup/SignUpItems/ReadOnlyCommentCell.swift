//
//  ReadOnlyCommentCell.swift
//  uptous
//
//  Created by Roshan Gita  on 10/8/16.
//  Copyright © 2016 SPA. All rights reserved.
//

import UIKit

class ReadOnlyCommentCell: UITableViewCell {

    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var commentDescriptionLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        Custom.cornerView(cellView)
    }
    
    func updateView(_ data: NSDictionary) {
       
        commentDescriptionLbl.text = data.object(forKey: "phone") as? String ?? ""
         nameLbl.text = data.object(forKey: "firstName") as? String
        //let eventDate = data.object(forKey: "dateTime") as? String ?? ""
        //dateLbl.text = eventDate
    }


    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}