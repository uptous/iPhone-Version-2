//
//  SignUpType3ViewController.swift
//  uptous
//
//  Created by Roshan on 11/9/17.
//  Copyright © 2017 SPA. All rights reserved.
//

import UIKit

class SignUpType3ViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var contact1Lbl: UILabel!
    @IBOutlet weak var contact2Lbl: UILabel!
    @IBOutlet weak var eventDateLbl: UILabel!
    @IBOutlet weak var eventTimeLbl: UILabel!
    @IBOutlet weak var cutoffDateLbl: UILabel!
    @IBOutlet weak var cutoffTimeLbl: UILabel!
    @IBOutlet weak var contact1PhotoImgView: UIImageView!
    @IBOutlet weak var contact2PhotoImgView: UIImageView!
    @IBOutlet weak var owner1View: UIView!
    @IBOutlet weak var owner1NameLbl: UILabel!
    @IBOutlet weak var owner2View: UIView!
    @IBOutlet weak var owner2NameLbl: UILabel!
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
        super.viewDidLoad()
        descTableView.estimatedRowHeight = 95
        descTableView.rowHeight = UITableViewAutomaticDimension
        itemTableView.estimatedRowHeight = 95
        itemTableView.rowHeight = UITableViewAutomaticDimension
    }
    
    func updateData(_ data: SignupSheet)  {
        self.data = data
        /*if let note = data.notes {
            let font = UIFont(name: "Helvetica", size: 14.0)
            //descLabel.text = data!.notes!
            let height = heightForView(text: note, font: font!, width: descTableView.frame.size.width)
            if height < 20 {
                textHeightConstraint.constant = 270 + 10//CGFloat(height)
            }else if height < 70{
                textHeightConstraint.constant = 270 + 20
            }else if height < 100{
                textHeightConstraint.constant = 270 + 40
            }else {
                textHeightConstraint.constant = 270 + 75//CGFloat(height)
            }
        }else {
            textHeightConstraint.constant = 250
        }*/
        if (data.notes?.characters.count)! > 0 {
            //descTableView.isHidden = false
            let font = UIFont(name: "Helvetica", size: 14.0)
            //descLabel.text = data!.notes!
            let height = heightForView(text: data.notes!, font: font!, width: descTableView.frame.size.width)
            if height < 20 {
                textHeightConstraint.constant = 270 + 10//CGFloat(height)
            }else if height < 70{
                textHeightConstraint.constant = 270 + 20
            }else if height < 100{
                textHeightConstraint.constant = 270 + 40
            }else {
                textHeightConstraint.constant = 270 + 75//CGFloat(height)
            }
            
        }else {
            textHeightConstraint.constant = 250
        }
        descTableView.reloadData()
        
        viewHeightConstraint.constant = textHeightConstraint.constant
        self.view.layoutIfNeeded()
        mainView.layoutIfNeeded()
        
        Custom.cornerView(contentView)
        Custom.fullCornerView1(owner1View)
        Custom.fullCornerView1(owner2View)
        contact1PhotoImgView.layer.cornerRadius = 25.0
        contact1PhotoImgView.layer.masksToBounds = true
        
        contact2PhotoImgView.layer.cornerRadius = 25.0
        contact2PhotoImgView.layer.masksToBounds = true
        
        //titleLbl.text = data?.name
        
        
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
        
        //For Organizer
        if data.contact != "" {
            
            contact1Lbl.text = data.contact!
            if data.organizer1PhotoUrl == "https://dsnn35vlkp0h4.cloudfront.net/images/blank_image.gif"  || data.organizer1PhotoUrl == ""{
                owner1View.isHidden = false
                owner1NameLbl.isHidden = false
                contact1PhotoImgView.isHidden = true
                
                let stringArray = data.contact?.components(separatedBy: " ")
                if stringArray?.count == 1 {
                    let firstName = stringArray![0]
                    //let secondName = stringArray![1] ?? ""
                    let resultString = "\(firstName.characters.first!)"
                    owner1NameLbl.text = resultString
                }else {
                    let firstName = stringArray![0]
                    let secondName = stringArray![1]
                    let resultString = "\(firstName.characters.first!)\(secondName.characters.first!)"
                    owner1NameLbl.text = resultString
                }
                
                
                
                
                let color1 = Utility.hexStringToUIColor(hex: data.organizer1BackgroundColor!)
                let color2 = Utility.hexStringToUIColor(hex: data.organizer1TextColor!)
                owner1View.backgroundColor = color1
                owner1NameLbl.textColor = color2
                
            }else {
                owner1View.isHidden = true
                contact1PhotoImgView.isHidden = false
                if let avatarUrl = data.organizer1PhotoUrl {
                    contact2PhotoImgView.isHidden = false
                    let block: SDWebImageCompletionBlock = {(image: UIImage?, error: Error?, cacheType: SDImageCacheType!, imageURL: URL?) -> Void in
                        self.contact1PhotoImgView.image = image
                    }
                    contact1PhotoImgView.sd_setImage(with: URL(string:avatarUrl) as URL!, completed:block)
                }
            }
        }else {
            contact1PhotoImgView.isHidden = true
            owner1View.isHidden = true
            owner1NameLbl.isHidden = true
            contact1Lbl.isHidden = true
        }
        
        if data.contact2 != "" {
            contact2Lbl.text = data.contact2
            if data.organizer2PhotoUrl == "https://dsnn35vlkp0h4.cloudfront.net/images/blank_image.gif" || data.organizer2PhotoUrl == "" {
                owner2View.isHidden = false
                owner2NameLbl.isHidden = false
                contact2PhotoImgView.isHidden = true
                
                let stringArray = data.contact2?.components(separatedBy: " ")
                let firstName = stringArray![0]
                let secondName = stringArray![1]
                let resultString = "\(firstName.characters.first!)\(secondName.characters.first!)"
                
                owner2NameLbl.text = resultString
                let color1 = Utility.hexStringToUIColor(hex: data.organizer1BackgroundColor!)
                let color2 = Utility.hexStringToUIColor(hex: data.organizer1TextColor!)
                owner2View.backgroundColor = color1
                owner2NameLbl.textColor = color2
                
            }else {
                owner2View.isHidden = true
                contact2PhotoImgView.isHidden = false
                if let avatarUrl = data.organizer2PhotoUrl {
                    contact2PhotoImgView.isHidden = false
                    //ownerPhotoImgView.setUserAvatar(avatarUrl)
                    let block: SDWebImageCompletionBlock = {(image: UIImage?, error: Error?, cacheType: SDImageCacheType!, imageURL: URL?) -> Void in
                        self.contact2PhotoImgView.image = image
                    }
                    contact2PhotoImgView.sd_setImage(with: URL(string:avatarUrl) as URL!, completed:block)
                }
            }
        }else {
            contact2PhotoImgView.isHidden = true
            owner2View.isHidden = true
            owner2NameLbl.isHidden = true
            contact2Lbl.isHidden = true
        }
        
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
    
    @IBAction func back(_ sender: UIButton) {
        //self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
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
            
            let alert = UIAlertController(title: "Alert", message: "Error", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Try Again", style: UIAlertActionStyle.default, handler: nil))
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
                if item.volunteerStatus == "Open" {
                    let controller = self.storyboard?.instantiateViewController(withIdentifier: "DetailsSignUpDriverViewController") as! DetailsSignUpDriverViewController
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







