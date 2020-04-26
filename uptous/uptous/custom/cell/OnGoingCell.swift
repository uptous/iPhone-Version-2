//
//  OnGoingCell.swift
//  uptous
//
//  Created by Roshan Gita  on 9/24/16.
//  Copyright © 2016 SPA. All rights reserved.
//

import UIKit

class OnGoingCell: UITableViewCell {

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
    @IBOutlet weak var gifImageView: UIImageView!
    
    
    @IBOutlet weak var ownerPhotoImgView: CircularImageView!
    @IBOutlet weak var identifierView: GroupIdentifierView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        _ = cornerView(volunteeredView)
        //cornerView(fullView)
        _ = cornerView(openView)
    }
    
    func updateView(_ data: Items) {
        let attributedStr = NSMutableAttributedString()
        
        if data.volunteerStatus == "Open" {
            volunteeredView.isHidden = true
            //fullView.isHidden = true
            openView.isHidden = false
            msgLbl.text = data.name!
            let dt = Custom.dayStringFromTime3(data.dateTime!)
            eventDateLbl.text = ("Next Duty:\(dt)")
            
            let count = data.numVolunteers! - data.volunteerCount!
            
            attributedStr.append(Custom.attributedString1(("\(count) "),size: 14.0)!)
            let attributedString1 = NSAttributedString(string: "spots open", attributes: nil)
            
            attributedStr.append(attributedString1)
            if data.numVolunteers! == 0 {
                spotLbl.text = "Open"
                
            }else {
                spotLbl.attributedText = attributedStr
            }
            
        }else if data.volunteerStatus == "Volunteered" {
            volunteeredView.isHidden = false
            //fullView.isHidden = true
            openView.isHidden = true
            msg1Lbl.text = data.name!
            let dt = Custom.dayStringFromTime3(data.dateTime!)
            eventDate1Lbl.text = ("Next Duty:\(dt)")
            //eventDate1Lbl.text = Custom.dayStringFromTime1(data.dateTime!)
            gifImageView.image = Custom.setGIFImage(name: "volunteer2")
            
            
        }/*else if data.volunteerStatus == "Full" {
            volunteeredView.isHidden = true
            fullView.isHidden = false
            openView.isHidden = true
            msg2Lbl.text = data.name!
            eventDate2Lbl.text = Custom.dayStringFromTime1(data.dateTime!)
        }*/
    }
    
    
    func cornerView(_ contentsView: UIView) ->UIView {
        contentsView.layer.borderColor = UIColor(red: CGFloat(0.8), green: CGFloat(0.8), blue: CGFloat(0.8), alpha: CGFloat(1)).cgColor
        contentsView.layer.borderWidth = CGFloat(1.0)
        contentsView.layer.cornerRadius = 8.0
        
        return contentsView
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
