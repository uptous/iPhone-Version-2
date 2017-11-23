//
//  SignUpType2ViewController.swift
//  uptous
//
//  Created by Roshan on 11/9/17.
//  Copyright © 2017 SPA. All rights reserved.
//

import UIKit

class SignUpType2ViewController: UIViewController {

    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var contact1PhotoImgView: UIImageView!
    @IBOutlet weak var contact2PhotoImgView: UIImageView!
    @IBOutlet weak var owner1View: UIView!
    @IBOutlet weak var owner1NameLbl: UILabel!
    @IBOutlet weak var owner2View: UIView!
    @IBOutlet weak var owner2NameLbl: UILabel!
    @IBOutlet weak var contact1Lbl: UILabel!
    @IBOutlet weak var contact2Lbl: UILabel!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var itemTableView: UITableView!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var textHeightConstraint: NSLayoutConstraint!
    
    var data: SignupSheet!
    var data1: Feed!
    var driverDatas = NSArray()
    var itemsDatas = NSArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()        
        let font = UIFont(name: "Helvetica", size: 14.0)
        descLabel.text = data!.notes!
        let height = heightForView(text: data!.notes!, font: font!, width: descLabel.frame.size.width)
        textHeightConstraint.constant = 150 + CGFloat(height)
        self.view.layoutIfNeeded()
        
        Custom.cornerView(contentView)
        Custom.fullCornerView1(owner1View)
        Custom.fullCornerView1(owner2View)
        contact1PhotoImgView.layer.cornerRadius = 25.0
        contact1PhotoImgView.layer.masksToBounds = true
        
        contact2PhotoImgView.layer.cornerRadius = 25.0
        contact2PhotoImgView.layer.masksToBounds = true
        titleLbl.text = data?.name
        
        if data!.contact != "" {
            
            contact1Lbl.text = data!.contact!
            if data!.organizer1PhotoUrl == "https://dsnn35vlkp0h4.cloudfront.net/images/blank_image.gif"  || data!.organizer1PhotoUrl == "" {
                owner1View.isHidden = false
                owner1NameLbl.isHidden = false
                contact1PhotoImgView.isHidden = true
                
                let stringArray = data!.contact?.components(separatedBy: " ")
                let firstName = stringArray![0]
                let secondName = stringArray![1]
                let resultString = "\(firstName.characters.first!)\(secondName.characters.first!)"
                
                owner1NameLbl.text = resultString
                let color1 = Utility.hexStringToUIColor(hex: data!.organizer1BackgroundColor!)
                let color2 = Utility.hexStringToUIColor(hex: data!.organizer1TextColor!)
                owner1View.backgroundColor = color1
                owner1NameLbl.textColor = color2
                
            }else {
                owner1View.isHidden = true
                contact1PhotoImgView.isHidden = false
                if let avatarUrl = data!.organizer1PhotoUrl {
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
        
        if data!.contact2 != "" {
            contact2Lbl.text = data!.contact2
            if data!.organizer2PhotoUrl == "https://dsnn35vlkp0h4.cloudfront.net/images/blank_image.gif"  || data!.organizer2PhotoUrl == "" {
                owner2View.isHidden = false
                owner2NameLbl.isHidden = false
                contact2PhotoImgView.isHidden = true
                
                let stringArray = data!.contact2?.components(separatedBy: " ")
                let firstName = stringArray![0]
                let secondName = stringArray![1]
                let resultString = "\(firstName.characters.first!)\(secondName.characters.first!)"
                
                owner2NameLbl.text = resultString
                let color1 = Utility.hexStringToUIColor(hex: data!.organizer1BackgroundColor!)
                let color2 = Utility.hexStringToUIColor(hex: data!.organizer1TextColor!)
                owner2View.backgroundColor = color1
                owner2NameLbl.textColor = color2
                
            }else {
                owner2View.isHidden = true
                contact2PhotoImgView.isHidden = false
                if let avatarUrl = data!.organizer2PhotoUrl {
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
        self.navigationController?.popViewController(animated: true)
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
            //self.updateData(SignupSheet(info: dic))
            self.itemsDatas = (dic?.object(forKey: "items")) as! NSArray
            self.itemTableView.reloadData()
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
extension SignUpType2ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.itemsDatas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "VolunteerwCell") as! VolunteerwCell
        let data = self.itemsDatas[(indexPath as NSIndexPath).row] as? NSDictionary
        cell.updateView(Items(info: data!))
        cell.setNeedsUpdateConstraints()
        cell.updateConstraintsIfNeeded()
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let dic = self.itemsDatas[(indexPath as NSIndexPath).row] as? NSDictionary
        let item = Items(info: dic!)
        if item.volunteerStatus == "Open" {
            let controller = self.storyboard?.instantiateViewController(withIdentifier: "ItemDetailsEditingMsgViewController") as! ItemDetailsEditingMsgViewController
            controller.selectedItems = item
            if data1 != nil {
                controller.sheetDataID = ("\(data1.newsItemId!)")
            }else {
                controller.sheetDataID = ("\(self.data.id!)")
            }
            self.navigationController?.pushViewController(controller, animated: true)
            
        }else if item.volunteerStatus == "Volunteered" || item.volunteerStatus == "Full"{
            let controller = self.storyboard?.instantiateViewController(withIdentifier: "ReadOnlyCommentViewController") as! ReadOnlyCommentViewController
            controller.selectedItems = item
            if data1 != nil {
                controller.sheetDataID = ("\(data1.newsItemId!)")
            }else {
                controller.sheetDataID = ("\(data.id!)")
            }
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
}






