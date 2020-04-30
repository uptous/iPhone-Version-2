//
//  RSVPCell.swift
//  uptous
//
//  Created by Roshan Gita  on 9/24/16.
//  Copyright © 2016 UpToUs. All rights reserved.
//

import UIKit

class RSVPCell: UITableViewCell {

    @IBOutlet weak var volunteeredView: UIView!
    @IBOutlet weak var openView: UIView!
    @IBOutlet weak var rsvpLbl: UILabel!
    @IBOutlet weak var rsvpLbl1: UILabel!
    @IBOutlet weak var gifImageView: UIImageView!
    @IBOutlet weak var openDateLbl: UILabel!
    @IBOutlet weak var volunteerDateLbl: UILabel!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        _ = cornerView(volunteeredView)
        _ = cornerView(openView)
    }
    
    func updateView(_ data: Items) {
        rsvpLbl.text = data.name!
        
        if data.volunteerStatus == "Open" {
            volunteeredView.isHidden = true
            openView.isHidden = false
            rsvpLbl.text = data.name! 
            
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
            openView.isHidden = true
            rsvpLbl1.text = data.name!
            gifImageView.image = Custom.setGIFImage(name: "volunteer")
            
            if data.dateTime == 0 {
                volunteerDateLbl.text =  ""
                
            }else {
                if Custom.dayStringFromTime4(data.dateTime!) == "1:00AM" {
                    volunteerDateLbl.text =  "\(Custom.dayStringSignupItems(data.dateTime!))"
                    
                }else if data.endTime == "" || data.endTime == "1:00AM" {
                    volunteerDateLbl.text = "\(Custom.dayStringSignupItems(data.dateTime!))," + "" + " \(Custom.dayStringFromTime4(data.dateTime!))"
                }else {
                    volunteerDateLbl.text = "\(Custom.dayStringSignupItems(data.dateTime!)), " + "" + " \(Custom.dayStringFromTime4(data.dateTime!)) - " + "" + "\(data.endTime!)"
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
