//
//  OnGoingSignUpsViewController.swift
//  uptous
//
//  Created by Roshan Gita  on 9/21/16.
//  Copyright © 2016 SPA. All rights reserved.
//

import UIKit
import Alamofire

class OnGoingSignUpsViewController: GeneralViewController {

    @IBOutlet weak var commentsTextView: UIView!
    @IBOutlet weak var textField_comments: UITextField!
    @IBOutlet weak var btn_comments: UIButton!
    @IBOutlet var commentsBoxBottomSpacing: NSLayoutConstraint!
    @IBOutlet weak var textView_comments: HPTextViewInternal!
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
    
    
    var placeHolderText = "Type comments here.."
    var isCommentEdit_1_replyEdit_2 : Int?
    var data: SignupSheet!
    
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
    
    func cornerView(contentsView: UIView) ->UIView {
        contentsView.layer.borderColor = UIColor(red: CGFloat(0.8), green: CGFloat(0.8), blue: CGFloat(0.8), alpha: CGFloat(1)).CGColor
        contentsView.layer.borderWidth = CGFloat(1.0)
        contentsView.layer.cornerRadius = 8.0
        
        return contentsView
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
                if let JSON = response.result.value {
                    ActivityIndicator.hide()
                    
                    /*self.commentList = JSON as! NSArray
                     if self.commentList.count > 0 {
                     self.tableView.hidden = false
                     self.tableView.reloadData()
                     }*/
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
extension OnGoingSignUpsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2//self.commentList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("OnGoingCell") as! OnGoingCell
        //let data = commentList[indexPath.row] as? NSDictionary
        //print(Comment(info: data))
        //cell.updateData(Comment(info: data!))
        return cell
    }
    
}

// MARK: - Extensions for UITextView
extension OnGoingSignUpsViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(textView: UITextView) {
        
        textView.selectedRange = NSMakeRange(0, 0)
        if textView.textColor == UIColor.lightGrayColor() && textView.text != placeHolderText && isCommentEdit_1_replyEdit_2 == 0{
            textView.text = nil
            textView.textColor = UIColor.blackColor()
        }
        else{
            
        }
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = placeHolderText
            textView.textColor = UIColor.lightGrayColor()
        }
    }
    
    func textViewDidChange(textView: UITextView) {
        //self.textView_comments.textViewDidChange(textView)
    }
    
    func textViewShouldBeginEditing(textView: UITextView) -> Bool {
        
        if textView.text == "Add caption tag another user with @username..." {
            textView.text = nil
        }
        return true
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        
        if textView.textColor == UIColor.lightGrayColor() && textView.text == placeHolderText {
            textView.text = nil
            textView.textColor = UIColor.blackColor()
        }
        if text == "" && textView_comments.text.characters.count == 1 && textView.textColor == UIColor.blackColor(){
            textView.text = placeHolderText
            textView.textColor = UIColor.lightGrayColor()
            textView.selectedRange = NSMakeRange(0, 0)
        }
        if text == "\n" {
        }
        
        let totalText = textView.text + text
        
        if totalText.characters.count > 0 && totalText != placeHolderText {
            //btn_comments.setImage(UIImage(named: "chat_send"), forState: .Normal)
        }
        else{
            //btn_comments.setImage(UIImage(named: "chat_send_gray"), forState: .Normal)
        }
        
        return true
    }
    
}



