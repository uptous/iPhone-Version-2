//
//  CommentViewController.swift
//  uptous
//
//  Created by Roshan Gita  on 9/11/16.
//  Copyright © 2016 SPA. All rights reserved.
//

import UIKit
import Alamofire

class CommentViewController: GeneralViewController {

    @IBOutlet weak var groupNameLbl: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var msgNameLbl: UILabel!
    @IBOutlet weak var newsItemNameLbl: UILabel!
    @IBOutlet weak var ownerPhotoImgView: UIImageView!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var newsItemDescriptionLbl: UILabel!
    @IBOutlet weak var replyToBtn: UIButton!
    @IBOutlet weak var commentsTextView: UIView!
    @IBOutlet weak var textField_comments: UITextField!
    @IBOutlet weak var btn_comments: UIButton!
    @IBOutlet var commentsBoxBottomSpacing: NSLayoutConstraint!
    @IBOutlet weak var textView_comments: HPTextViewInternal!
    @IBOutlet weak var ownerView: UIView!
    @IBOutlet weak var ownerNameLbl: UILabel!
    @IBOutlet weak var contentsView: UIView!
    
    @IBOutlet weak var viewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var labelHeightConstraint: NSLayoutConstraint!
    

    var data: Feed!
    var commentList = NSArray()
    var scrollToTop = false
    var offset = 0
    var placeHolderText = "Type comments here.."
    var isCommentEdit_1_replyEdit_2 : Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        contentsView.layer.borderColor = UIColor.lightGray.cgColor
        contentsView.layer.borderWidth = 1.5
        contentsView.layer.cornerRadius = 10.0

