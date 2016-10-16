//
//  DetailsSignUpDriverViewController.swift
//  uptous
//
//  Created by Roshan Gita  on 10/1/16.
//  Copyright © 2016 SPA. All rights reserved.
//

import UIKit
import Alamofire

class DetailsSignUpDriverViewController: GeneralViewController {

    @IBOutlet weak var headingLbl: UILabel!
    @IBOutlet weak var fromLbl: UILabel!
    @IBOutlet weak var toLbl: UILabel!
    @IBOutlet weak var dateTimeLbl: UILabel!
    @IBOutlet weak var phoneTxtField: UITextField!
    //@IBOutlet weak var adultsTxtField: UITextField!
    //@IBOutlet weak var childrenTxtField: UITextField!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var commentsTextView: UIView!
    @IBOutlet weak var textField_comments: UITextField!
    @IBOutlet weak var btn_comments: UIButton!
    @IBOutlet var commentsBoxBottomSpacing: NSLayoutConstraint!
    @IBOutlet weak var textView_comments: HPTextViewInternal!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var gifImageView: UIImageView!
    
    //var data: Items!
    var result = NSDictionary()
    var itemsDatas = NSArray()
    var selectedItems: Items!
    var sheetData: SignupSheet!
    var scrollToTop = false
    var offset = 0
    var placeHolderText = "Type comments here.."
    var isCommentEdit_1_replyEdit_2 : Int?
    var list = NSArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Custom.buttonCorner(cancelButton)
        
        headingLbl.text = ("Join the \(sheetData.name!)")
        fromLbl.text = "Driving from: \(selectedItems.name!)"
        toLbl.text = "To: \(selectedItems.extra!)"
        print("\(Custom.dayStringFromTime1(selectedItems.dateTime!))")
        dateTimeLbl.text = ("\(Custom.dayStringFromTime1(selectedItems.dateTime!))")
        
        //phoneTxtField.text = selectedItems.volunteers![0].objectForKey("phone") as? String ?? ""
        //adultsTxtField.text = data.volunteers![0].objectForKey("") as? String ?? "0"
        //childrenTxtField.text = data.volunteers![0].objectForKey("") as? String ?? "0"
        
