//
//  SignUpType1ViewController.swift
//  uptous
//
//  Created by Roshan on 11/9/17.
//  Copyright © 2017 UpToUs. All rights reserved.
//

import UIKit

class SignUpType1ViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var eventDateLbl: UILabel!
    @IBOutlet weak var eventTimeLbl: UILabel!
    @IBOutlet weak var cutoffDateLbl: UILabel!
    @IBOutlet weak var cutoffTimeLbl: UILabel!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var itemTableView: UITableView!
    @IBOutlet weak var descTableView: UITableView!
    
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var textHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var viewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var mainView: UIView!
    
    var data: SignupSheet!
    var data1: Feed!
    var driverDatas = NSArray()
    var itemsDatas = NSArray()
    var signUpType = ""
    var rsvpTypeFromFeed = ""
    
    
    override func viewDidLoad() {
        print ("Type1 Volunteer: viewDidLoad")
        super.viewDidLoad()
        _ = Custom.cornerView(contentView)
        descTableView.estimatedRowHeight = 95
        descTableView.rowHeight = UITableView.automaticDimension
        
        itemTableView.estimatedRowHeight = 95
        itemTableView.rowHeight = UITableView.automaticDimension
    }
    
    func updateData(_ data: SignupSheet) {
        self.data = data
        let notesLength = data.notes?.count ?? 0
        print("Notes Length: " + String(notesLength))
        let notesHeight = 150.0 + Double(notesLength / 2)
        contentView.updateConstraint(attribute: NSLayoutConstraint.Attribute.height, constant: CGFloat(notesHeight))
        
        self.view.layoutIfNeeded()
        mainView.layoutIfNeeded()
        descTableView.reloadData()
        
        //For Event Date and Time
        if data.dateTime == 0 {
            eventTimeLbl.text = ""
        }else {
            eventDateLbl.text = Custom.dayStringFromTime1(data.dateTime!)
            
            if data.endTime == "" || data.endTime == "1:00AM" {
                if Custom.dayStringFromTime4(data.dateTime!) != "1:00AM" {
                    eventTimeLbl.text = "\(Custom.dayStringFromTime4(data.dateTime!))"
                }
            }else {
                if Custom.dayStringFromTime4(data.dateTime!) != "1:00AM" {
                    eventTimeLbl.text = "\(Custom.dayStringFromTime4(data.dateTime!)) - " + "" + "\(data.endTime!)"
                }
            }
        }
        //For Cuttoff Date and Time
        if data.cutoffDate == 0 {
            cutoffDateLbl.text = ""
        }else {
            cutoffDateLbl.text = Custom.dayStringFromTime1(data.cutoffDate!)
        }
    }

    //func heightForView(text:String, font:UIFont, width:CGFloat) -> CGFloat{
    //    let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: //CGFloat.greatestFiniteMagnitude))
        //label.numberOfLines = 0
        //label.lineBreakMode = NSLineBreakMode.byWordWrapping
        //label.font = font
        //label.text = text
        //label.sizeToFit()
        
        //return label.frame.height
    //}
    
    @IBAction func back(_ sender: UIButton) {
        //self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print ("Type1 Volunteer: viewWillAppear")
        let when = DispatchTime.now() + 1 // change 2 to desired number of seconds
        DispatchQueue.main.asyncAfter(deadline: when) {
            self.fetchSignUpItems()
        }
    }
    
    
    func fetchSignUpItems() {
        let apiName: String!
        if data1 != nil {
            apiName = SignupItems + ("\(data1.newsItemId!)")
        }else {
            apiName = SignupItems + ("\(data.id!)")
        }
        
        DataConnectionManager.requestGETURL(api: apiName, para: ["":""], success: {
            (response) -> Void in
            self.driverDatas = (response as? NSArray)!
            let dic = self.driverDatas.object(at: 0) as? NSDictionary
            self.updateData(SignupSheet(info: dic))
            self.itemsDatas = (dic?.object(forKey: "items")) as! NSArray
            self.itemTableView.reloadData()
        }) {
            (error) -> Void in
            
            let alert = UIAlertController(title: "Alert", message: "Error", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Try Again", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    //MARK:- UITableView
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == itemTableView {
            return self.itemsDatas.count
        }
        return 1
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        if tableView == itemTableView {
            if signUpType == "101" {
                let cell = tableView.dequeueReusableCell(withIdentifier: "VolunteerwCell") as! VolunteerwCell
                let data = self.itemsDatas[(indexPath as NSIndexPath).row] as? NSDictionary
                cell.updateView(Items(info: data!))
                cell.setNeedsUpdateConstraints()
                cell.updateConstraintsIfNeeded()
                return cell
                
            }else if signUpType == "100" {
                let cell = tableView.dequeueReusableCell(withIdentifier: "ShiftCell") as! ShiftCell
                let data = self.itemsDatas[(indexPath as NSIndexPath).row] as? NSDictionary
                cell.updateView(Items(info: data!))
                return cell
                
            }else if signUpType == "102" {
                let cell = tableView.dequeueReusableCell(withIdentifier: "RSVPCell") as! RSVPCell
                let data = itemsDatas[(indexPath as NSIndexPath).row] as? NSDictionary
                cell.updateView(Items(info: data!))
                return cell
                
            }else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "SignUpDriversCell") as! SignUpDriversCell
                let data = self.itemsDatas[(indexPath as NSIndexPath).row] as? NSDictionary
                cell.updateView(Items(info: data!))
                return cell
            }
            
        }else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! SignUpDescCell
            //let data = self.itemsDatas[(indexPath as NSIndexPath).row] as? NSDictionary
            //cell.updateView(Items(info: data!))
            cell.descLbl.text = self.data?.notes
            cell.titleLbl.text = self.data?.name
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == itemTableView {
            let dic = self.itemsDatas[(indexPath as NSIndexPath).row] as? NSDictionary
            let item = Items(info: dic!)
            
            if signUpType == "100" || signUpType == "101" {
                if item.volunteerStatus == "Open" {
                    let controller = self.storyboard?.instantiateViewController(withIdentifier: "ItemDetailsEditingMsgViewController") as! ItemDetailsEditingMsgViewController
                    controller.modalPresentationStyle = UIModalPresentationStyle.currentContext
                    controller.selectedItems = item
                    if data1 != nil {
                        controller.sheetDataID = ("\(data1.newsItemId!)")
                    }else {
                        controller.sheetDataID = ("\(self.data.id!)")
                    }
                    self.present(controller, animated: true, completion: nil)
                    //self.navigationController?.pushViewController(controller, animated: true)
                    
                }else if item.volunteerStatus == "Volunteered" || item.volunteerStatus == "Full"{
                    let controller = self.storyboard?.instantiateViewController(withIdentifier: "ReadOnlyCommentViewController") as! ReadOnlyCommentViewController
                    controller.modalPresentationStyle = UIModalPresentationStyle.currentContext
                    controller.selectedItems = item
                    if data1 != nil {
                        controller.sheetDataID = ("\(data1.newsItemId!)")
                    }else {
                        controller.sheetDataID = ("\(data.id!)")
                    }
                    self.present(controller, animated: true, completion: nil)
                }
            }else if signUpType == "102" {
                if item.volunteerStatus == "Open" {
                    let controller = self.storyboard?.instantiateViewController(withIdentifier: "OpenRSVPViewController") as! OpenRSVPViewController
                    controller.modalPresentationStyle = UIModalPresentationStyle.currentContext
                    controller.itemData = Items(info: dic)
                    if data1 != nil {
                        controller.rsvpType = rsvpTypeFromFeed
                        controller.sheetDataID = ("\(data1.newsItemId!)")
                    }else {
                        controller.rsvpType = self.data.type
                        controller.sheetDataID = ("\(self.data.id!)")
                    }
                    self.present(controller, animated: true, completion: nil)
                    //self.navigationController?.pushViewController(controller, animated: true)
                }else if item.volunteerStatus == "Volunteered" {
                    let controller = self.storyboard?.instantiateViewController(withIdentifier: "RSVPVolunteerViewController") as! RSVPVolunteerViewController
                    controller.modalPresentationStyle = UIModalPresentationStyle.currentContext
                    if data1 != nil {
                        controller.rsvpType = rsvpTypeFromFeed
                        controller.sheetDataID = ("\(data1.newsItemId!)")
                    }else {
                        controller.rsvpType = self.data.type
                        controller.sheetDataID = ("\(self.data.id!)")
                    }
                    controller.data = item
                    self.present(controller, animated: true, completion: nil)
                    //self.navigationController?.pushViewController(controller, animated: true)
                    
                }else if item.volunteerStatus == "Full" {
                }
            }else if signUpType == "103" {
                print("Type1 Signup - displatching Driver Item")
                if item.volunteerStatus == "Open" {
                    let controller = self.storyboard?.instantiateViewController(withIdentifier: "DetailsSignUpDriverViewController") as! DetailsSignUpDriverViewController
                    controller.modalPresentationStyle = UIModalPresentationStyle.currentContext
                    controller.selectedItems = item
                    if data1 != nil {
                        controller.sheetDataID = ("\(data1.newsItemId!)")
                    }else {
                        controller.sheetDataID = ("\(self.data.id!)")
                    }
                    self.present(controller, animated: true, completion: nil)
                    //self.navigationController?.pushViewController(controller, animated: true)
                }else if item.volunteerStatus == "Volunteered" {
                    let controller = self.storyboard?.instantiateViewController(withIdentifier: "VolunteeredViewController") as! VolunteeredViewController
                    controller.modalPresentationStyle = UIModalPresentationStyle.currentContext
                    if data1 != nil {
                        controller.sheetDataID = ("\(data1.newsItemId!)")
                    }else {
                        controller.sheetDataID = ("\(self.data.id!)")
                    }
                    controller.data = item
                    self.present(controller, animated: true, completion: nil)
                    //self.navigationController?.pushViewController(controller, animated: true)
                    
                }else if item.volunteerStatus == "Full" {
                    
                }
            }
            
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension UIView {

    func updateConstraint(attribute: NSLayoutConstraint.Attribute, constant: CGFloat) -> Void {
        if let constraint = (self.constraints.filter{$0.firstAttribute == attribute}.first) {
            constraint.constant = constant
            self.layoutIfNeeded()
        }
    }
}







