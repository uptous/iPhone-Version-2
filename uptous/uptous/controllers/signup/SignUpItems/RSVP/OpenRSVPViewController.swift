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
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var attendView: UIView!

    
    var volunteerData = NSArray()
    var sheetData: SignupSheet!
    var itemData: Items!
    var sheetDataID: String?
    var postCounter = 0
    var rsvpType: String?
    
    var scrollToTop = false
    var offset = 0
    var placeHolderText = "Type comments here.."
    var isCommentEdit_1_replyEdit_2 : Int?
    var list = NSArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Custom.buttonCorner(cancelButton)
        //self.headingLbl.text = ("Join the \(itemData.name!)")
        self.rsvpLbl.text = itemData.name!//"Yeah! You have just RSVP'd as joining the party!"
        //self.dateTimeLbl.text = ("\(Custom.dayStringFromTime3(itemData.dateTime!))")
        if itemData.dateTime == 0 {
            dateTimeLbl.text = ""
            
        }else {
            if Custom.dayStringFromTime4(itemData.dateTime!) == "1:00AM" {
                dateTimeLbl.text =  "\(Custom.dayStringSignupItems(itemData.dateTime!))"
                
            }else if itemData.endTime == "" || itemData.endTime == "1:00AM" {
                dateTimeLbl.text = "\(Custom.dayStringSignupItems(itemData.dateTime!))," + "" + " \(Custom.dayStringFromTime4(itemData.dateTime!))"
            }else {
                dateTimeLbl.text = "\(Custom.dayStringSignupItems(itemData.dateTime!)), " + "" + " \(Custom.dayStringFromTime4(itemData.dateTime!)) - " + "" + "\(itemData.endTime!)"
            }
        }
        if rsvpType == "Vote" {
           attendView.isHidden = true
        }else {
            attendView.isHidden = false
        }
        
        //attendeesTxtField.text = data.volunteers![0].objectForKey("phone") as? String ?? ""
        
        textView_comments.placeholder = placeHolderText
        textView_comments.text = placeHolderText
        textView_comments.textColor = UIColor.lightGray
        textField_comments.placeholder = "Type comments here.."
        // Observer Keyboard
        let center: NotificationCenter = NotificationCenter.default
        center.addObserver(self, selector: #selector(OpenRSVPViewController.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        center.addObserver(self, selector: #selector(OpenRSVPViewController.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardDidHide, object: nil)
        center.addObserver(self, selector: #selector(OpenRSVPViewController.keyboardDidChangeFrame(_:)), name: NSNotification.Name.UIKeyboardDidChangeFrame, object: nil)
        
        let tapRecognizer = UITapGestureRecognizer(target: self , action: #selector(OpenRSVPViewController.HideTextKeyboard(_:)))
        tableView.addGestureRecognizer(tapRecognizer)
        
        let delayTime = DispatchTime.now() + Double(Int64(1 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
         DispatchQueue.main.asyncAfter(deadline: delayTime) {
            //self.updateData(self.data)
            //self.fetchItems()
         }
        
        /*let imageData = try? Data(contentsOf: Bundle.main.url(forResource: "smiley_test", withExtension: "gif")!)
        let advTimeGif = UIImage.gifImageWithData(imageData!)
        gifImageView.image = advTimeGif*/
        
        print(self.itemData.volunteers!)
        print(self.itemData.volunteers!.count)
        self.volunteerData = self.itemData.volunteers!
        self.tableView.reloadData()
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.estimatedRowHeight = 110
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    //Post Comment
    func postComment(_ msg: String,attendees: String) {
        let apiName = SignupItems + ("\(sheetDataID!)") + ("/item/\(itemData.Id!)/Add")
        var stringPost = "comment=" + msg
        stringPost += "&numberOfAttendees=" + attendees
        
        DataConnectionManager.requestPOSTURL1(api: apiName, stringPost: stringPost, success: {
            (response) -> Void in
            print(response)
            
            if response["status"] as? String == "0" {
                DispatchQueue.main.async(execute: {
                    self.dismiss(animated: true, completion: nil)
                    let _ = self.navigationController?.popViewController(animated: true)
                })
            }else {
                self.postCounter = self.postCounter + 1
                
                if self.postCounter == 3 {
                    let msg = response["message"] as? String ?? ""
                    if msg != "" || msg != nil {
                        self.showAlertWithoutCancel(title: "Alert", message: msg)
                    }
                }else {
                    self.postComment(self.textView_comments.text, attendees: self.attendeesTxtField.text!)
                }

            }
        })
    }
    
    func showAlertWithoutCancel(title:String?, message:String?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
            self.dismiss(animated: true, completion: nil)
            self.navigationController?.popViewController(animated: true)
            print("you have pressed OK button");
        }
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    //Fetch Comment
    func fetchItems() {
        let apiName = SignupItems + ("\(sheetDataID!)")
        
        
        DataConnectionManager.requestGETURL(api: apiName, para: ["":""], success: {
            (response) -> Void in
            print(response)
            
            let datas = (response as? NSArray)!
            let dic = datas.object(at: 0) as? NSDictionary
            let sheet = SignupSheet(info: dic)
            let item = (dic?.object(forKey: "items")) as! NSArray
            let dic1 = item.object(at: 0) as? NSDictionary
            
        }) {
            (error) -> Void in
            
            let alert = UIAlertController(title: "Alert", message: "Error", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Try Again", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    
    //MARK:- Keyboard
    func HideTextKeyboard(_ sender: UITapGestureRecognizer?) {
        //textField_comments.resignFirstResponder()
        placeHolderText = "Type comments here.."
        textView_comments.text = placeHolderText
        textView_comments.textColor = UIColor.lightGray
        textView_comments.resignFirstResponder()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
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
    
    func tableViewScrollToBottom(_ animated: Bool) {
        
        let delay = 0.1 * Double(NSEC_PER_SEC)
        let time = DispatchTime.now() + Double(Int64(delay)) / Double(NSEC_PER_SEC)
        
        DispatchQueue.main.asyncAfter(deadline: time, execute: {
            
            let numberOfSections = self.tableView.numberOfSections
            let numberOfRows = (self.list.count) - self.tableView.numberOfRows(inSection: numberOfSections-1)
            if numberOfRows > 0 {
                let indexPath = IndexPath(row: 0, section: numberOfRows)
                self.tableView.scrollToRow(at: indexPath, at: UITableViewScrollPosition.bottom, animated: animated)
            }
        })
    }
    
    @IBAction func commentsSend_btnAction(_ sender: UIButton) {
        
        if(textView_comments.text != " ") && textView_comments.textColor == UIColor.black {
            
        }else {
            textView_comments.text = " "
        }
        
        if textView_comments.text == "Type comments here.." {
            textView_comments.text = ""
        }
        postComment(textView_comments.text, attendees: attendeesTxtField.text!)
        attendeesTxtField.text = ""
        textView_comments.text = ""
        
        /*if (textView_comments.text != "" || textView_comments.text != " ") && textView_comments.textColor == UIColor.black {
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
        }*/
        return
    }
    
    // MARK: - UIKeyBoard Delegate
    func keyboardWillShow(_ notification: Notification) {
        let info:NSDictionary = (notification as NSNotification).userInfo! as NSDictionary
        let keyboardSize = (info[UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        let keyboardHeight:CGFloat = keyboardSize.height
        
        UIView.animate(withDuration: 0.25, delay: 0.25, options: UIViewAnimationOptions(), animations: {
            
            self.commentsBoxBottomSpacing.constant = keyboardHeight
            
            }, completion: {
                (value: Bool) in
        })
    }
    
    func keyboardWillHide(_ notification: Notification) {
        let info:NSDictionary = (notification as NSNotification).userInfo! as NSDictionary
        let keyboardSize = (info[UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        let keyboardHeight:CGFloat = keyboardSize.height
        
        self.commentsBoxBottomSpacing.constant = keyboardHeight
        UIView.animate(withDuration: 0.35, animations: {
            self.commentsBoxBottomSpacing.constant = 0
            self.view.layoutIfNeeded()
            }, completion: nil)
        
    }
    
    func keyboardDidChangeFrame(_ notification: Notification) {
        
        let info:NSDictionary = (notification as NSNotification).userInfo! as NSDictionary
        let keyboardSize = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        
        let keyboardHeight:CGFloat = keyboardSize.height
        
        
        UIView.animate(withDuration: 0.25, delay: 0.25, options: UIViewAnimationOptions(), animations: {
            
            self.commentsBoxBottomSpacing.constant = keyboardHeight
            }, completion: nil)
    }
    
    
    
    //MARK: - Button Action
    @IBAction func backBtnClick(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
        self.navigationController?.popViewController(animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

//MARK:- TableView
extension OpenRSVPViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.volunteerData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "RSVPItemCell") as! RSVPItemCell
        let data = self.volunteerData[(indexPath as NSIndexPath).row] as? NSDictionary
        cell.updateData(data!)
        
        return cell
    }
    
}

// MARK: - Extensions for UITextField
extension OpenRSVPViewController: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //textField_comments.resignFirstResponder()
        textField.resignFirstResponder()
        return true
    }
}


// MARK: - Extensions for UITextView
extension OpenRSVPViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        textView.selectedRange = NSMakeRange(0, 0)
        if textView.textColor == UIColor.lightGray && textView.text != placeHolderText && isCommentEdit_1_replyEdit_2 == 0{
            textView.text = nil
            textView.textColor = UIColor.black
        }
        else{
            
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = placeHolderText
            textView.textColor = UIColor.lightGray
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        //self.textView_comments.textViewDidChange(textView)
    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        
        if textView.text == "Add caption tag another user with @username..." {
            textView.text = nil
        }
        return true
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        if textView.textColor == UIColor.lightGray && textView.text == placeHolderText {
            textView.text = nil
            textView.textColor = UIColor.black
        }
        if text == "" && textView_comments.text.characters.count == 1 && textView.textColor == UIColor.black{
            textView.text = placeHolderText
            textView.textColor = UIColor.lightGray
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