        textView_comments.placeholder = placeHolderText
        textView_comments.text = placeHolderText
        textView_comments.textColor = UIColor.lightGrayColor()
        textField_comments.placeholder = "Type comments here.."
        // Observer Keyboard
        let center: NSNotificationCenter = NSNotificationCenter.defaultCenter()
        center.addObserver(self, selector: #selector(DetailsSignUpDriverViewController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        center.addObserver(self, selector: #selector(DetailsSignUpDriverViewController.keyboardWillHide(_:)), name: UIKeyboardDidHideNotification, object: nil)
        center.addObserver(self, selector: #selector(DetailsSignUpDriverViewController.keyboardDidChangeFrame(_:)), name: UIKeyboardDidChangeFrameNotification, object: nil)
        
        let tapRecognizer = UITapGestureRecognizer(target: self , action: #selector(DetailsSignUpDriverViewController.HideTextKeyboard(_:)))
        tableView.addGestureRecognizer(tapRecognizer)
        
        
        self.itemsDatas = selectedItems.volunteers!
        self.tableView.reloadData()
        
        /*let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(1 * Double(NSEC_PER_SEC)))
        dispatch_after(delayTime, dispatch_get_main_queue()) {
            //self.updateData(self.data)
            //self.fetchCommentList()
        }*/
        
        let imageData = NSData(contentsOfURL: NSBundle.mainBundle().URLForResource("smiley_test", withExtension: "gif")!)
        let advTimeGif = UIImage.gifImageWithData(imageData!)
        gifImageView.image = advTimeGif
    }
    
    override func viewWillAppear(animated: Bool) {
        self.tableView.hidden = true
        tableView.estimatedRowHeight = 110
        tableView.rowHeight = UITableViewAutomaticDimension
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
        let apiName = SignupItems + ("\(sheetData.id!)") + ("/item/\(selectedItems.Id!)/Del")
        ActivityIndicator.show()
        
        Alamofire.request(.POST, apiName, headers: appDelegate.loginHeaderCredentials,parameters: nil)
            .responseJSON { response in
                ActivityIndicator.hide()
                print(response)
                let result = response as? NSDictionary
                print(result)
                //if self.commentList.count > 0 {
                    //self.fetchItems()
                //}
        }

    }
    
    //Post Comment
    func postComment(msg: String,phone: String) {
        let apiName = SignupItems + ("\(sheetData.id!)") + ("/item/\(selectedItems.Id!)/Add")
        ActivityIndicator.show()
        let parameters = ["comment": msg,"phone": phone]
        
        Alamofire.request(.POST, apiName, headers: appDelegate.loginHeaderCredentials,parameters: parameters)
            .responseJSON { response in
                ActivityIndicator.hide()
                print(response)
                let result = response as? NSDictionary
                //if self.commentList.count > 0 {
                self.fetchItems()
                //}
        }
    }
    
    func fetchItems() {
        let apiName = SignupItems + ("\(sheetData.id!)")
        ActivityIndicator.show()
        
        Alamofire.request(.GET, apiName, headers: appDelegate.loginHeaderCredentials)
            .responseJSON { response in
                if let result = response.result.value {
                    ActivityIndicator.hide()
                    let datas  = (result as? NSArray)!
                    let dic = datas.objectAtIndex(0) as? NSDictionary
                    //self.updateData(SignupSheet(info: dic))
                    let data = (dic?.objectForKey("items")) as! NSArray
                    
                    for index in 0..<data.count {
                        let dic = data.objectAtIndex(index) as? NSDictionary
                        if dic?.objectForKey("id") as? Int == self.selectedItems.Id {
                            print(dic?.objectForKey("volunteers"))
                            self.itemsDatas = dic?.objectForKey("volunteers") as! NSArray
                            break
                        }
                    }
                    print("self.voluniteerdDatas==\(self.itemsDatas.count)")
                    
                    self.tableView.reloadData()
                }else {
                    ActivityIndicator.hide()
                }
        }
    }

    
    //Fetch Comment
   /* func fetchItems() {
        let apiName = SignupItems + ("\(sheetData.id!)")
        ActivityIndicator.show()
        
        Alamofire.request(.GET, apiName, headers: appDelegate.loginHeaderCredentials)
            .responseJSON { response in
                if let result = response.result.value {
                    ActivityIndicator.hide()
                    let datas = (result as? NSArray)!
                    let dic = datas.objectAtIndex(0) as? NSDictionary
                    let item = (dic?.objectForKey("items")) as! NSArray
                    let dic1 = item.objectAtIndex(0) as? NSDictionary
                    
                    self.itemsDatas = (dic1?.objectForKey("volunteers")) as! NSArray
                    self.tableView.reloadData()
                }else {
                    ActivityIndicator.hide()
                }
        }
    }*/

    
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
        if (textView_comments.text != "" ||  textView_comments.text != " ") && textView_comments.textColor == UIColor.blackColor() {
            
            if phoneTxtField.text == "" || phoneTxtField.text == nil {
                BaseUIView.toast("Please enter Phone Number.")
            }else {
                postComment(textView_comments.text, phone: phoneTxtField.text!)
                textView_comments.text = ""
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
    
    
    //MARK: - Button Action
    @IBAction func back(sender: UIButton) {
        self.navigationController?.popViewControllerAnimated(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

//MARK:- TableView
extension DetailsSignUpDriverViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.itemsDatas.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("DriverItemCell") as! DriverItemCell
        let data = self.itemsDatas[indexPath.row] as? NSDictionary
        print(data)
        cell.updateData(data!)
        
        return cell
    }
}

// MARK: - Extensions for UITextField
extension DetailsSignUpDriverViewController: UITextFieldDelegate {
    
    func textFieldDidEndEditing(textField: UITextField) {
        textField.resignFirstResponder()
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        //textField_comments.resignFirstResponder()
        textField.resignFirstResponder()
        return true
    }
}


// MARK: - Extensions for UITextView
extension DetailsSignUpDriverViewController: UITextViewDelegate {
    
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
