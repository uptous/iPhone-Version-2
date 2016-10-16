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
    
    func updateView(data: NSDictionary) {
       
        commentDescriptionLbl.text = data.objectForKey("phone") as? String ?? "No Comment"
         nameLbl.text = data.objectForKey("firstName") as? String
        let eventDate = data.objectForKey("dateTime") as? String ?? ""
        dateLbl.text = eventDate
    }


    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