        textView_comments.placeholder = placeHolderText
        textView_comments.text = placeHolderText
        textView_comments.textColor = UIColor.lightGray
        textField_comments.placeholder = "Type comments here.."
        // Observer Keyboard
        let center: NotificationCenter = NotificationCenter.default
        center.addObserver(self, selector: #selector(ReplyAllViewController.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        center.addObserver(self, selector: #selector(ReplyAllViewController.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardDidHide, object: nil)
        center.addObserver(self, selector: #selector(ReplyAllViewController.keyboardDidChangeFrame(_:)), name: NSNotification.Name.UIKeyboardDidChangeFrame, object: nil)
        
        let tapRecognizer = UITapGestureRecognizer(target: self , action: #selector(ReplyAllViewController.HideTextKeyboard(_:)))
        tableView.addGestureRecognizer(tapRecognizer)
        
        let delayTime = DispatchTime.now() + Double(Int64(1 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: delayTime) {
            self.updateData(self.data)
            self.fetchCommentList()
        }
        Custom.fullCornerView(ownerView)
        ownerPhotoImgView.layer.cornerRadius = 30.0
        ownerPhotoImgView.layer.masksToBounds = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tableView.isHidden = true
        
        tableView.estimatedRowHeight = 110
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    //Post Comment
    func postComment(_ msg: String) {
        let apiName = PostCommentAPI + ("\(data.feedId!)")
        var stringPost = "contents=" + msg
        DataConnectionManager.requestPOSTURL1(api: apiName, stringPost: stringPost, success: {
            (response) -> Void in
            print(response)
            
            print(response["status"])
            if response["status"] as? String == "0" {
                self.fetchCommentList()
            }
        })
    }
    
    func showAlertWithoutCancel(title:String?, message:String?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
            self.fetchCommentList()
            print("you have pressed OK button");
        }
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    //Fetch Comment
    func fetchCommentList() {
        let apiName = FetchCommentAPI + ("\(data.feedId!)")
        DataConnectionManager.requestGETURL(api: apiName, para: ["":""], success: {
            (response) -> Void in
            print(response)
            
            self.commentList = response as! NSArray
            if self.commentList.count > 0 {
                self.tableView.isHidden = false
                self.tableView.reloadData()
            }
        }) {
            (error) -> Void in
            
            let alert = UIAlertController(title: "Alert", message: "Error", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Try Again", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func HideTextKeyboard(_ sender: UITapGestureRecognizer?) {
        placeHolderText = "Type comments here.."
        textView_comments.text = placeHolderText
        textView_comments.textColor = UIColor.lightGray
        textView_comments.resignFirstResponder()
        
    }
    
    func tableViewScrollToBottom(_ animated: Bool) {
        
        let delay = 0.1 * Double(NSEC_PER_SEC)
        let time = DispatchTime.now() + Double(Int64(delay)) / Double(NSEC_PER_SEC)
        
        DispatchQueue.main.asyncAfter(deadline: time, execute: {
            
            let numberOfRows = (self.commentList.count) - 2
            
            if numberOfRows > 0 {
                let indexPath = IndexPath(row: 0, section: numberOfRows)
                self.tableView.scrollToRow(at: indexPath, at: UITableViewScrollPosition.bottom, animated: animated)
            }
            
        })
    }
    
    @IBAction func commentsSend_btnAction(_ sender: UIButton) {
        if (textView_comments.text != "" ||  textView_comments.text != " ") && textView_comments.textColor == UIColor.black {
            postComment(textView_comments.text)
            textView_comments.text = ""
            
        }else {
            BaseUIView.toast("Please enter text")
        }
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
    
    
    func attributedString(_ str: String) -> NSAttributedString? {
        let attributes = [
            NSUnderlineStyleAttributeName : NSUnderlineStyle.styleSingle.rawValue
        ]
        let attributedString = NSAttributedString(string: str, attributes: attributes)
        return attributedString
    }
    
    
    
    func updateData(_ data: Feed) {
        
        if data.ownerPhotoUrl == "https://dsnn35vlkp0h4.cloudfront.net/images/blank_image.gif" {
            ownerView.isHidden = false
            ownerPhotoImgView.isHidden = true
            let stringArray = data.ownerName?.components(separatedBy: " ")
            let firstName = stringArray![0]
            let secondName = stringArray![1]
            let resultString = "\(firstName.characters.first!)\(secondName.characters.first!)"
            
            ownerNameLbl.text = resultString
            let color1 = Utility.hexStringToUIColor(hex: data.ownerBackgroundColor!)
            let color2 = Utility.hexStringToUIColor(hex: data.ownerTextColor!)
            ownerView.backgroundColor = color1
            ownerNameLbl.textColor = color2
            
            
        }else {
            ownerView.isHidden = true
            ownerPhotoImgView.isHidden = false
            if let avatarUrl = data.ownerPhotoUrl {
                ownerPhotoImgView.isHidden = false
                //ownerPhotoImgView.setUserAvatar(avatarUrl)
                let block: SDWebImageCompletionBlock = {(image: UIImage?, error: Error?, cacheType: SDImageCacheType!, imageURL: URL?) -> Void in
                    self.ownerPhotoImgView.image = image
                }
                ownerPhotoImgView.sd_setImage(with: URL(string:avatarUrl) as URL!, completed:block)
            }        }

        
        let attributedStr = NSMutableAttributedString()
        if data.communityName != "" {
            let attributedString1 = NSAttributedString(string: ("\(data.ownerName!) in: "), attributes: nil)
            attributedStr.append(attributedString1)
            attributedStr.append(attributedString(" \(data.communityName!)")!)
        }else{
            
            let attributedString1 = NSAttributedString(string: ("\(data.ownerName!)"), attributes: nil)
            attributedStr.append(attributedString1)
        }
        groupNameLbl.attributedText = attributedStr
        
        let name = data.ownerName!.components(separatedBy: " ")
        msgNameLbl.text = ("\(name[0]) message")
        newsItemNameLbl.text = data.newsItemName
        newsItemDescriptionLbl.text = data.newsItemDescription!
        let font = UIFont(name: "Helvetica Neue", size: 16.0)
        let height = Custom.heightForView(text: data.newsItemDescription!, font: font!, width: newsItemDescriptionLbl.frame.size.width)
        
        if height > 44 {
            viewHeightConstraint.constant = viewHeightConstraint.constant + height 
            labelHeightConstraint.constant = labelHeightConstraint.constant + height
        }
        dateLbl.text = ("\(Custom.dayStringFromTime(data.createDate!))")
    }
    
    //MARK: - Button Action
    @IBAction func backBtnClick(_ sender: UIButton) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

//MARK:- TableView
extension CommentViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.commentList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReadMoreCell") as! ReadMoreCell
        let data = commentList[(indexPath as NSIndexPath).row] as? NSDictionary
        print(Comment(info: data))
        cell.updateData(Comment(info: data!))
        return cell
    }
    
}

// MARK: - Extensions for UITextView

extension CommentViewController: UITextViewDelegate {
    
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

extension String {
    init(htmlEncodedString: String) {
        self.init()
        guard let encodedData = htmlEncodedString.data(using: .utf8) else {
            self = htmlEncodedString
            return
        }
        
        let attributedOptions: [String : Any] = [
            NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
            NSCharacterEncodingDocumentAttribute: String.Encoding.utf8.rawValue
        ]
        
        do {
            let attributedString = try NSAttributedString(data: encodedData, options: attributedOptions, documentAttributes: nil)
            self = attributedString.string
        } catch {
            print("Error: \(error)")
            self = htmlEncodedString
        }
    }
}


