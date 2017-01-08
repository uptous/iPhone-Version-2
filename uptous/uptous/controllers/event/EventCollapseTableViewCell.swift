//
//  EventCollapseTableViewCell.swift
//  uptous
//
//  Created by Roshan Gita  on 12/26/16.
//  Copyright © 2016 SPA. All rights reserved.
//

import UIKit

protocol EventCellDelegate {
    func expandClick(_: NSInteger)
}

class EventCollapseTableViewCell: UITableViewCell {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var locationBtn: UIButton!
    @IBOutlet weak var viewExpendableBtn: UIButton!
    @IBOutlet weak var lblStartTime: UILabel!
    @IBOutlet weak var lblEndTime: UILabel!
    @IBOutlet weak var cellView: UIView!
    var delegate: EventCellDelegate!
    @IBOutlet weak var expandBtn: UIButton!


    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.clipsToBounds = true
        Custom.cornerView(cellView)
        // Initialization code
        locationBtn.contentHorizontalAlignment = .left
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
   
    @IBAction func expandClick(_ sender: UIButton) {
        delegate.expandClick(sender.tag)
    }
    
    func updateData(_ data: Event) {
        
        lblTitle.text = data.title!
        
        /*print(Custom.dayStringFromTime2(data.startTime!))
        print(Custom.dayStringFromTime2(data.endTime!))
        lblStartTime.text = Custom.dayStringFromTime2(data.startTime!)
        lblEndTime.text = Custom.dayStringFromTime2(data.endTime!)*/
        
        let startDate = Custom.dayStringFromTime2(data.startTime!)
        let endDate = Custom.dayStringFromTime2(data.endTime!)
        let startTime = Custom.dayStringFromTime4(data.startTime!)
        let endTime = Custom.dayStringFromTime4(data.endTime!)
        let startDate1 = Custom.dayStringFromTime3(data.startTime!)
        let endDate1 = Custom.dayStringFromTime3(data.endTime!)
        
        var startDateValue = ""
        var endDateValue = ""
        
        if data.allDay == true {
            startDateValue = startDate
            endDateValue = endDate //"All Day"
            
        }else {
            if startDate == endDate {
                startDateValue = startDate1
                endDateValue = endDate1 //"\(startTime)" + " until \(endTime)"
                
            }else if startDate != endDate {
                startDateValue = startDate
                endDateValue = "until \(endDate)"
            }
            
        }
        
        
        lblStartTime.text =  startDateValue//Custom.dayStringFromTime2(data.startTime!)
        lblEndTime.text =  endDateValue//Custom.dayStringFromTime2(data.endTime!)
        
        let underlineAttribute = [NSUnderlineStyleAttributeName: NSUnderlineStyle.styleSingle.rawValue]
        let underlineAttributedString = NSAttributedString(string: data.location!, attributes: underlineAttribute)
        locationBtn.setAttributedTitle(underlineAttributedString, for: UIControlState.normal)
        
    }


    
    
}
