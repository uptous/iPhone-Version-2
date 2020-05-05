//
//  DriverItemCell.swift
//  uptous
//
//  Created by Roshan Gita  on 10/1/16.
//  Copyright © 2016 UpToUs. All rights reserved.
//

import UIKit

class DriverItemCell: UITableViewCell {

    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var phoneLbl: UILabel!
    @IBOutlet weak var seatsLbl: UILabel!
    
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
        let seats = data.object(forKey: "comment") as? String ?? ""
        nameLbl.text = name
        if phone.isEmpty {phoneLbl.text = ""} else {phoneLbl.text = "Phone: " + phone}
        if seats.isEmpty {seatsLbl.text = ""} else if seats.isNumeric {seatsLbl.text = "# of seats: " + seats} else {seatsLbl.text = "Comment: " + seats}
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension String {
    var isNumeric: Bool {
        guard !self.isEmpty else {return false}
        let nums: Set<Character> = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]
        return Set(self).isSubset(of: nums)
    }
}
