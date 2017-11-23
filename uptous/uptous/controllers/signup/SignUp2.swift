//
//  SignUp2.swift
//  uptous
//
//  Created by Roshan on 10/14/17.
//  Copyright © 2017 SPA. All rights reserved.
//

import UIKit

class SignUp2: UIView {

    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var contact1PhotoImgView: UIImageView!
    @IBOutlet weak var contact2PhotoImgView: UIImageView!
    @IBOutlet weak var owner1View: UIView!
    @IBOutlet weak var owner1NameLbl: UILabel!
    @IBOutlet weak var owner2View: UIView!
    @IBOutlet weak var owner2NameLbl: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var contact1Lbl: UILabel!
    @IBOutlet weak var contact2Lbl: UILabel!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var descTableView: UITableView!
    
    var data = appDelegate.globalSignUpData
    
    class func instanceFromNib() -> UIView {
        return UINib(nibName: "SignUp2", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! SignUp2
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
}

//MARK:- TableView
extension SignUp2: UITableViewDelegate, UITableViewDataSource {
    
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


