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
    
    func updateView(data: Items) {
        let attributedStr = NSMutableAttributedString()
        let attributedStr1 = NSMutableAttributedString()
        if data.volunteerStatus == "Open" {
            volunteeredView.hidden = true
            fullView.hidden = true
            openView.hidden = false
            
            let attributedString1 = NSAttributedString(string: ("\(data.name!)"), attributes: nil)
            attributedStr.appendAttributedString(Custom.attributedString("From: ",size: 16.0)!)
            attributedStr.appendAttributedString(attributedString1)
            openFromLbl.attributedText = attributedStr
            
            let attributedString2 = NSAttributedString(string: ("\(data.extra!)"), attributes: nil)
            attributedStr1.appendAttributedString(Custom.attributedString("To: ",size: 16.0)!)
            attributedStr1.appendAttributedString(attributedString2)
            openToLbl.attributedText = attributedStr1
            
        }else if data.volunteerStatus == "Volunteered" {
            volunteeredView.hidden = false
            fullView.hidden = true
            openView.hidden = true
            
            
        }else if data.volunteerStatus == "Full" {
            volunteeredView.hidden = true
            fullView.hidden = false
            openView.hidden = true
            
            /*let attributedString1 = NSAttributedString(string: ("\(data.name!)"), attributes: nil)
            attributedStr.appendAttributedString(Custom.attributedString("From: ",size: 16.0)!)
            attributedStr.appendAttributedString(attributedString1)
            fullFromLbl.text = ("\(attributedStr)")
            
            let attributedString2 = NSAttributedString(string: ("\(data.extra!)"), attributes: nil)
            attributedStr.appendAttributedString(Custom.attributedString("To: ",size: 16.0)!)
            attributedStr.appendAttributedString(attributedString2)
            fullToLbl.text = ("\(attributedStr)")*/
            
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
