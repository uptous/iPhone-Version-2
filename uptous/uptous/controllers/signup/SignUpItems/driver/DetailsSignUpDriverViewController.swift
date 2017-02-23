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
    var sheetDataID: String!
    var postCounter = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Custom.buttonCorner(cancelButton)
        
        //headingLbl.text = ("Join the \(sheetData.name!)")
        fromLbl.text = "Driving from: \(selectedItems.name!)"
        toLbl.text = "To: \(selectedItems.extra!)"
        print("\(Custom.dayStringFromTime1(selectedItems.dateTime!))")
        if selectedItems.dateTime == 0 {
            dateTimeLbl.text = ""
            
        }else {
            if Custom.dayStringFromTime4(selectedItems.dateTime!) == "1:00AM" {
                dateTimeLbl.text =  "\(Custom.dayStringSignupItems(selectedItems.dateTime!))"
                
            }else if selectedItems.endTime == "" || selectedItems.endTime == "1:00AM" {
                dateTimeLbl.text = "\(Custom.dayStringSignupItems(selectedItems.dateTime!))," + "" + " \(Custom.dayStringFromTime4(selectedItems.dateTime!))"
            }else {
                dateTimeLbl.text = "\(Custom.dayStringSignupItems(selectedItems.dateTime!)), " + "" + " \(Custom.dayStringFromTime4(selectedItems.dateTime!)) - " + "" + "\(selectedItems.endTime!)"
            }
        }
        //dateTimeLbl.text = ("\(Custom.dayStringFromTime1(selectedItems.dateTime!))")
        
        //phoneTxtField.text = selectedItems.volunteers![0].objectForKey("phone") as? String ?? ""
        //adultsTxtField.text = data.volunteers![0].objectForKey("") as? String ?? "0"
        //childrenTxtField.text = data.volunteers![0].objectForKey("") as? String ?? "0"
        
        textView_comments.placeholder = placeHolderText
        textView_comments.text = placeHolderText
        textView_comments.textColor = UIColor.lightGray
        textField_comments.placeholder = "Type comments here.."
        // Observer Keyboard
        let center: NotificationCenter = NotificationCenter.default
        center.addObserver(self, selector: #selector(DetailsSignUpDriverViewController.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        center.addObserver(self, selector: #selector(DetailsSignUpDriverViewController.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardDidHide, object: nil)
        center.addObserver(self, selector: #selector(DetailsSignUpDriverViewController.keyboardDidChangeFrame(_:)), name: NSNotification.Name.UIKeyboardDidChangeFrame, object: nil)
        
        let tapRecognizer = UITapGestureRecognizer(target: self , action: #selector(DetailsSignUpDriverViewController.HideTextKeyboard(_:)))
        tableView.addGestureRecognizer(tapRecognizer)
        
        
        self.itemsDatas = selectedItems.volunteers!
        self.tableView.reloadData()
        
        /*let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(1 * Double(NSEC_PER_SEC)))
        dispatch_after(delayTime, dispatch_get_main_queue()) {
            //self.updateData(self.data)
            //self.fetchCommentList()
        }*/
        
        /*let imageData = try? Data(contentsOf: Bundle.main.url(forResource: "smiley_test", withExtension: "gif")!)
        let advTimeGif = UIImage.gifImageWithData(imageData!)
        gifImageView.image = advTimeGif*/
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //self.tableView.isHidden = true
        tableView.estimatedRowHeight = 110
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
       /* DataConnectionManager.requestPOSTURL(api: apiName, para: ["":""], success: {
            (response) -> Void in
            print(response)
            
            //self.fetchItems()
            self.navigationController?.popViewController(animated: true)
            
        }) {
            (error) -> Void in
            
            self.navigationController?.popViewController(animated: true)

        }*/

    }
    
    //Post Comment
    func postComment(_ msg: String,phone: String) {
        let apiName = SignupItems + ("\(sheetDataID!)") + ("/item/\(selectedItems.Id!)/Add")
        
        var stringPost = "comment=" + msg
        stringPost += "&phone=" + phone
        
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
                    self.postComment(self.textView_comments.text, phone: self.phoneTxtField.text!)
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

    
    func fetchItems() {
        let apiName = SignupItems + ("\(sheetDataID!)")
        DataConnectionManager.requestGETURL(api: apiName, para: ["":""], success: {
            (response) -> Void in
            print(response)
            
            let datas  = (response as? NSArray)!
            let dic = datas.object(at: 0) as? NSDictionary
            //self.updateData(SignupSheet(info: dic))
            let data = (dic?.object(forKey: "items")) as! NSArray
            
            for index in 0..<data.count {
                let dic = data.object(at: index) as? NSDictionary
                if dic?.object(forKey: "id") as? Int == self.selectedItems.Id {
                    print(dic?.object(forKey: "volunteers"))
                    self.itemsDatas = dic?.object(forKey: "volunteers") as! NSArray
                    break
                }
            }
            print("self.voluniteerdDatas==\(self.itemsDatas.count)")
            
            self.tableView.reloadData()
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
        if textView_comments.text == "Type comments here.." {
            textView_comments.text = ""
        }
        postComment(textView_comments.text, phone: phoneTxtField.text!)
        textView_comments.text = ""
        phoneTxtField.text = ""
        
       /* if (textView_comments.text != "" ||  textView_comments.text != " ") && textView_comments.textColor == UIColor.black {
            
            if phoneTxtField.text == "" || phoneTxtField.text == nil {
                BaseUIView.toast("Please enter Phone Number.")
            }else {
                postComment(textView_comments.text, phone: phoneTxtField.text!)
                textView_comments.text = ""
                phoneTxtField.text == ""
            }
            
        }else {
            BaseUIView.toast("Please enter text")
        }
        return*/
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
    
    
    //MARK: - Button Action
    @IBAction func back(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

//MARK:- TableView
extension DetailsSignUpDriverViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.itemsDatas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "DriverItemCell") as! DriverItemCell
        let data = self.itemsDatas[(indexPath as NSIndexPath).row] as? NSDictionary
        print(data)
        if textView_comments.text.characters.count > 0 {
            cell.updateData(data!, commentText:"")

        }else {
            cell.updateData(data!, commentText:"")
 
        }
        
        return cell
    }
}

// MARK: - Extensions for UITextField
extension DetailsSignUpDriverViewController: UITextFieldDelegate {
    
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
extension DetailsSignUpDriverViewController: UITextViewDelegate {
    
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
