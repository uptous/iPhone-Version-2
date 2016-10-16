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
    @IBOutlet weak var spotLbl: UILabel!
    @IBOutlet weak var msg1Lbl: UILabel!
    @IBOutlet weak var msg2Lbl: UILabel!
    
    
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
            
            
        }else if data.volunteerStatus == "Full" {
            volunteeredView.hidden = true
            fullView.hidden = false
            openView.hidden = true
            msg2Lbl.text = data.name!
            
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
