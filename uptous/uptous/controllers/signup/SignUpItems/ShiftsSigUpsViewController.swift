  //
//  ShiftsSigUpsViewController.swift
//  uptous
//
//  Created by Roshan Gita  on 9/21/16.
//  Copyright © 2016 SPA. All rights reserved.
//

import UIKit
import Alamofire


class ShiftsSigUpsViewController:  GeneralViewController {
    
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
    @IBOutlet weak var contact1PhotoImgView: UIImageView!
    @IBOutlet weak var contact2PhotoImgView: UIImageView!
    @IBOutlet weak var owner1View: UIView!
    @IBOutlet weak var owner1NameLbl: UILabel!
    @IBOutlet weak var owner2View: UIView!
    @IBOutlet weak var owner2NameLbl: UILabel!
    @IBOutlet weak var detailHeightContraint: NSLayoutConstraint!
    @IBOutlet weak var detailViewHeightContraint: NSLayoutConstraint!
    @IBOutlet weak var organizerViewYContraint: NSLayoutConstraint!
    @IBOutlet weak var eventViewYContraint: NSLayoutConstraint!
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var organizerView: UIView!
    @IBOutlet weak var organizerLbl: UILabel!

    
    var data: SignupSheet!
    var data1: Feed!
    var driverDatas = NSArray()
    var itemsDatas = NSArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = 81
        tableView.rowHeight = UITableViewAutomaticDimension
        Custom.cornerView(contentView)
        Custom.fullCornerView1(owner1View)
        Custom.fullCornerView1(owner2View)
        
        contact1PhotoImgView.layer.cornerRadius = 25.0
        contact1PhotoImgView.layer.masksToBounds = true
        
        contact2PhotoImgView.layer.cornerRadius = 25.0
        contact2PhotoImgView.layer.masksToBounds = true

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
    
    func attributedString(_ str: String) -> NSAttributedString? {
        let attributes = [
            NSUnderlineStyleAttributeName : NSUnderlineStyle.styleSingle.rawValue
        ]
        let attributedString = NSAttributedString(string: str, attributes: attributes)
        return attributedString
    }
    
    func updateData(_ data: SignupSheet) {
        
        if data.contact != "" {
            
            contact1Lbl.text = data.contact!
            if data.organizer1PhotoUrl == "https://dsnn35vlkp0h4.cloudfront.net/images/blank_image.gif" {
                owner1View.isHidden = false
                owner1NameLbl.isHidden = false
                contact1PhotoImgView.isHidden = true
                
                let stringArray = data.contact?.components(separatedBy: " ")
                let firstName = stringArray![0]
                let secondName = stringArray![1]
                let resultString = "\(firstName.characters.first!)\(secondName.characters.first!)"
                
                owner1NameLbl.text = resultString
                let color1 = Utility.hexStringToUIColor(hex: data.organizer1BackgroundColor!)
                let color2 = Utility.hexStringToUIColor(hex: data.organizer1TextColor!)
                owner1View.backgroundColor = color1
                owner1NameLbl.textColor = color2
                
            }else {
                owner1View.isHidden = true
                contact1PhotoImgView.isHidden = false
                if let avatarUrl = data.organizer1PhotoUrl {
                    contact1PhotoImgView.isHidden = false
                    //ownerPhotoImgView.setUserAvatar(avatarUrl)
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
            contact2Lbl.text = data.contact2!
            if data.organizer2PhotoUrl == "https://dsnn35vlkp0h4.cloudfront.net/images/blank_image.gif" {
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
        
        nameLbl.text = data.name
        //notesLbl.text = data.notes
        DispatchQueue.main.async(execute: {
            self.webView.loadHTMLString(data.notes!,baseURL: nil)
        })
        print(calculateHeight(data.notes!, width: webView.frame.size.width))
        print(detailHeightContraint.constant)
        if calculateHeight(data.notes!, width: webView.frame.size.width) > 38 {
            detailHeightContraint.constant = 70
            //detailViewHeightContraint.constant = 288
        }
        
        if data.contact == "" && data.contact2 == "" {
            organizerView.isHidden = true
            organizerLbl.text = ""
            organizerViewYContraint.constant = 0.0
            print(detailHeightContraint.constant)
            //detailHeightContraint.constant = 100
            //eventViewYContraint.constant = detailHeightContraint.constant + 2.0
            //print(eventViewYContraint.constant)
            detailViewHeightContraint.constant = detailHeightContraint.constant + 90.0
            print(detailViewHeightContraint.constant)
        }else {
            organizerView.isHidden = false
            organizerLbl.text = "Organizers:"
            //organizerViewYContraint.constant = detailHeightContraint.constant + 2.0
            eventViewYContraint.constant = 107.0
            detailViewHeightContraint.constant = detailHeightContraint.constant + 92.5 + 105.0
        }
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
        
        //newsItemDescriptionLbl.text = data.newsItemDescription!.decodeHTML()
        //dateLbl.text = ("\(Custom.dayStringFromTime(data.createDate!))")
    }
    
    
    @IBAction func back(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let when = DispatchTime.now() + 1 // change 2 to desired number of seconds
        DispatchQueue.main.asyncAfter(deadline: when) {
            self.fetchItems()
        }
    }
    
        
    //MARK: Fetch Records
    func fetchItems() {
        let apiName: String!
        if data1 != nil {
            apiName = SignupItems + ("\(data1.newsItemId!)")
        }else {
            apiName = SignupItems + ("\(data.id!)")
        }

        DataConnectionManager.requestGETURL(api: apiName, para: ["":""], success: {
            (response) -> Void in
            print(response)
            
            self.driverDatas = (response as? NSArray)!
            let dic = self.driverDatas.object(at: 0) as? NSDictionary
            self.updateData(SignupSheet(info: dic))
            self.itemsDatas = (dic?.object(forKey: "items")) as! NSArray
            
            self.tableView.reloadData()
            
        }) {
            (error) -> Void in
            
            let alert = UIAlertController(title: "Alert", message: "Error", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Try Again", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

//MARK:- TableView
extension ShiftsSigUpsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    /*func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }*/
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.itemsDatas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ShiftCell") as! ShiftCell
        let data = self.itemsDatas[(indexPath as NSIndexPath).row] as? NSDictionary
        //print(Comment(info: data))
        cell.updateView(Items(info: data!))
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let dic = self.itemsDatas[(indexPath as NSIndexPath).row] as? NSDictionary
        print(dic?.object(forKey: "volunteers"))
        let item = Items(info: dic!)
        if item.volunteerStatus == "Open" {
            let controller = self.storyboard?.instantiateViewController(withIdentifier: "ItemDetailsEditingMsgViewController") as! ItemDetailsEditingMsgViewController
            controller.selectedItems = item
            //controller.data = self.data
            if data1 != nil {
                controller.sheetDataID = ("\(data1.newsItemId!)")
            }else {
                controller.sheetDataID = ("\(data.id!)")
            }
            self.navigationController?.pushViewController(controller, animated: true)
            
        }else if item.volunteerStatus == "Volunteered" || item.volunteerStatus == "Full"{
            let controller = self.storyboard?.instantiateViewController(withIdentifier: "ReadOnlyCommentViewController") as! ReadOnlyCommentViewController
            controller.selectedItems = item
            //controller.data = self.data
            if data1 != nil {
                controller.sheetDataID = ("\(data1.newsItemId!)")
            }else {
                controller.sheetDataID = ("\(data.id!)")
            }
            
            self.navigationController?.pushViewController(controller, animated: true)
            
        }
    }

    
}



