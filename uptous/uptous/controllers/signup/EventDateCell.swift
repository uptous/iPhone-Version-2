//
//  EventDateCell.swift
//  uptous
//
//  Created by Roshan Gita  on 9/20/16.
//  Copyright © 2016 UpToUs. All rights reserved.
//

import UIKit

class EventDateCell: UITableViewCell {

    @IBOutlet weak var lblWidth: NSLayoutConstraint!
    @IBOutlet weak var contentsView: UIView!
    @IBOutlet weak var eventDateLbl: UILabel!
    @IBOutlet weak var cutOffDateLbl: UILabel!
    @IBOutlet weak var typeLbl: UILabel!
    @IBOutlet weak var teamLbl: UILabel!
    @IBOutlet weak var eventDateImgView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //contentsView.roundCorners([.topLeft,.bottomLeft], radius: 8)
        //teamLbl.layer.borderColor = UIColor.black.cgColor
        //teamLbl.layer.borderWidth = 1.0
        
        contentsView.layer.borderColor = UIColor.lightGray.cgColor
        contentsView.layer.borderWidth = 1.5
        contentsView.layer.cornerRadius = 10.0
    }
    
    func update(_ data: SignupSheet, communityList:NSMutableArray) {
        let format = DateFormatter()
        format.date(from: "MMM d")
        let today = format.string(from: Date())
        if today == Custom.dayStringFromTime1(data.dateTime!) {
            eventDateLbl.textColor = UIColor.red
            eventDateImgView.image = UIImage(named: "red-file-selected")
            
        }else {
            eventDateLbl.textColor = UIColor.black
            eventDateImgView.image = UIImage(named: "black-file-selected")
        }
        
        
        /*if data.dateTime == 0 {
            if data.createDate! == 0 {
                eventDateLbl.text = ""
            }else {
                eventDateLbl.text = Custom.dayStringFromTime1(data.createDate!)
 
            }

        }else {
            eventDateLbl.text = Custom.dayStringFromTime1(data.dateTime!)

        }*/
        eventDateLbl.text = Custom.dayStringFromTime5(data.dateTime!)
        
        if data.dateTime == 0 {
            eventDateLbl.text = ""
            
        }else {
            eventDateLbl.text = Custom.dayStringFromTime5(data.dateTime!)
        }
        
        if data.cutoffDate == 0 {
            cutOffDateLbl.text = ""
            
        }else {
            cutOffDateLbl.text = Custom.dayStringFromTime5(data.cutoffDate!)
        }
        typeLbl.text = data.name!
        
        for i in 0..<communityList.count {
            let community = communityList.object(at: i) as? Community
            if community?.communityId == data.communityId {
                teamLbl.text =  community?.name
                lblWidth.constant = Custom.widthSize((community?.name)!, fontName: "Helvetica Neue", fontSize: 14.0) + 20
            }
        }
        //teamLbl.text =  "Community Name"//data.type!
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension UIView {
    func roundCorners(_ corners:UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
}
