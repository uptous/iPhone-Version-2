//
//  ShiftCell.swift
//  uptous
//
//  Created by Roshan Gita  on 10/8/16.
//  Copyright © 2016 SPA. All rights reserved.
//

import UIKit

class ShiftCell: UITableViewCell {
    
    @IBOutlet weak var volunteeredView: UIView!
    @IBOutlet weak var openView: UIView!
    @IBOutlet weak var fullView: UIView!
    @IBOutlet weak var msgLbl: UILabel!
    @IBOutlet weak var spotLbl: UILabel!
    @IBOutlet weak var eventDateLbl: UILabel!
    @IBOutlet weak var volunteeredLbl: UILabel!
    @IBOutlet weak var msg1Lbl: UILabel!
    @IBOutlet weak var eventDate1Lbl: UILabel!
    @IBOutlet weak var msg2Lbl: UILabel!
    @IBOutlet weak var eventDate2Lbl: UILabel!
    
    @IBOutlet weak var ownerPhotoImgView: CircularImageView!
    @IBOutlet weak var identifierView: GroupIdentifierView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        cornerView(volunteeredView)
        cornerView(fullView)
        cornerView(openView)
    }
    
    func updateView(data: Items) {
        let attributedStr = NSMutableAttributedString()

        if data.volunteerStatus == "Open" {
            volunteeredView.hidden = true
            fullView.hidden = true
            openView.hidden = false
            msgLbl.text = data.name!
            eventDateLbl.text = Custom.dayStringFromTime1(data.dateTime!)
            
            let count = data.numVolunteers! - data.volunteerCount!
            
            attributedStr.appendAttributedString(Custom.attributedString1(("\(count) "),size: 14.0)!)
            let attributedString1 = NSAttributedString(string: "spots open", attributes: nil)
            
        attributedStr.appendAttributedString(attributedString1)
            spotLbl.attributedText = attributedStr
            
            
        }else if data.volunteerStatus == "Volunteered" {
            volunteeredView.hidden = false
            fullView.hidden = true
            openView.hidden = true
            msg1Lbl.text = data.name!
            eventDate1Lbl.text = Custom.dayStringFromTime1(data.dateTime!)
            
        }else if data.volunteerStatus == "Full" {
            volunteeredView.hidden = true
            fullView.hidden = false
            openView.hidden = true
            msg2Lbl.text = data.name!
            eventDate2Lbl.text = Custom.dayStringFromTime1(data.dateTime!)
        }
    }
    
    
    func cornerView(contentsView: UIView) ->UIView {
        contentsView.layer.borderColor = UIColor(red: CGFloat(0.8), green: CGFloat(0.8), blue: CGFloat(0.8), alpha: CGFloat(1)).CGColor
        contentsView.layer.borderWidth = CGFloat(1.0)
        contentsView.layer.cornerRadius = 8.0
        
        return contentsView
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
