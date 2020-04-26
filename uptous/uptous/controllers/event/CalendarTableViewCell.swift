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
    func openMapForLocation(_: NSInteger)
}

class CalendarTableViewCell: UITableViewCell {
    @IBOutlet weak var lblDetailDesc: UILabel!
    @IBOutlet weak var lblTeacherName: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var locationBtn: UIButton!
    @IBOutlet weak var lblStart: UILabel!
    @IBOutlet weak var lblEnd: UILabel!
    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var communityLabel: UILabel!
    var delegate: EventExpandCellDelegate!
    @IBOutlet weak var collapseBtn: UIButton!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var descTableView: UITableView!
    
    @IBOutlet weak var tableHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var view1HeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var view2HeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var view1: UIView!
    @IBOutlet weak var view2: UIView!
    
    var desc = ""

    fileprivate struct signUpCellConstants {
        static var cellIdentifier:String = "cell"
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.clipsToBounds = true
        _ = Custom.cornerView(cellView)
        // Initialization code
        locationBtn.contentHorizontalAlignment = .left
        
        let signUPNib = UINib(nibName: "DescCell", bundle: nil)
        descTableView.register(signUPNib, forCellReuseIdentifier: signUpCellConstants.cellIdentifier as String)
        
        descTableView.estimatedRowHeight = 45
        descTableView.rowHeight = UITableView.automaticDimension
    }
    
    func heightForView(text:String, font:UIFont, width:CGFloat) -> CGFloat{
        let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = text
        label.sizeToFit()
        
        return label.frame.height
    }
   
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func collapse(_ sender: UIButton) {
        delegate.collapseClick(sender.tag)
    }
    
    @IBAction func locationClick(_ sender: UIButton) {
        delegate.openMapForLocation(sender.tag)
    }
    
    func viewDidLayoutSubviews() {
        //super.viewDidLayoutSubviews()
        descriptionTextView.setContentOffset(CGPoint.zero, animated: false)
    }
    
    func updateData(_ data: Event, communityList:NSMutableArray) {
        //descriptionTextView.contentOffset = CGPoint.zero
        //descriptionTextView.setContentOffset(CGPoint.zero, animated: false)
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
        desc = data.eventDescription!
        lblTitle.text = data.title!
        //descriptionTextView.text = data.eventDescription!
        let startDate = Custom.dayStringFromTime2(data.startTime!)
        let endDate = Custom.dayStringFromTime2(data.endTime!)
        // let startTime = Custom.dayStringFromTime4(data.startTime!)
        // let endTime = Custom.dayStringFromTime4(data.endTime!)
        
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
        //let address = "\(data.address!), " + "\(data.city!), " + "\(data.state!), " + "\(data.country!), " + "\(data.zipCode!)"
        //locationBtn.setTitle(data.location!, for: .normal)
       
        if (desc.count) > 0 {
            let font = UIFont(name: "Helvetica", size: 14.0)
            //descLabel.text = data!.notes!
            let height = heightForView(text: desc, font: font!, width: descTableView.frame.size.width)
            if height < 20 {
                tableHeightConstraint.constant = 190 + 10//CGFloat(height)
            }else if height < 70{
                tableHeightConstraint.constant = 190 + 20
            }else if height < 100{
                tableHeightConstraint.constant = 190 + 30
            }else {
                tableHeightConstraint.constant = 190 + (CGFloat(height) - 45)
            }
        }else {
            tableHeightConstraint.constant = 190
        }
        
        view1HeightConstraint.constant = tableHeightConstraint.constant
        view2HeightConstraint.constant = tableHeightConstraint.constant
        
        view1.layoutIfNeeded()
        view2.layoutIfNeeded()
        descTableView.layoutIfNeeded()
        
        descTableView.reloadData()
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

//MARK:- TableView
extension CalendarTableViewCell: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: signUpCellConstants.cellIdentifier ) as! DescCell
        cell.descLbl.text = desc
        
        return cell
    }
}

