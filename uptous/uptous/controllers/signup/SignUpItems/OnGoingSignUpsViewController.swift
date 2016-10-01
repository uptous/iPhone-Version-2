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
    @IBOutlet weak var contact1IdentifierView: GroupIdentifierView!
    @IBOutlet weak var contact2PhotoImgView: CircularImageView!
    @IBOutlet weak var contact2IdentifierView: GroupIdentifierView!
    
    
    var placeHolderText = "Type comments here.."
    var isCommentEdit_1_replyEdit_2 : Int?
    var data: SignupSheet!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        cornerView(contentView)
        updateData(data)
    }
    
    func updateData(data: SignupSheet) {
        
        /*if data.ownerPhotoUrl == "https://dsnn35vlkp0h4.cloudfront.net/images/blank_image.gif" {
         identifierView.hidden = false
         ownerPhotoImgView.hidden = true
         let stringArray = data.ownerName?.componentsSeparatedByString(" ")
         let firstName = stringArray![0]
         let secondName = stringArray![1]
         
         let resultString = "\(firstName.characters.first!)\(secondName.characters.first!)"
         
         identifierView.abbrLabel.text = resultString
         let color1 = Utility.hexStringToUIColor(data.ownerBackgroundColor!)
         let color2 = Utility.hexStringToUIColor(data.ownerTextColor!)
         identifierView.abbrLabel.textColor = color2
         identifierView.backgroundLayerColor = color1
         
         }else {
         identifierView.hidden = true
         ownerPhotoImgView.hidden = false
         if let avatarUrl = data.ownerPhotoUrl {
         ownerPhotoImgView.setUserAvatar(avatarUrl)
         }
         }*/
        
        //        if let newsItemPhotoUrl = data.newsItemPhoto {
        //            CustomImgView.setUserAvatar(newsItemPhotoUrl,imgView: newsItemPhotoImgView)
        //        }
        
        
        if data.contact != "" {
            contact1PhotoImgView.hidden = false
            contact1IdentifierView.hidden = false
            contact1Lbl.hidden = false
            contact1Lbl.text = data.contact
            
        }else {
            contact1PhotoImgView.hidden = true
            contact1IdentifierView.hidden = true
            contact1Lbl.hidden = true
        }
        
        if data.contact2 != "" {
            contact2PhotoImgView.hidden = false
            contact2IdentifierView.hidden = false
            contact2Lbl.hidden = false
            contact2Lbl.text = data.contact2
            
            
        }else {
            contact2PhotoImgView.hidden = true
            contact2IdentifierView.hidden = true
            contact2Lbl.hidden = true
        }
        
        nameLbl.text = data.name
        notesLbl.text = data.notes
        eventDateLbl.text = ("\(Custom.dayStringFromTime1(data.createDate!))")
        eventTimeLbl.text = data.endTime
        cutoffDateLbl.text = ("\(Custom.dayStringFromTime1(data.createDate!))")
        cutoffTimeLbl.text = data.endTime
        
        //newsItemDescriptionLbl.text = data.newsItemDescription!.decodeHTML()
        //dateLbl.text = ("\(Custom.dayStringFromTime(data.createDate!))")
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



