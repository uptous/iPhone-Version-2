//
//  SignUpDriversCell.swift
//  uptous
//
//  Created by Roshan Gita  on 9/23/16.
//  Copyright © 2016 UpToUs. All rights reserved.
//

import UIKit



class SignUpDriversCell: UITableViewCell {

    @IBOutlet weak var volunteeredView: UIView!
    @IBOutlet weak var openView: UIView!
    @IBOutlet weak var fullView: UIView!
    @IBOutlet weak var openFromLbl: UILabel!
    @IBOutlet weak var openToLbl: UILabel!
    @IBOutlet weak var openDateLbl: UILabel!
    @IBOutlet weak var volunteeredFromLbl: UILabel!
    @IBOutlet weak var volunteeredToLbl: UILabel!
    @IBOutlet weak var volunteeredDateLbl: UILabel!
    @IBOutlet weak var fullFromLbl: UILabel!
    @IBOutlet weak var fullToLbl: UILabel!
    @IBOutlet weak var fullDateLbl: UILabel!
    @IBOutlet weak var volunteeredLbl: UILabel!
    @IBOutlet weak var gifImageView: UIImageView!
    @IBOutlet weak var ownerPhotoImgView: CircularImageView!
    @IBOutlet weak var identifierView: GroupIdentifierView!
    @IBOutlet weak var spotLbl: UILabel!
    @IBOutlet weak var statusLbl: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        _ = cornerView(volunteeredView)
        _ = cornerView(fullView)
        _ = cornerView(openView)
    }
    
    
    
    func updateView(_ data: Items) {
        let attributedStr = NSMutableAttributedString()
        let attributedStr1 = NSMutableAttributedString()
        let attributedStr3 = NSMutableAttributedString()
        
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
            
            let count = data.numVolunteers! - data.volunteerCount!
            attributedStr3.append(Custom.attributedString1(("\(count) "),size: 14.0)!)
            let attributedString3 = NSAttributedString(string: "spots open", attributes: nil)
            attributedStr3.append(attributedString3)
            if data.numVolunteers! == 0 {
                spotLbl.text = "Open"
            }else {
                spotLbl.attributedText = attributedStr3
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
            
            
        }else if data.volunteerStatus == "Volunteered" || data.volunteerStatus == "Full" {
            volunteeredView.isHidden = false
            fullView.isHidden = true
            openView.isHidden = true
            
            statusLbl.text="Volunteered"
            if data.volunteerStatus == "Full" {
                statusLbl.text="Full"
            }
            
            let attributedString1 = NSAttributedString(string: ("\(data.name!)"), attributes: nil)
            attributedStr.append(Custom.attributedString("From: ",size: 16.0)!)
            attributedStr.append(attributedString1)
            volunteeredFromLbl.attributedText = attributedStr
            
            let attributedString2 = NSAttributedString(string: ("\(data.extra!)"), attributes: nil)
            attributedStr1.append(Custom.attributedString("To: ",size: 16.0)!)
            attributedStr1.append(attributedString2)
            volunteeredToLbl.attributedText = attributedStr1
            gifImageView.image = Custom.setGIFImage(name: "fav-icon")
            
            if data.dateTime == 0 {
                volunteeredDateLbl.text = ""
                
            }else {
                if Custom.dayStringFromTime4(data.dateTime!) == "1:00AM" {
                    volunteeredDateLbl.text =  "\(Custom.dayStringSignupItems(data.dateTime!))"
                    
                }else if data.endTime == "" || data.endTime == "1:00AM" {
                    volunteeredDateLbl.text = "\(Custom.dayStringSignupItems(data.dateTime!))," + "" + " \(Custom.dayStringFromTime4(data.dateTime!))"
                }else {
                    volunteeredDateLbl.text = "\(Custom.dayStringSignupItems(data.dateTime!)), " + "" + " \(Custom.dayStringFromTime4(data.dateTime!)) - " + "" + "\(data.endTime!)"
                }
            }
        }

            
//        }else if data.volunteerStatus == "Full" {
//            volunteeredView.isHidden = true
//            fullView.isHidden = false
//            openView.isHidden = true
            
//            if data.dateTime == 0 {
//                fullDateLbl.text = ""
                
//            }else {
//                if Custom.dayStringFromTime4(data.dateTime!) == "1:00AM" {
//                    fullDateLbl.text =  "\(Custom.dayStringSignupItems(data.dateTime!))"
//                }else if data.endTime == "" || data.endTime == "1:00AM" {
                    
//                    fullDateLbl.text = "\(Custom.dayStringSignupItems(data.dateTime!))," + "" + " \(Custom.dayStringFromTime4(data.dateTime!))"
//                }else {
//                    fullDateLbl.text = "\(Custom.dayStringSignupItems(data.dateTime!)), " + "" + " \(Custom.dayStringFromTime4(data.dateTime!)) - " + "" + "\(data.endTime!)"
//                }
//            }
            
//        }
        
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
