//
//  OpenRSVPViewController.swift
//  uptous
//
//  Created by Roshan Gita  on 10/2/16.
//  Copyright © 2016 SPA. All rights reserved.
//

import UIKit
import Alamofire


class OpenRSVPViewController: GeneralViewController {

    @IBOutlet weak var headingLbl: UILabel!
    @IBOutlet weak var rsvpLbl: UILabel!
    @IBOutlet weak var dateTimeLbl: UILabel!
    @IBOutlet weak var attendeesTxtField: UITextField!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var commentsTextView: UIView!
    @IBOutlet weak var textField_comments: UITextField!
    @IBOutlet weak var btn_comments: UIButton!
    @IBOutlet var commentsBoxBottomSpacing: NSLayoutConstraint!
    @IBOutlet weak var textView_comments: HPTextViewInternal!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var gifImageView: UIImageView!
    
    var volunteerData = NSArray()
    var sheetData: SignupSheet!
    var itemData: Items!
    var scrollToTop = false
    var offset = 0
    var placeHolderText = "Type comments here.."
    var isCommentEdit_1_replyEdit_2 : Int?
    var list = NSArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Custom.buttonCorner(cancelButton)
        self.headingLbl.text = ("Join the \(sheetData.name!)")
        self.rsvpLbl.text = "Yeah! You have just RSVP'd as joining the party!"
        self.dateTimeLbl.text = ("\(Custom.dayStringFromTime1(sheetData.createDate!))")
        
        //attendeesTxtField.text = data.volunteers![0].objectForKey("phone") as? String ?? ""
        
