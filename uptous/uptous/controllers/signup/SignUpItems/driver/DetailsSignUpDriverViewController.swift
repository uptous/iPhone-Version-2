//
//  DetailsSignUpDriverViewController.swift
//  uptous
//
//  Created by Roshan Gita  on 10/1/16.
//  Copyright © 2016 UpToUs. All rights reserved.
//

import UIKit
import Alamofire

class DetailsSignUpDriverViewController: GeneralViewController {

    @IBOutlet weak var headingLbl: UILabel!
    @IBOutlet weak var fromLbl: UILabel!
    @IBOutlet weak var toLbl: UILabel!
    @IBOutlet weak var dateTimeLbl: UILabel!
    @IBOutlet weak var phoneTxtField: UITextField!
    @IBOutlet weak var seatsTxtField: UITextField!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var btn_comments: UIButton!
    @IBOutlet var commentsBoxBottomSpacing: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var gifImageView: UIImageView!
    
    //var data: Items!
    var result = NSDictionary()
    var itemsDatas = NSArray()
    var selectedItems: Items!
    var sheetData: SignupSheet!
    var scrollToTop = false
    var offset = 0
    var isCommentEdit_1_replyEdit_2 : Int?
    var list = NSArray()
    var sheetDataID: String!
    var postCounter = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //_ = Custom.buttonCorner(cancelButton)
        
        //headingLbl.text = ("Join the \(sheetData.name!)")
        fromLbl.text = "Driving from: \(selectedItems.name!)"
        toLbl.text = "To: \(selectedItems.extra!)"
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
        
        // Observer Keyboard
        let center: NotificationCenter = NotificationCenter.default
        center.addObserver(self, selector: #selector(DetailsSignUpDriverViewController.keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        center.addObserver(self, selector: #selector(DetailsSignUpDriverViewController.keyboardWillHide(_:)), name: UIResponder.keyboardDidHideNotification, object: nil)
        center.addObserver(self, selector: #selector(DetailsSignUpDriverViewController.keyboardDidChangeFrame(_:)), name: UIResponder.keyboardDidChangeFrameNotification, object: nil)
        
        //let tapRecognizer = UITapGestureRecognizer(target: self , action: #selector(DetailsSignUpDriverViewController.HideTextKeyboard(_:)))
        //tableView.addGestureRecognizer(tapRecognizer)
        
        //self.fetchItems()
        self.itemsDatas = selectedItems.volunteers!
        //self.tableView.reloadData()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //self.tableView.isHidden = true
        tableView.estimatedRowHeight = 110
        tableView.rowHeight = UITableView.automaticDimension
        //let when = DispatchTime.now() + 1 // change 2 to desired number of seconds
        //DispatchQueue.main.asyncAfter(deadline: when) {
        //    self.fetchItems()
        //    self.tableView.reloadData()
       // }
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
                self.dismiss(animated: true, completion: nil)
               //self.navigationController?.popViewController(animated: true)
            }
        })

    }
    
    //Post Comment
    func postComment(phone: String, seats: String) {
        let apiName = SignupItems + ("\(sheetDataID!)") + ("/item/\(selectedItems.Id!)/Add")
        
        var stringPost = "comment=" + seats
        stringPost += "&phone=" + phone
        
        DataConnectionManager.requestPOSTURL1(api: apiName, stringPost: stringPost, success: {
            (response) -> Void in
            
            if response["status"] as? String == "0" {
                DispatchQueue.main.async(execute: {
                    self.dismiss(animated: true, completion: nil)
                    //let _ = self.navigationController?.popViewController(animated: true)
                })
            }else {
                self.postCounter = self.postCounter + 1
                if self.postCounter == 3 {
                    let msg = response["message"] as? String? ?? ""
                    if msg != "" || msg != nil {
                        self.showAlertWithoutCancel(title: "Alert", message: msg)
                    }
                }else {
                    self.postComment(phone: self.phoneTxtField.text!, seats: self.seatsTxtField.text!)
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

    
    func fetchItems() {
        let apiName = SignupItems + ("\(sheetDataID!)")
        DataConnectionManager.requestGETURL(api: apiName, para: ["":""], success: {
            (response) -> Void in
            
            let datas  = (response as? NSArray)!
            let dic = datas.object(at: 0) as? NSDictionary
            //self.updateData(SignupSheet(info: dic))
            let data = (dic?.object(forKey: "items")) as! NSArray
            
            for index in 0..<data.count {
                let dic = data.object(at: index) as? NSDictionary
                if dic?.object(forKey: "id") as? Int == self.selectedItems.Id {
                    self.itemsDatas = dic?.object(forKey: "volunteers") as! NSArray
                    break
                }
            }
            
            self.tableView.reloadData()
        }) {
            (error) -> Void in
            
            let alert = UIAlertController(title: "Alert", message: "Error", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Try Again", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }

    }
    
    
    //MARK:- Keyboard
    @objc func HideTextKeyboard(_ sender: UITapGestureRecognizer?) {
        //textField_comments.resignFirstResponder()
        
        //placeHolderText = "Type comments here.."
        //textView_comments.text = placeHolderText
        //textView_comments.textColor = UIColor.lightGray
        //textView_comments.resignFirstResponder()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        // Check offset and load more feeds
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height;
        
        if (maximumOffset - currentOffset <= 200.0) {
            
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
                self.tableView.scrollToRow(at: indexPath, at: UITableView.ScrollPosition.bottom, animated: animated)
            }
        })
    }
    
    @IBAction func commentsSend_btnAction(_ sender: UIButton) {
        postComment(phone: phoneTxtField.text!, seats: seatsTxtField.text!)
        phoneTxtField.text = ""
        seatsTxtField.text = ""
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
    
    
    //MARK: - Button Action
    @IBAction func back(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
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
        cell.updateData(data!, commentText: "")
        
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

