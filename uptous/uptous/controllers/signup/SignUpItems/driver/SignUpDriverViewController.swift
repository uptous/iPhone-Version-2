//
//  SignUpDriverViewController.swift
//  uptous
//
//  Created by Roshan Gita  on 9/21/16.
//  Copyright © 2016 SPA. All rights reserved.
//

import UIKit
import Alamofire

class SignUpDriverViewController: GeneralViewController {

    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var notesLbl: UILabel!
    @IBOutlet weak var contact1Lbl: UILabel!
    @IBOutlet weak var contact2Lbl: UILabel!
    @IBOutlet weak var eventDateLbl: UILabel!
    @IBOutlet weak var eventTimeLbl: UILabel!
    @IBOutlet weak var cutoffDateLbl: UILabel!
    @IBOutlet weak var cutoffTimeLbl: UILabel!
    @IBOutlet weak var contact1PhotoImgView: CircularImageView!
    @IBOutlet weak var contact2PhotoImgView: CircularImageView!
    @IBOutlet weak var owner1View: UIView!
    @IBOutlet weak var owner1NameLbl: UILabel!
    @IBOutlet weak var owner2View: UIView!
    @IBOutlet weak var owner2NameLbl: UILabel!
    
    var data: SignupSheet!
    var driverDatas = NSArray()
    var driverItemsDatas = NSArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Custom.cornerView(contentView)
        Custom.fullCornerView(owner1View)
        Custom.fullCornerView(owner2View)
        
    }
    
    func attributedString(str: String) -> NSAttributedString? {
        let attributes = [
            NSUnderlineStyleAttributeName : NSUnderlineStyle.StyleSingle.rawValue
        ]
        let attributedString = NSAttributedString(string: str, attributes: attributes)
        return attributedString
    }
    
    func updateData(data: SignupSheet) {
        
        if data.contact != "" {
            
            contact1Lbl.text = data.contact!
            if data.organizer1PhotoUrl == "https://dsnn35vlkp0h4.cloudfront.net/images/blank_image.gif" {
                owner1View.hidden = false
                owner1NameLbl.hidden = false
                contact1PhotoImgView.hidden = true
                
                let stringArray = data.contact?.componentsSeparatedByString(" ")
                let firstName = stringArray![0]
                let secondName = stringArray![1]
                let resultString = "\(firstName.characters.first!)\(secondName.characters.first!)"
                
                owner1NameLbl.text = resultString
                let color1 = Utility.hexStringToUIColor(data.organizer1BackgroundColor!)
                let color2 = Utility.hexStringToUIColor(data.organizer1TextColor!)
                owner1View.backgroundColor = color1
                owner1NameLbl.textColor = color2
                
                
            }else {
                owner1View.hidden = true
                contact1PhotoImgView.hidden = false
                if let avatarUrl = data.organizer1PhotoUrl {
                    contact1PhotoImgView.setUserAvatar(avatarUrl)
                }
            }
            
        }else {
            contact1PhotoImgView.hidden = true
            owner1View.hidden = true
            owner1NameLbl.hidden = true
            contact1Lbl.hidden = true
        }
        
        if data.contact2 != "" {
            contact2Lbl.text = data.contact2!
            if data.organizer2PhotoUrl == "https://dsnn35vlkp0h4.cloudfront.net/images/blank_image.gif" {
                owner2View.hidden = false
                owner2NameLbl.hidden = false
                contact2PhotoImgView.hidden = true
                
                let stringArray = data.contact2?.componentsSeparatedByString(" ")
                let firstName = stringArray![0]
                let secondName = stringArray![1]
                let resultString = "\(firstName.characters.first!)\(secondName.characters.first!)"
                
                owner2NameLbl.text = resultString
                let color1 = Utility.hexStringToUIColor(data.organizer1BackgroundColor!)
                let color2 = Utility.hexStringToUIColor(data.organizer1TextColor!)
                owner2View.backgroundColor = color1
                owner2NameLbl.textColor = color2
                
            }else {
                owner2View.hidden = true
                contact2PhotoImgView.hidden = false
                if let avatarUrl = data.organizer2PhotoUrl {
                    contact2PhotoImgView.setUserAvatar(avatarUrl)
                }
            }
            
        }else {
            contact2PhotoImgView.hidden = true
            owner2View.hidden = true
            owner2NameLbl.hidden = true
            contact2Lbl.hidden = true
        }
        
        nameLbl.text = data.name
        notesLbl.text = data.notes
        //eventDateLbl.text = ("\(Custom.dayStringFromTime1(data.createDate!))")
        eventTimeLbl.text = ""//data.endTime
        //cutoffDateLbl.text = ("\(Custom.dayStringFromTime1(data.dateTime!))")
        cutoffTimeLbl.text = ""//data.endTime
        
        if data.dateTime == 0 {
            eventDateLbl.text = ""
            
        }else {
            eventDateLbl.text = Custom.dayStringFromTime1(data.dateTime!)
        }
        
        if data.cutoffDate == 0 {
            cutoffDateLbl.text = ""
            
        }else {
            cutoffDateLbl.text = Custom.dayStringFromTime1(data.cutoffDate!)
        }
    }
    
    @IBAction func back(sender: UIButton) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    override func viewWillAppear(animated: Bool) {
        self.fetchDriverItems()
    }
    
    //MARK: Fetch Driver Records
    func fetchDriverItems() {
        let apiName = SignupItems + ("\(data.id!)")
        ActivityIndicator.show()
        
        Alamofire.request(.GET, apiName, headers: appDelegate.loginHeaderCredentials)
            .responseJSON { response in
                if let result = response.result.value {
                    ActivityIndicator.hide()
                    self.driverDatas = (result as? NSArray)!
                    let dic = self.driverDatas.objectAtIndex(0) as? NSDictionary
                    self.updateData(SignupSheet(info: dic))
                    self.driverItemsDatas = (dic?.objectForKey("items")) as! NSArray
                    self.tableView.reloadData()
                }else {
                    ActivityIndicator.hide()
                }
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

//MARK:- TableView
extension SignUpDriverViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.driverItemsDatas.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("SignUpDriversCell") as! SignUpDriversCell
        let data = self.driverItemsDatas[indexPath.row] as? NSDictionary
        //print(Comment(info: data))
        cell.updateView(Items(info: data!))
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let dic = self.driverItemsDatas[indexPath.row] as? NSDictionary
        //let dic = self.driverItemsDatas.objectAtIndex(0) as? NSDictionary
        let data = Items(info: dic!)
        if data.volunteerStatus == "Open" {
            let controller = self.storyboard?.instantiateViewControllerWithIdentifier("DetailsSignUpDriverViewController") as! DetailsSignUpDriverViewController
            controller.selectedItems = data
            controller.sheetData = self.data
            self.navigationController?.pushViewController(controller, animated: true)
        }else if data.volunteerStatus == "Volunteered" {
            let controller = self.storyboard?.instantiateViewControllerWithIdentifier("VolunteeredViewController") as! VolunteeredViewController
            controller.data = data
            controller.sheetData = self.data
            
            self.navigationController?.pushViewController(controller, animated: true)
    
        }else if data.volunteerStatus == "Full" {
            
        }
        
    }
    
}



