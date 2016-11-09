//
//  SignUpDriversCell.swift
//  uptous
//
//  Created by Roshan Gita  on 9/23/16.
//  Copyright © 2016 SPA. All rights reserved.
//

import UIKit

class SignUpDriversCell: UITableViewCell {

    @IBOutlet weak var volunteeredView: UIView!
    @IBOutlet weak var openView: UIView!
    @IBOutlet weak var fullView: UIView!
    @IBOutlet weak var openFromLbl: UILabel!
    @IBOutlet weak var openToLbl: UILabel!
    @IBOutlet weak var volunteeredFromLbl: UILabel!
    @IBOutlet weak var volunteeredToLbl: UILabel!
    @IBOutlet weak var fullFromLbl: UILabel!
    @IBOutlet weak var fullToLbl: UILabel!
    @IBOutlet weak var volunteeredLbl: UILabel!

    @IBOutlet weak var ownerPhotoImgView: CircularImageView!
    @IBOutlet weak var identifierView: GroupIdentifierView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        cornerView(volunteeredView)
        cornerView(fullView)
        cornerView(openView)
    }
    
    func updateView(_ data: Items) {
        let attributedStr = NSMutableAttributedString()
        let attributedStr1 = NSMutableAttributedString()
        if data.volunteerStatus == "Open" {
            volunteeredView.isHidden = true
            fullView.isHidden = true
            openView.isHidden = false
            
            let attributedString1 = NSAttributedString(string: ("\(data.name!)"), attributes: nil)
            attributedStr.append(Custom.attributedString("From: ",size: 16.0)!)
            attributedStr.append(attributedString1)
            openFromLbl.attributedText = attributedStr
            
            let attributedString2 = NSAttributedString(string: ("\(data.extra!)"), attributes: nil)
            attributedStr1.append(Custom.attributedString("To: ",size: 16.0)!)
            attributedStr1.append(attributedString2)
            openToLbl.attributedText = attributedStr1
            
        }else if data.volunteerStatus == "Volunteered" {
            volunteeredView.isHidden = false
            fullView.isHidden = true
            openView.isHidden = true
            
            let attributedString1 = NSAttributedString(string: ("\(data.name!)"), attributes: nil)
            attributedStr.append(Custom.attributedString("From: ",size: 16.0)!)
            attributedStr.append(attributedString1)
            volunteeredFromLbl.attributedText = attributedStr
            
            let attributedString2 = NSAttributedString(string: ("\(data.extra!)"), attributes: nil)
            attributedStr1.append(Custom.attributedString("To: ",size: 16.0)!)
            attributedStr1.append(attributedString2)
            volunteeredToLbl.attributedText = attributedStr1
            
        }else if data.volunteerStatus == "Full" {
            volunteeredView.isHidden = true
            fullView.isHidden = false
            openView.isHidden = true
            
        }
       /* if data.dateTime == 0 {
            if data.createDate! == 0 {
                eventDateLbl.text = ""
            }else {
                eventDateLbl.text = Custom.dayStringFromTime1(data.createDate!)
                
            }
            
        }else {
            eventDateLbl.text = Custom.dayStringFromTime1(data.dateTime!)
            
        }
        
        if data.cutoffDate == 0 {
            cutOffDateLbl.text = ""
            
        }else {
            cutOffDateLbl.text = Custom.dayStringFromTime1(data.cutoffDate!)
        }
        typeLbl.text = data.name!
        teamLbl.text =  "Community Name"//data.type!*/
        
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
