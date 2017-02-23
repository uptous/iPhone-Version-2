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
    @IBOutlet weak var phoneLbl: UILabel!
    @IBOutlet weak var commentLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //Custom.fullCornerView(ownerView)
        //Custom.cornerView(cellView)
        cellView.layer.borderColor = UIColor.lightGray.cgColor
        cellView.layer.borderWidth = 1.5
        cellView.layer.cornerRadius = 10.0
    }
    
    func updateData(_ data: NSDictionary, commentText:String) {
         let name = data.object(forKey: "firstName") as? String ?? ""
        
        let phone = data.object(forKey: "phone") as? String ?? ""
        nameLbl.text = name
        phoneLbl.text = phone
        commentLbl.text = commentText
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
