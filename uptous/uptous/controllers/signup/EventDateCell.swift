//
//  EventDateCell.swift
//  uptous
//
//  Created by Roshan Gita  on 9/20/16.
//  Copyright © 2016 SPA. All rights reserved.
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
        
        contentsView.roundCorners([.TopLeft,.BottomLeft], radius: 8)
        teamLbl.layer.borderColor = UIColor.blackColor().CGColor
        teamLbl.layer.borderWidth = 1.0
    }
    
    func update(data: SignupSheet) {
        print(data)
        let format = NSDateFormatter()
        format.dateFromString("MMM d")
        let today = format.stringFromDate(NSDate())
        if today == Custom.dayStringFromTime1(data.dateTime!) {
            eventDateLbl.textColor = UIColor.redColor()
            eventDateImgView.image = UIImage(named: "red-file-selected")
            
        }else {
            eventDateLbl.textColor = UIColor.blackColor()
            eventDateImgView.image = UIImage(named: "black-file-selected")
        }
        //lblWidth.constant = Custom.widthSize(data.name!, fontName: "Helvetica Neue", fontSize: 14.0) + 20
        
        /*if data.dateTime == 0 {
            if data.createDate! == 0 {
                eventDateLbl.text = ""
            }else {
                eventDateLbl.text = Custom.dayStringFromTime1(data.createDate!)
 
            }

        }else {
            eventDateLbl.text = Custom.dayStringFromTime1(data.dateTime!)

        }*/
        eventDateLbl.text = Custom.dayStringFromTime1(data.dateTime!)
        
        if data.dateTime == 0 {
            eventDateLbl.text = ""
            
        }else {
            eventDateLbl.text = Custom.dayStringFromTime1(data.dateTime!)
        }
        
        if data.cutoffDate == 0 {
            cutOffDateLbl.text = ""
            
        }else {
            cutOffDateLbl.text = Custom.dayStringFromTime1(data.cutoffDate!)
        }
        typeLbl.text = data.name!
        teamLbl.text =  "Community Name"//data.type!
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension UIView {
    func roundCorners(corners:UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.CGPath
        self.layer.mask = mask
    }
}
