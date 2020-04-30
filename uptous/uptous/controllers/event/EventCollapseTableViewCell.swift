//
//  EventCollapseTableViewCell.swift
//  uptous
//
//  Created by Roshan Gita  on 12/26/16.
//  Copyright © 2016 UpToUs. All rights reserved.
//

import UIKit

protocol EventCellDelegate {
    func expandClick(_: NSInteger)
    func openMapForLocation1(_: NSInteger)
}

class EventCollapseTableViewCell: UITableViewCell {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var viewExpendableBtn: UIButton!
    @IBOutlet weak var lblStartTime: UILabel!
    @IBOutlet weak var lblEndTime: UILabel!
    @IBOutlet weak var communityLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var cellView: UIView!
    var delegate: EventCellDelegate!
    @IBOutlet weak var expandBtn: UIButton!


    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.clipsToBounds = true
        //Custom.cornerView(cellView)
        cellView.layer.borderColor = UIColor.lightGray.cgColor
        cellView.layer.borderWidth = 1.5
        cellView.layer.cornerRadius = 10.0
        //locationBtn.contentHorizontalAlignment = .left
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
   
    @IBAction func expandClick(_ sender: UIButton) {
        delegate.expandClick(sender.tag)
    }
    
    @IBAction func locationClick(_ sender: UIButton) {
        delegate.openMapForLocation1(sender.tag)
    }
    
    func updateData(_ data: Event, communityList:NSMutableArray) {
        
        lblTitle.text = data.title!
        
        for i in 0..<communityList.count {
            let community = communityList.object(at: i) as? Community
            if community?.communityId == data.communityId {
                if community?.name == "All Communities" {
                    communityLabel.text = "Personal"
                }else {
                  communityLabel.text = community?.name
                }
            }
        }
        
        let startDate = Custom.dayStringFromTime2(data.startTime!)
        let endDate = Custom.dayStringFromTime2(data.endTime!)
        let startDate1 = Custom.dayStringFromTime3(data.startTime!)
        let endDate1 = Custom.dayStringFromTime3(data.endTime!)
        let startDate2 = Custom.dayStringFromTime4(data.startTime!)
        let endDate2 = Custom.dayStringFromTime4(data.endTime!)
        
        var startDateValue = ""
        var endDateValue = ""
        // February 6 at 9pm until February 7 at 7am.
        if data.allDay == true {
            if startDate == endDate {
                startDateValue = startDate
                endDateValue = "All Day"
            }else {
                startDateValue = startDate
                endDateValue = endDate
            }
        }else {
            startDateValue =  "\(startDate1)" + "  \(startDate2)"
            endDateValue =  "\(endDate1)" + "  \(endDate2)"
            /*if startDate1 == endDate1 {
                startDateValue =  "\(startDate1)" + " at \(startDate2)"
                endDateValue =  "until \(endDate1)" + " at \(endDate2)"
                
            }else{
                startDateValue = startDate1
                endDateValue = "until \(endDate1)"
            }*/
            
        }
        //let address = "\(data.address!), " + "\(data.city!), " + "\(data.state!), " + "\(data.country!), " + "\(data.zipCode!)"
        locationLabel.text = data.location!
        lblStartTime.text =  startDateValue//Custom.dayStringFromTime2(data.startTime!)
        lblEndTime.text =  endDateValue//Custom.dayStringFromTime2(data.endTime!)
        //locationBtn.setTitle(data.location!, for: .normal)

        /*let underlineAttribute = [NSUnderlineStyleAttributeName: NSUnderlineStyle.styleSingle.rawValue]
        let underlineAttributedString = NSAttributedString(string: data.location!, attributes: underlineAttribute)
        locationBtn.setAttributedTitle(underlineAttributedString, for: UIControlState.normal)*/
        
    }


    
    
}
