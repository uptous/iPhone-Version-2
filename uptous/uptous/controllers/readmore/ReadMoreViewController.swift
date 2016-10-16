//
//  ReadMoreViewController.swift
//  uptous
//
//  Created by Roshan Gita  on 8/25/16.
//  Copyright © 2016 SPA. All rights reserved.
//

import UIKit
import Alamofire

class ReadMoreViewController: GeneralViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var groupNameLbl: UILabel!
    @IBOutlet weak var msgNameLbl: UILabel!
    @IBOutlet weak var newsItemNameLbl: UILabel!
    @IBOutlet weak var ownerPhotoImgView: CircularImageView!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var newsItemDescriptionLbl: UILabel!
    @IBOutlet weak var commentsTextView: UIView!
    @IBOutlet weak var textField_comments: UITextField!
    @IBOutlet weak var btn_comments: UIButton!
    @IBOutlet var commentsBoxBottomSpacing: NSLayoutConstraint!
    @IBOutlet weak var textView_comments: HPTextViewInternal!
    @IBOutlet weak var ownerView: UIView!
    @IBOutlet weak var ownerNameLbl: UILabel!
    
    var data: Feed!
    var scrollToTop = false
    var offset = 0
    var placeHolderText = "Type comments here.."
    var isCommentEdit_1_replyEdit_2 : Int?

    //var commentList = [Comment]()
    var commentList = NSArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textView_comments.placeholder = placeHolderText
        textView_comments.text = placeHolderText
        textView_comments.textColor = UIColor.lightGrayColor()
        textField_comments.placeholder = "Type comments here.."
        // Observer Keyboard
        let center: NSNotificationCenter = NSNotificationCenter.defaultCenter()
        center.addObserver(self, selector: #selector(ReadMoreViewController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        center.addObserver(self, selector: #selector(ReadMoreViewController.keyboardWillHide(_:)), name: UIKeyboardDidHideNotification, object: nil)
        center.addObserver(self, selector: #selector(ReadMoreViewController.keyboardDidChangeFrame(_:)), name: UIKeyboardDidChangeFrameNotification, object: nil)
        
        let tapRecognizer = UITapGestureRecognizer(target: self , action: #selector(ReadMoreViewController.HideTextKeyboard(_:)))
        tableView.addGestureRecognizer(tapRecognizer)
        
        let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(1 * Double(NSEC_PER_SEC)))
        dispatch_after(delayTime, dispatch_get_main_queue()) {
            self.updateData(self.data)
            self.fetchCommentList()
        }
        Custom.fullCornerView(ownerView)

    }
    
    override func viewWillAppear(animated: Bool) {
        self.tableView.hidden = true
        tableView.estimatedRowHeight = 110
        tableView.rowHeight = UITableViewAutomaticDimension
    }

    func attributedString(str: String) -> NSAttributedString? {
        let attributes = [
            NSUnderlineStyleAttributeName : NSUnderlineStyle.StyleSingle.rawValue
        ]
        let attributedString = NSAttributedString(string: str, attributes: attributes)
        return attributedString
    }
    
    func updateData(data: Feed) {
        
        if data.ownerPhotoUrl == "https://dsnn35vlkp0h4.cloudfront.net/images/blank_image.gif" {
            ownerView.hidden = false
            ownerPhotoImgView.hidden = true
            let stringArray = data.ownerName?.componentsSeparatedByString(" ")
            let firstName = stringArray![0]
            let secondName = stringArray![1]
            let resultString = "\(firstName.characters.first!)\(secondName.characters.first!)"
            
            ownerNameLbl.text = resultString
            let color1 = Utility.hexStringToUIColor(data.ownerBackgroundColor!)
            let color2 = Utility.hexStringToUIColor(data.ownerTextColor!)
            ownerView.backgroundColor = color1
            ownerNameLbl.textColor = color2
            
            
        }else {
            ownerView.hidden = true
            ownerPhotoImgView.hidden = false
            if let avatarUrl = data.ownerPhotoUrl {
                ownerPhotoImgView.setUserAvatar(avatarUrl)
            }
        }

        
        let name = data.ownerName!.componentsSeparatedByString(" ")
        msgNameLbl.text = ("\(name[0]) message")
        newsItemNameLbl.text = data.newsItemName
        newsItemDescriptionLbl.text = data.newsItemDescription!.decodeHTML()
        tableView.reloadData()
        collectionView.reloadData()
        dateLbl.text = ("\(Custom.dayStringFromTime(data.createDate!))")
    }
    
    //Post Comment
    func postComment(msg: String) {
        let apiName = PostCommentAPI + ("\(data.feedId!)")
        ActivityIndicator.show()
        let parameters = ["contents": msg]
        
        Alamofire.request(.POST, apiName, headers: appDelegate.loginHeaderCredentials,parameters: parameters)
            .responseJSON { response in
                ActivityIndicator.hide()
                //if self.commentList.count > 0 {
                    self.fetchCommentList()
                //}
        }
    }
    
    //Fetch Comment
    func fetchCommentList() {
        let apiName = FetchCommentAPI + ("\(data.feedId!)")
        ActivityIndicator.show()
        
        Alamofire.request(.GET, apiName, headers: appDelegate.loginHeaderCredentials)
            .responseJSON { response in
                if let JSON = response.result.value {
                    ActivityIndicator.hide()

                    self.commentList = JSON as! NSArray
                    if self.commentList.count > 0 {
                        self.tableView.hidden = false
                        self.tableView.reloadData()
                    }
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
            let numberOfRows = (self.commentList.count) - self.tableView.numberOfRowsInSection(numberOfSections-1)
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
        ActivityIndicator.hide()
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

//MARK:- TableView
extension ReadMoreViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.commentList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("ReadMoreCell") as! ReadMoreCell
        let data = self.commentList[indexPath.row] as? NSDictionary
        cell.updateData(Comment(info: data))
        
        return cell
    }
    
}

//MARK:- CollectionView
extension ReadMoreViewController: UICollectionViewDelegate,UICollectionViewDataSource {
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("ImageCell", forIndexPath: indexPath) as! ImageCell
        
        if let newsItemPhotoUrl = data.newsItemPhoto {
            CustomImgView.setUserAvatar(newsItemPhotoUrl,imgView: cell.imageView)
        }

        
        return cell
    }
}

// MARK: - Extensions for UITextView

extension ReadMoreViewController: UITextViewDelegate {
    
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


