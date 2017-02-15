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
    var sheetDataID: String!
    var postCounter = 0 

    
    override func viewDidLoad() {
        super.viewDidLoad()
        textView_comments.placeholder = placeHolderText
        textView_comments.text = placeHolderText
        textView_comments.textColor = UIColor.lightGray
        textField_comments.placeholder = "Type comments here.."
        // Observer Keyboard
        let center: NotificationCenter = NotificationCenter.default
        center.addObserver(self, selector: #selector(ItemDetailsEditingMsgViewController.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        center.addObserver(self, selector: #selector(ItemDetailsEditingMsgViewController.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardDidHide, object: nil)
        center.addObserver(self, selector: #selector(ItemDetailsEditingMsgViewController.keyboardDidChangeFrame(_:)), name: NSNotification.Name.UIKeyboardDidChangeFrame, object: nil)
        let tapRecognizer = UITapGestureRecognizer(target: self , action: #selector(ItemDetailsEditingMsgViewController.HideTextKeyboard(_:)))
        tableView.addGestureRecognizer(tapRecognizer)
        
        Custom.cornerView(contentView)
        updateData(selectedItems)
        
        voluniteerdDatas = selectedItems.volunteers!
        print(voluniteerdDatas)
        
        //headingLbl.text = data.name
        msgLbl.text = selectedItems.name
        eventDateLbl.text = ("\(Custom.dayStringFromTime3(selectedItems.dateTime!))")
        
        
        let x = selectedItems.numVolunteers! - selectedItems.volunteerCount!
        let y = selectedItems.numVolunteers!
        if y == 0 {
            spotLbl.text = "More spots are open"

        }else {
            let text = ("\(x) out of ") + ("\(y) spots open")
            spotLbl.text = text
        }
        
    }
    
    func updateData(_ data: Items) {
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
    
    
    @IBAction func back(_ sender: UIButton) {
        DispatchQueue.main.async(execute: {
            let _ = self.navigationController?.popViewController(animated: true)
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.estimatedRowHeight = 94
        
        tableView.rowHeight = UITableViewAutomaticDimension
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
            print(response)
            
            print(response["status"])
            if response["status"] as? String == "0" {
                self.navigationController?.popViewController(animated: true)
            }
        })
    }
    
    //Post Comment
    func postComment(_ msg: String) {
        //let opportunityID = selectedItems.Id
        let apiName = SignupItems + ("\(sheetDataID!)") + ("/item/\(selectedItems.Id!)/Add")
        var stringPost = "comment=" + msg
        stringPost += "&phone=" + ""
        
        DataConnectionManager.requestPOSTURL1(api: apiName, stringPost: stringPost, success: {
            (response) -> Void in
            print(response)
            
            if response["status"] as? String == "0" {
                DispatchQueue.main.async(execute: {
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
                    self.postComment(self.textView_comments.text)
                }
            }
        })
    }

    func showAlertWithoutCancel(title:String?, message:String?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
            self.navigationController?.popViewController(animated: true)
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
            print(response)
            
            self.driverDatas = (response as? NSArray)!
            let dic = self.driverDatas.object(at: 0) as? NSDictionary
            //self.updateData(SignupSheet(info: dic))
            let data = (dic?.object(forKey: "items")) as! NSArray
            
            for index in 0..<data.count {
                let dic = data.object(at: index) as? NSDictionary
                if dic?.object(forKey: "id") as? Int == self.selectedItems.Id {
                    print(dic?.object(forKey: "volunteers"))
                    self.voluniteerdDatas = dic?.object(forKey: "volunteers") as! NSArray
                    break
                }
            }
            print("self.voluniteerdDatas==\(self.voluniteerdDatas.count)")
            
            self.tableView.reloadData()
            
        }) {
            (error) -> Void in
            
            let alert = UIAlertController(title: "Alert", message: "Error", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Try Again", style: UIAlertActionStyle.default, handler: nil))
            //self.present(alert, animated: true, completion: nil)
        }
    }
    
    //***************Comment***************
    
    //MARK:- Keyboard
    func HideTextKeyboard(_ sender: UITapGestureRecognizer?) {
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
                self.tableView.scrollToRow(at: indexPath, at: UITableViewScrollPosition.bottom, animated: animated)
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
        var tblView = UIView(frame: CGRect.zero)
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


