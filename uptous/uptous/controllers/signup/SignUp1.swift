//
//  SignUp1.swift
//  uptous
//
//  Created by Roshan on 10/14/17.
//  Copyright © 2017 SPA. All rights reserved.
//

import UIKit

class SignUp1: UIView {

    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var eventDateLbl: UILabel!
    @IBOutlet weak var eventTimeLbl: UILabel!
    @IBOutlet weak var cutoffDateLbl: UILabel!
    @IBOutlet weak var cutoffTimeLbl: UILabel!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var descLbl: UILabel!
    @IBOutlet weak var descTableView: UITableView!
    @IBOutlet weak var textViewHeightContraint: NSLayoutConstraint!
    @IBOutlet weak var viewHeightContraint: NSLayoutConstraint!
    
    var data = appDelegate.globalSignUpData
    
    class func instanceFromNib() -> UIView {
        return UINib(nibName: "SignUp1", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! SignUp1
    }
    
    fileprivate struct signUpCellConstants {
        static var cellIdentifier:String = "SignUpCell"
    }
    
    override func awakeFromNib() {
        descTableView.isHidden = true
        if data!.notes != "" {
            descTableView.isHidden = false
        }
        
        let signUPNib = UINib(nibName: "DescCell", bundle: nil)
        descTableView.register(signUPNib, forCellReuseIdentifier: signUpCellConstants.cellIdentifier as String)
        
        descTableView.estimatedRowHeight = 45
        descTableView.rowHeight = UITableViewAutomaticDimension
        
        Custom.cornerView(contentView)
        titleLbl.text = data?.name
        
       
        
        //For Event Date and Time
        if data!.dateTime == 0 {
            eventTimeLbl.text = ""
        }else {
            eventDateLbl.text = Custom.dayStringFromTime1(data!.dateTime!)
            
            if data!.endTime == "" || data!.endTime == "1:00AM" {
                if Custom.dayStringFromTime4(data!.dateTime!) != "1:00AM" {
                    eventTimeLbl.text = "\(Custom.dayStringFromTime4(data!.dateTime!))"
                }
                
            }else {
                if Custom.dayStringFromTime4(data!.dateTime!) != "1:00AM" {
                    eventTimeLbl.text = "\(Custom.dayStringFromTime4(data!.dateTime!)) - " + "" + "\(data!.endTime!)"
                }
            }
        }
        //For Cuttoff Date and Time
        if data!.cutoffDate == 0 {
            cutoffDateLbl.text = ""
        }else {
            cutoffDateLbl.text = Custom.dayStringFromTime1(data!.cutoffDate!)
        }
    }
 }

//MARK:- TableView
extension SignUp1: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: signUpCellConstants.cellIdentifier ) as! DescCell
        
        cell.descLbl.setHTMLFromString(htmlText: data!.notes!)//data!.notes
        
        return cell
    }
}