        textView_comments.placeholder = placeHolderText
        textView_comments.text = placeHolderText
        textView_comments.textColor = UIColor.lightGrayColor()
        textField_comments.placeholder = "Type comments here.."
        // Observer Keyboard
        let center: NSNotificationCenter = NSNotificationCenter.defaultCenter()
        center.addObserver(self, selector: #selector(OpenRSVPViewController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        center.addObserver(self, selector: #selector(OpenRSVPViewController.keyboardWillHide(_:)), name: UIKeyboardDidHideNotification, object: nil)
        center.addObserver(self, selector: #selector(OpenRSVPViewController.keyboardDidChangeFrame(_:)), name: UIKeyboardDidChangeFrameNotification, object: nil)
        
        let tapRecognizer = UITapGestureRecognizer(target: self , action: #selector(OpenRSVPViewController.HideTextKeyboard(_:)))
        tableView.addGestureRecognizer(tapRecognizer)
        
        let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(1 * Double(NSEC_PER_SEC)))
         dispatch_after(delayTime, dispatch_get_main_queue()) {
            //self.updateData(self.data)
            //self.fetchItems()
         }
        
        let imageData = NSData(contentsOfURL: NSBundle.mainBundle().URLForResource("smiley_test", withExtension: "gif")!)
        let advTimeGif = UIImage.gifImageWithData(imageData!)
        gifImageView.image = advTimeGif
        
        print(self.itemData.volunteers!)
        print(self.itemData.volunteers!.count)
        self.volunteerData = self.itemData.volunteers!
        self.tableView.reloadData()
    }
    
    override func viewWillAppear(animated: Bool) {
        //self.tableView.hidden = true
        tableView.estimatedRowHeight = 110
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    //Post Comment
    func postComment(msg: String,attendees: String) {
        //let opportunityID = result.objectForKey("id") as? String
        let apiName = SignupItems + ("\(sheetData.id!)") + ("/item/\(itemData.Id!)/Add")
        ActivityIndicator.show()
        
        let parameters = ["comment": msg,"numberOfAttendees": attendees]
        
        Alamofire.request(.POST, apiName, headers: appDelegate.loginHeaderCredentials,parameters: parameters)
            .responseJSON { response in
                ActivityIndicator.hide()
                //if self.commentList.count > 0 {
                self.fetchItems()
                //}
        }
    }
    
    //Fetch Comment
    func fetchItems() {
        let apiName = SignupItems + ("\(sheetData.id!)")
        ActivityIndicator.show()
        
        Alamofire.request(.GET, apiName, headers: appDelegate.loginHeaderCredentials)
            .responseJSON { response in
                if let result = response.result.value {
                    ActivityIndicator.hide()
                    let datas = (result as? NSArray)!
                    let dic = datas.objectAtIndex(0) as? NSDictionary
                    let sheet = SignupSheet(info: dic)
                    let item = (dic?.objectForKey("items")) as! NSArray
                    let dic1 = item.objectAtIndex(0) as? NSDictionary
                    
//                    self.headingLbl.text = ("Join the \(sheet.name)")
//                    self.rsvpLbl.text = "Yeah! You have just RSVP'd as joining the party!"
//                    self.dateTimeLbl.text = ("\(Custom.dayStringFromTime1(sheet.createDate!))")
//                    
                    //attendeesTxtField.text = data.volunteers![0].objectForKey("phone") as? String ?? ""
                    
                    //self.itemsDatas = (dic1?.objectForKey("volunteers")) as! NSArray
                    //self.tableView.reloadData()
                }else {
                    ActivityIndicator.hide()
                }
        }
    }
    
    
    //MARK:- Keyboard
    func HideTextKeyboard(sender: UITapGestureRecognizer?) {
        //textField_comments.resignFirstResponder()
        placeHolderText = "Type comments here.."
        textView_comments.text = placeHolderText
        textView_comments.textColor = UIColor.lightGrayColor()
        textView_comments.resignFirstResponder()
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        // Check offset and load more feeds
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height;
        
        if (maximumOffset - currentOffset <= 200.0) {
            
            //            if commentArray?.count > 0 {
            //                getCommentsListForStatus ()
            //
            //            }
        }
    }
    
    func tableViewScrollToBottom(animated: Bool) {
        
        let delay = 0.1 * Double(NSEC_PER_SEC)
        let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        
        dispatch_after(time, dispatch_get_main_queue(), {
            
            let numberOfSections = self.tableView.numberOfSections
            let numberOfRows = (self.list.count) - self.tableView.numberOfRowsInSection(numberOfSections-1)
            if numberOfRows > 0 {
                let indexPath = NSIndexPath(forRow: 0, inSection: numberOfRows)
                self.tableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: UITableViewScrollPosition.Bottom, animated: animated)
            }
        })
    }
    
    @IBAction func commentsSend_btnAction(sender: UIButton) {
        if (textView_comments.text != "" || textView_comments.text != " ") && textView_comments.textColor == UIColor.blackColor() {
            if attendeesTxtField.text == "" || attendeesTxtField.text == nil {
                BaseUIView.toast("Please enter Attendees.")
                attendeesTxtField.becomeFirstResponder()
                textView_comments.resignFirstResponder()
            }else {
                postComment(textView_comments.text, attendees: attendeesTxtField.text!)
                attendeesTxtField.text = ""
                textView_comments.text = ""
                attendeesTxtField.becomeFirstResponder()
                textView_comments.resignFirstResponder()
            }
            
        }else {
            BaseUIView.toast("Please enter text")
        }
        return
    }
    
    // MARK: - UIKeyBoard Delegate
    func keyboardWillShow(notification: NSNotification) {
        let info:NSDictionary = notification.userInfo!
        let keyboardSize = (info[UIKeyboardFrameBeginUserInfoKey] as! NSValue).CGRectValue()
        let keyboardHeight:CGFloat = keyboardSize.height
        
        UIView.animateWithDuration(0.25, delay: 0.25, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
            
            self.commentsBoxBottomSpacing.constant = keyboardHeight
            
            }, completion: {
                (value: Bool) in
        })
    }
    
    func keyboardWillHide(notification: NSNotification) {
        let info:NSDictionary = notification.userInfo!
        let keyboardSize = (info[UIKeyboardFrameBeginUserInfoKey] as! NSValue).CGRectValue()
        let keyboardHeight:CGFloat = keyboardSize.height
        
        self.commentsBoxBottomSpacing.constant = keyboardHeight
        UIView.animateWithDuration(0.35, animations: {
            self.commentsBoxBottomSpacing.constant = 0
            self.view.layoutIfNeeded()
            }, completion: nil)
        
    }
    
    func keyboardDidChangeFrame(notification: NSNotification) {
        
        let info:NSDictionary = notification.userInfo!
        let keyboardSize = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
        
        let keyboardHeight:CGFloat = keyboardSize.height
        
        
        UIView.animateWithDuration(0.25, delay: 0.25, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
            
            self.commentsBoxBottomSpacing.constant = keyboardHeight
            }, completion: nil)
    }
    
    // MARK: - UITextFiled Delegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField_comments.resignFirstResponder()
        return true
    }
    
    //MARK: - Button Action
    @IBAction func backBtnClick(sender: UIButton) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

//MARK:- TableView
extension OpenRSVPViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.volunteerData.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("RSVPItemCell") as! RSVPItemCell
        let data = self.volunteerData[indexPath.row] as? NSDictionary
        cell.updateData(data!)
        
        return cell
    }
    
}


// MARK: - Extensions for UITextView
extension OpenRSVPViewController: UITextViewDelegate {
    
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