//
//  VolunteerwCell.swift
//  uptous
//
//  Created by Roshan Gita  on 10/8/16.
//  Copyright © 2016 SPA. All rights reserved.
//

import UIKit



class VolunteerwCell: UITableViewCell {

    @IBOutlet weak var volunteeredView: UIView!
    @IBOutlet weak var openView: UIView!
    @IBOutlet weak var fullView: UIView!
    @IBOutlet weak var msgLbl: UILabel!
    @IBOutlet weak var openDateLbl: UILabel!
    @IBOutlet weak var volunteerDateLbl: UILabel!
    @IBOutlet weak var fullDateLbl: UILabel!
    @IBOutlet weak var spotLbl: UILabel!
    @IBOutlet weak var msg1Lbl: UILabel!
    @IBOutlet weak var msg2Lbl: UILabel!
    @IBOutlet weak var gifImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        _ = cornerView(volunteeredView)
        _ = cornerView(fullView)
        _ = cornerView(openView)
    }
    
    func updateView(_ data: Items) {
        let attributedStr = NSMutableAttributedString()
        
        if data.volunteerStatus == "Open" {
            volunteeredView.isHidden = true
            fullView.isHidden = true
            openView.isHidden = false
            msgLbl.text = data.name!
            let count = data.numVolunteers! - data.volunteerCount!
            
            attributedStr.append(Custom.attributedString1(("\(count) "),size: 14.0)!)
            let attributedString1 = NSAttributedString(string: "spots open", attributes: nil)
            
            attributedStr.append(attributedString1)
            if data.numVolunteers! == 0 {
                spotLbl.text = "Open"
            }else {
                spotLbl.attributedText = attributedStr
            }
            if data.dateTime == 0 {
                openDateLbl.text = ""
                
            }else {
                if Custom.dayStringFromTime4(data.dateTime!) == "1:00AM" {
                    openDateLbl.text =  "\(Custom.dayStringSignupItems(data.dateTime!))"
                    
                }else if data.endTime == "" || data.endTime == "1:00AM" {
                    openDateLbl.text = "\(Custom.dayStringSignupItems(data.dateTime!))," + "" + " \(Custom.dayStringFromTime4(data.dateTime!))"
                }else {
                    openDateLbl.text = "\(Custom.dayStringSignupItems(data.dateTime!)), " + "" + " \(Custom.dayStringFromTime4(data.dateTime!)) - " + "" + "\(data.endTime!)"
                }
            }
            
            
        }else if data.volunteerStatus == "Volunteered" {
            volunteeredView.isHidden = false
            fullView.isHidden = true
            openView.isHidden = true
            msg1Lbl.text = data.name!
            gifImageView.image = Custom.setGIFImage(name: "volunteer1")
            if data.dateTime == 0 {
                volunteerDateLbl.text = ""
                
            }else {
                if Custom.dayStringFromTime4(data.dateTime!) == "1:00AM" {
                    volunteerDateLbl.text =  "\(Custom.dayStringSignupItems(data.dateTime!))"
                    
                }else if data.endTime == "" || data.endTime == "1:00AM" {
                    volunteerDateLbl.text = "\(Custom.dayStringSignupItems(data.dateTime!))," + "" + " \(Custom.dayStringFromTime4(data.dateTime!))"
                }else {
                    volunteerDateLbl.text = "\(Custom.dayStringSignupItems(data.dateTime!)), " + "" + " \(Custom.dayStringFromTime4(data.dateTime!)) - " + "" + "\(data.endTime!)"
                }
            }
            
            
        }else if data.volunteerStatus == "Full" {
            volunteeredView.isHidden = true
            fullView.isHidden = false
            openView.isHidden = true
            msg2Lbl.text = data.name!
            
            if data.dateTime == 0 {
                fullDateLbl.text = ""
                
            }else {
                if Custom.dayStringFromTime4(data.dateTime!) == "1:00AM" {
                    fullDateLbl.text =  "\(Custom.dayStringSignupItems(data.dateTime!))"
                    
                }else if data.endTime == "" || data.endTime == "1:00AM" {
                    fullDateLbl.text = "\(Custom.dayStringSignupItems(data.dateTime!))," + "" + " \(Custom.dayStringFromTime4(data.dateTime!))"
                }else {
                    fullDateLbl.text = "\(Custom.dayStringSignupItems(data.dateTime!)), " + "" + " \(Custom.dayStringFromTime4(data.dateTime!)) - " + "" + "\(data.endTime!)"
                }
            }
        }
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
