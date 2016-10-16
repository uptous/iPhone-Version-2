//
//  ItemDetailsEditingMsgViewController.swift
//  uptous
//
//  Created by Roshan Gita  on 10/8/16.
//  Copyright © 2016 SPA. All rights reserved.
//

import UIKit
import Alamofire


class ItemDetailsEditingMsgViewController: GeneralViewController {

    @IBOutlet weak var commentsTextView: UIView!
    @IBOutlet weak var textField_comments: UITextField!
    @IBOutlet weak var btn_comments: UIButton!
    @IBOutlet var commentsBoxBottomSpacing: NSLayoutConstraint!
    @IBOutlet weak var textView_comments: HPTextViewInternal!
    @IBOutlet weak var headingLbl: UILabel!
    @IBOutlet weak var msgLbl: UILabel!
    @IBOutlet weak var eventDateLbl: UILabel!
    @IBOutlet weak var spotLbl: UILabel!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    var scrollToTop = false
    var offset = 0
    var placeHolderText = "Type comments here.."
    var isCommentEdit_1_replyEdit_2 : Int?
    var data: SignupSheet!
    var selectedItems: Items!
    var driverDatas = NSArray()
    var voluniteerdDatas = NSArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textView_comments.placeholder = placeHolderText
        textView_comments.text = placeHolderText
        textView_comments.textColor = UIColor.lightGrayColor()
        textField_comments.placeholder = "Type comments here.."
        // Observer Keyboard
        let center: NSNotificationCenter = NSNotificationCenter.defaultCenter()
        center.addObserver(self, selector: #selector(ItemDetailsEditingMsgViewController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        center.addObserver(self, selector: #selector(ItemDetailsEditingMsgViewController.keyboardWillHide(_:)), name: UIKeyboardDidHideNotification, object: nil)
        center.addObserver(self, selector: #selector(ItemDetailsEditingMsgViewController.keyboardDidChangeFrame(_:)), name: UIKeyboardDidChangeFrameNotification, object: nil)
        let tapRecognizer = UITapGestureRecognizer(target: self , action: #selector(ItemDetailsEditingMsgViewController.HideTextKeyboard(_:)))
        tableView.addGestureRecognizer(tapRecognizer)
        
        Custom.cornerView(contentView)
        updateData(selectedItems)
        
        voluniteerdDatas = selectedItems.volunteers!
        print(voluniteerdDatas)
        
        headingLbl.text = data.name
        msgLbl.text = selectedItems.name
        eventDateLbl.text = ("\(Custom.dayStringFromTime1(selectedItems.dateTime!))")
        
        
        let x = selectedItems.volunteerCount!
        let y = selectedItems.numVolunteers!
        if y == 0 {
            
            spotLbl.text = "More spots are open"

        }else {
            let text = ("\(x) out of ") + ("\(y) spots open")
            spotLbl.text = text

        }
        
        
        
    }
    
    func updateData(data: Items) {
        let attributedStr = NSMutableAttributedString()

        //msgLbl.text = data.notes
        
        //eventDateLbl.text = ("\(Custom.dayStringFromTime1(data.createDate!))")
        //let text = ("\() out of") + ("\() spots open")
        //spotLbl.text = "2 out of 10 spots open"
        
//        attributedStr.appendAttributedString(Custom.attributedString1(("\(data.numVolunteers!) "),size: 14.0)!)
//        let attributedString1 = NSAttributedString(string: "spots open", attributes: nil)
//        
//        attributedStr.appendAttributedString(attributedString1)
        //spotLbl.attributedText = attributedStr
        
    }
    
    
    @IBAction func back(sender: UIButton) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    override func viewWillAppear(animated: Bool) {
        tableView.estimatedRowHeight = 110
        tableView.rowHeight = UITableViewAutomaticDimension
        self.fetchItems()
    }
    
    //MARK:- Delete
    @IBAction func deleteButtonClick(sender: UIButton) {
        let alertView = UIAlertController(title: "UpToUs", message: "are you sure you want to delete this record?", preferredStyle: .Alert)
        alertView.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (alertAction) -> Void in
            self.delete()
        }))
        alertView.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        presentViewController(alertView, animated: true, completion: nil)
    }
    
    func delete() {
        let apiName = SignupItems + ("\(data.id!)") + ("/item/\(selectedItems.Id!)/Del")
        ActivityIndicator.show()
        
        Alamofire.request(.POST, apiName, headers: appDelegate.loginHeaderCredentials,parameters: nil)
            .responseJSON { response in
                ActivityIndicator.hide()
                self.navigationController?.popViewControllerAnimated(true)
        }
        
    }

    
    //Post Comment
    func postComment(msg: String) {
        //let opportunityID = selectedItems.Id
        let apiName = SignupItems + ("\(data.id!)") + ("/item/\(selectedItems.Id!)/Add")
        print(apiName)
        ActivityIndicator.show()
        let parameters = ["comment": msg]
        
        Alamofire.request(.POST, apiName, headers: appDelegate.loginHeaderCredentials,parameters: parameters)
            .responseJSON { response in
                ActivityIndicator.hide()
                print(response)
                let result = response as? NSDictionary
//                if (result?.objectForKey("status"))! as! String == "0"{
//                    
//                }
                //if self.commentList.count > 0 {
                self.fetchItems()
                //}
        }
    }

    
    //MARK: Fetch Records
    func fetchItems() {
        let apiName = SignupItems + ("\(data.id!)")
        ActivityIndicator.show()
        
        Alamofire.request(.GET, apiName, headers: appDelegate.loginHeaderCredentials)
            .responseJSON { response in
                if let result = response.result.value {
                    ActivityIndicator.hide()
                    self.driverDatas = (result as? NSArray)!
                    let dic = self.driverDatas.objectAtIndex(0) as? NSDictionary
                    //self.updateData(SignupSheet(info: dic))
                    let data = (dic?.objectForKey("items")) as! NSArray
                   
                    for index in 0..<data.count {
                        let dic = data.objectAtIndex(index) as? NSDictionary
                         if dic?.objectForKey("id") as? Int == self.selectedItems.Id {
                            print(dic?.objectForKey("volunteers"))
                            self.voluniteerdDatas = dic?.objectForKey("volunteers") as! NSArray
                            break
                        }
                    }
                    print("self.voluniteerdDatas==\(self.voluniteerdDatas.count)")
                    
                    self.tableView.reloadData()
                }else {
                    ActivityIndicator.hide()
                }
        }
    }
    
    //***************Comment***************
    
    //MARK:- Keyboard
    func HideTextKeyboard(sender: UITapGestureRecognizer?) {
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
            let numberOfRows = (self.voluniteerdDatas.count) - self.tableView.numberOfRowsInSection(numberOfSections-1)
            if numberOfRows > 0 {
                let indexPath = NSIndexPath(forRow: 0, inSection: numberOfRows)
                self.tableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: UITableViewScrollPosition.Bottom, animated: animated)
            }
        })
    }
    
    @IBAction func commentsSend_btnAction(sender: UIButton) {
        if (textView_comments.text != "" ||  textView_comments.text != " ") && textView_comments.textColor == UIColor.blackColor() {
            postComment(textView_comments.text)
            textView_comments.text = ""
            textView_comments.resignFirstResponder()
            
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

//MARK:- TableView
extension ItemDetailsEditingMsgViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.voluniteerdDatas.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ItemDetailsMsgCell") as! ItemDetailsMsgCell
        let data = self.voluniteerdDatas[indexPath.row] as? NSDictionary
        cell.updateData(data!)
        return cell
    }
}

// MARK: - Extensions for UITextView
extension ItemDetailsEditingMsgViewController: UITextViewDelegate {
    
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


