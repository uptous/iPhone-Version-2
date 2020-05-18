//
//  ItemDetailsEditingMsgViewController.swift
//  uptous
//
//  Created by Roshan Gita  on 10/8/16.
//  Copyright © 2016 UpToUs. All rights reserved.
//

import UIKit
import Alamofire


class ItemDetailsEditingMsgViewController: GeneralViewController {

    @IBOutlet weak var commentsTextView: UIView!
    @IBOutlet weak var textField_comments: UITextField!
    @IBOutlet weak var btn_comments: UIButton!
    @IBOutlet var commentsBoxBottomSpacing: NSLayoutConstraint!
    @IBOutlet var msgBoxBottomSpacing: NSLayoutConstraint!
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
    var sheetDataID: String!
    var postCounter = 0
    var eventDateValue: String!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        eventDateLbl.text = eventDateValue
        textView_comments.placeholder = placeHolderText
        textView_comments.text = placeHolderText
        textView_comments.textColor = UIColor.lightGray
        textField_comments.placeholder = "Type comments here.."
        // Observer Keyboard
        let center: NotificationCenter = NotificationCenter.default
        center.addObserver(self, selector: #selector(ItemDetailsEditingMsgViewController.keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        center.addObserver(self, selector: #selector(ItemDetailsEditingMsgViewController.keyboardWillHide(_:)), name: UIResponder.keyboardDidHideNotification, object: nil)
        center.addObserver(self, selector: #selector(ItemDetailsEditingMsgViewController.keyboardDidChangeFrame(_:)), name: UIResponder.keyboardDidChangeFrameNotification, object: nil)
        let tapRecognizer = UITapGestureRecognizer(target: self , action: #selector(ItemDetailsEditingMsgViewController.HideTextKeyboard(_:)))
        tableView.addGestureRecognizer(tapRecognizer)
        
        //_ = Custom.cornerView(contentView)
        updateData(selectedItems)
        
        voluniteerdDatas = selectedItems.volunteers!
        
        //headingLbl.text = data.name
        msgLbl.text = selectedItems.name
        msgBoxBottomSpacing.constant = calculateHeight1(selectedItems.name!, width: msgLbl.frame.size.width) + 10
        
        
        if selectedItems.dateTime == 0 {
            eventDateLbl.text = ""
            
        }else {
            if Custom.dayStringFromTime4(selectedItems.dateTime!) == "1:00AM" {
                eventDateLbl.text =  "\(Custom.dayStringSignupItems(selectedItems.dateTime!))"
                
            }else if selectedItems.endTime == "" || selectedItems.endTime == "1:00AM" {
                eventDateLbl.text = "\(Custom.dayStringSignupItems(selectedItems.dateTime!))," + "" + " \(Custom.dayStringFromTime4(selectedItems.dateTime!))"
            }else {
                eventDateLbl.text = "\(Custom.dayStringSignupItems(selectedItems.dateTime!)), " + "" + " \(Custom.dayStringFromTime4(selectedItems.dateTime!)) - " + "" + "\(selectedItems.endTime!)"
            }
        }
        //eventDateLbl.text = ("\(Custom.dayStringFromTime3(selectedItems.dateTime!))")
        
        
        let x = selectedItems.numVolunteers! - selectedItems.volunteerCount!
        let y = selectedItems.numVolunteers!
        if y == 0 {
            //spotLbl.text = "More spots are open"
            spotLbl.text = ""
        }else {
            let text = ("\(x) out of ") + ("\(y) spots open")
            spotLbl.text = text
        }
        
    }
    
    //Mark : Get Label Height with text
    func calculateHeight1(_ text:String, width:CGFloat) -> CGFloat {
        let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = UIFont(name: "HelveticaNeue Medium", size: 18)
        label.text = text
        
        label.sizeToFit()
        return label.frame.height
    }
    
    func updateData(_ data: Items) {
        _ = NSMutableAttributedString()

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
    
    
    @IBAction func back(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
        //DispatchQueue.main.async(execute: {
        //    self.dismiss(animated: true, completion: nil)
        //    let _ = self.navigationController?.popViewController(animated: true)
        //})
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.estimatedRowHeight = 94
        
        tableView.rowHeight = UITableView.automaticDimension
        let when = DispatchTime.now() + 1 // change 2 to desired number of seconds
        DispatchQueue.main.asyncAfter(deadline: when) {
            self.fetchItems()
        }
    }
    
    //MARK:- Delete
    @IBAction func deleteButtonClick(_ sender: UIButton) {
        let alertView = UIAlertController(title: "UpToUs", message: "Are you sure that you want to delete your assignment?", preferredStyle: .alert)
        alertView.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (alertAction) -> Void in
            self.delete()
        }))
        alertView.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alertView, animated: true, completion: nil)
    }
    
    func delete() {
        let apiName = SignupItems + ("\(sheetDataID!)") + ("/item/\(selectedItems.Id!)/Del")
        let stringPost = ""
        DataConnectionManager.requestPOSTURL1(api: apiName, stringPost: stringPost, success: {
            (response) -> Void in
            
            if response["status"] as? String == "0" {
                //self.navigationController?.popViewController(animated: true)
                self.dismiss(animated: true, completion: nil)
            }
        })
    }
    
    //Post Comment
    func postComment(_ msg: String) {
        //let opportunityID = selectedItems.Id
        let apiName = SignupItems + ("\(sheetDataID!)") + ("/item/\(selectedItems.Id!)/Add")
        let stringPost = "comment=" + msg
        //stringPost += "&phone=" + ""
        
        DataConnectionManager.requestPOSTURL1(api: apiName, stringPost: stringPost, success: {
            (response) -> Void in
            
            if response["status"] as? String == "0" {
                DispatchQueue.main.async(execute: {
                    self.dismiss(animated: true, completion: nil)
                   // let _ = self.navigationController?.popViewController(animated: true)
                })
            }else {
                self.postCounter = self.postCounter + 1
                if self.postCounter == 3 {
                    let msg = response["message"] as? String? ?? ""
                    if msg != "" || msg != nil {
                        self.showAlertWithoutCancel(title: "Alert", message: msg)
                    }
                }else {
                    self.postComment(self.textView_comments.text)
                }
            }
        })
    }

    func showAlertWithoutCancel(title:String?, message:String?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
            self.dismiss(animated: true, completion: nil)
            //self.navigationController?.popViewController(animated: true)
            print("you have pressed OK button");
        }
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion: nil)
    }

    //MARK: Fetch Records
    func fetchItems() {
        let apiName = SignupItems + ("\(sheetDataID!)")
        DataConnectionManager.requestGETURL(api: apiName, para: ["":""], success: {
            (response) -> Void in
            
            self.driverDatas = (response as? NSArray)!
            let dic = self.driverDatas.object(at: 0) as? NSDictionary
            //self.updateData(SignupSheet(info: dic))
            let data = (dic?.object(forKey: "items")) as! NSArray
            
            for index in 0..<data.count {
                let dic = data.object(at: index) as? NSDictionary
                if dic?.object(forKey: "id") as? Int == self.selectedItems.Id {
                    self.voluniteerdDatas = dic?.object(forKey: "volunteers") as! NSArray
                    break
                }
            }
            print("ItemDetailsEditingMsgViewController: FetchItems: self.voluniteerdDatas==\(self.voluniteerdDatas.count)")
            
            self.tableView.reloadData()
            
        }) {
            (error) -> Void in
            
            let alert = UIAlertController(title: "Alert", message: "Error", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Try Again", style: UIAlertAction.Style.default, handler: nil))
            //self.present(alert, animated: true, completion: nil)
        }
    }
    
    //***************Comment***************
    
    //MARK:- Keyboard
    @objc func HideTextKeyboard(_ sender: UITapGestureRecognizer?) {
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
            let numberOfRows = (self.voluniteerdDatas.count) - self.tableView.numberOfRows(inSection: numberOfSections-1)
            if numberOfRows > 0 {
                let indexPath = IndexPath(row: 0, section: numberOfRows)
                self.tableView.scrollToRow(at: indexPath, at: UITableView.ScrollPosition.bottom, animated: animated)
            }
        })
    }
    
    @IBAction func commentsSend_btnAction(_ sender: UIButton) {
        if textView_comments.text == "Type comments here.." {
            textView_comments.text = ""
        }
        postComment(textView_comments.text)
        textView_comments.text = ""
        textView_comments.text = ""
        textView_comments.resignFirstResponder()

        /*if (textView_comments.text != "" ||  textView_comments.text != " ") && textView_comments.textColor == UIColor.black {
            postComment(textView_comments.text)
            textView_comments.text = ""
            textView_comments.resignFirstResponder()
            
        }else {
            BaseUIView.toast("Please enter text")
        }*/
        return
    }
    
    // MARK: - UIKeyBoard Delegate
    @objc func keyboardWillShow(_ notification: Notification) {
        let info:NSDictionary = (notification as NSNotification).userInfo! as NSDictionary
        let keyboardSize = (info[UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        let keyboardHeight:CGFloat = keyboardSize.height
        
        UIView.animate(withDuration: 0.25, delay: 0.25, options: UIView.AnimationOptions(), animations: {
            
            self.commentsBoxBottomSpacing.constant = keyboardHeight
            
            }, completion: {
                (value: Bool) in
        })
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        let info:NSDictionary = (notification as NSNotification).userInfo! as NSDictionary
        let keyboardSize = (info[UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        
        let keyboardHeight:CGFloat = keyboardSize.height
        
        self.commentsBoxBottomSpacing.constant = keyboardHeight
        UIView.animate(withDuration: 0.35, animations: {
            self.commentsBoxBottomSpacing.constant = 0
            self.view.layoutIfNeeded()
            }, completion: nil)
        
    }
    
    @objc func keyboardDidChangeFrame(_ notification: Notification) {
        
        let info:NSDictionary = (notification as NSNotification).userInfo! as NSDictionary
        let keyboardSize = (info[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        
        let keyboardHeight:CGFloat = keyboardSize.height
        
        
        UIView.animate(withDuration: 0.25, delay: 0.25, options: UIView.AnimationOptions(), animations: {
            
            self.commentsBoxBottomSpacing.constant = keyboardHeight
            }, completion: nil)
    }
    
    // MARK: - UITextFiled Delegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.voluniteerdDatas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemDetailsMsgCell") as! ItemDetailsMsgCell
        let data = self.voluniteerdDatas[(indexPath as NSIndexPath).row] as? NSDictionary
        let tblView = UIView(frame: CGRect.zero)
        tableView.tableFooterView = tblView
        tableView.tableFooterView?.isHidden = true
        tableView.backgroundColor = UIColor.clear
        cell.updateData(data!)
        return cell
    }
}

// MARK: - Extensions for UITextView
extension ItemDetailsEditingMsgViewController: UITextViewDelegate {
    
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
        if text == "" && textView_comments.text.count == 1 && textView.textColor == UIColor.black{
            textView.text = placeHolderText
            textView.textColor = UIColor.lightGray
            textView.selectedRange = NSMakeRange(0, 0)
        }
        if text == "\n" {
        }
        
        let totalText = textView.text + text
        
        if totalText.count > 0 && totalText != placeHolderText {
            //btn_comments.setImage(UIImage(named: "chat_send"), forState: .Normal)
        }
        else{
            //btn_comments.setImage(UIImage(named: "chat_send_gray"), forState: .Normal)
        }
        
        return true
    }
    
}


