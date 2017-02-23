//
//  CalendarTableViewCell.swift
//  uptous
//
//  Created by Upendra Narayan on 21/11/16.
//  Copyright © 2016 SPA. All rights reserved.
//

import UIKit

protocol EventExpandCellDelegate {
    func collapseClick(_: NSInteger)
}

class CalendarTableViewCell: UITableViewCell {
    @IBOutlet weak var lblDetailDesc: UILabel!
    @IBOutlet weak var lblTeacherName: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var locationBtn: UIButton!
    @IBOutlet weak var detailHeightContraint: NSLayoutConstraint!
    @IBOutlet weak var detailViewHeightContraint: NSLayoutConstraint!
    @IBOutlet weak var viewExpendableBtn: UIButton!
    @IBOutlet weak var lblStart: UILabel!
    @IBOutlet weak var lblEnd: UILabel!
    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var communityLabel: UILabel!
    var delegate: EventExpandCellDelegate!
    @IBOutlet weak var collapseBtn: UIButton!
    
    @IBOutlet weak var webView: UIWebView!

   
   
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
    @IBAction func collapse(_ sender: UIButton) {
        delegate.collapseClick(sender.tag)
    }
    
    
    func updateData(_ data: Event, communityList:NSMutableArray) {
        
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
        
        lblTitle.text = data.title!
        lblDetailDesc.text = data.eventDescription!
        let startDate = Custom.dayStringFromTime2(data.startTime!)
        let endDate = Custom.dayStringFromTime2(data.endTime!)
        let startTime = Custom.dayStringFromTime4(data.startTime!)
        let endTime = Custom.dayStringFromTime4(data.endTime!)
        
        let startDate1 = Custom.dayStringFromTime3(data.startTime!)
        let endDate1 = Custom.dayStringFromTime3(data.endTime!)
        let startDate2 = Custom.dayStringFromTime4(data.startTime!)
        let endDate2 = Custom.dayStringFromTime4(data.endTime!)
        
        var startDateValue = ""
        var endDateValue = ""
       
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
        }
        
        
        
        lblStart.text =  startDateValue//Custom.dayStringFromTime2(data.startTime!)
        lblEnd.text =  endDateValue//Custom.dayStringFromTime2(data.endTime!)
        locationBtn.setTitle(data.location!, for: .normal)
       /* let underlineAttribute = [NSUnderlineStyleAttributeName: NSUnderlineStyle.styleSingle.rawValue]
        let underlineAttributedString = NSAttributedString(string: data.location!, attributes: underlineAttribute)
        locationBtn.setAttributedTitle(underlineAttributedString, for: UIControlState.normal)
        
        /*if data.isExpendable == true {
            viewExpendableBtn.setImage(UIImage(named:"up-arrow")!, for: UIControlState.normal)
        }else {
            viewExpendableBtn.setImage(UIImage(named:"down-arrow")!, for: UIControlState.normal)
        }*/
        detailHeightContraint.constant = calculateHeight(data.eventDescription!, width: lblDetailDesc.frame.size.width)*/
        //print(calculateHeight(data.eventDescription!, width: lblDetailDesc.frame.size.width))
        //detailHeightContraint.constant = calculateHeight(data.eventDescription!, width: lblDetailDesc.frame.size.width)
        //detailViewHeightContraint.constant = 350
        DispatchQueue.main.async(execute: {
           // self.webView.loadHTMLString(data.eventDescription!,baseURL: nil)
        })
    }

    //Mark : Get Label Height with text
     func calculateHeight(_ text:String, width:CGFloat) -> CGFloat {
        let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = UIFont(name: "Helvetica Neue Regular", size: 16)
        label.text = text
        
        label.sizeToFit()
        return label.frame.height
    }
    
}
