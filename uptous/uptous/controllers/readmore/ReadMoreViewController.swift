//
//  ReadMoreViewController.swift
//  uptous
//
//  Created by Roshan Gita  on 8/25/16.
//  Copyright © 2016 UpToUs. All rights reserved.
//

import UIKit
import Alamofire

class ReadMoreViewController: GeneralViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var groupNameLbl: UILabel!
    @IBOutlet weak var msgNameLbl: UILabel!
    @IBOutlet weak var newsItemNameLbl: UILabel!
    @IBOutlet weak var ownerPhotoImgView: UIImageView!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var newsItemDescriptionLbl: UILabel!
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
    var scrollToTop = false
    var offset = 0
    var placeHolderText = "Type comments here.."
    var isCommentEdit_1_replyEdit_2 : Int?

    //var commentList = [Comment]()
    var commentList = NSArray()
    
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
        center.addObserver(self, selector: #selector(ReadMoreViewController.keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        center.addObserver(self, selector: #selector(ReadMoreViewController.keyboardWillHide(_:)), name: UIResponder.keyboardDidHideNotification, object: nil)
        center.addObserver(self, selector: #selector(ReadMoreViewController.keyboardDidChangeFrame(_:)), name: UIResponder.keyboardDidChangeFrameNotification, object: nil)
        
        let tapRecognizer = UITapGestureRecognizer(target: self , action: #selector(ReadMoreViewController.HideTextKeyboard(_:)))
        tableView.addGestureRecognizer(tapRecognizer)
        
        let delayTime = DispatchTime.now() + Double(Int64(1 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: delayTime) {
            self.updateData(self.data)
            self.fetchCommentList()
        }
        _ = Custom.fullCornerView(ownerView)
        ownerPhotoImgView.layer.cornerRadius = 25.0
        ownerPhotoImgView.layer.masksToBounds = true

    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tableView.isHidden = true
        
        tableView.estimatedRowHeight = 110
        tableView.rowHeight = UITableView.automaticDimension
    }

    func attributedString(_ str: String) -> NSAttributedString? {
        let attributes = [
            convertFromNSAttributedStringKey(NSAttributedString.Key.underlineStyle) : NSUnderlineStyle.single.rawValue
        ]
        let attributedString = NSAttributedString(string: str, attributes: convertToOptionalNSAttributedStringKeyDictionary(attributes))
        return attributedString
    }
    
    func updateData(_ data: Feed) {
        
        if data.ownerPhotoUrl == "https://dsnn35vlkp0h4.cloudfront.net/images/blank_image.gif" {
            ownerView.isHidden = false
            ownerPhotoImgView.isHidden = true
            let stringArray = data.ownerName?.components(separatedBy: " ")
            let firstName = stringArray![0]
            let secondName = stringArray![1]
            let resultString = "\(firstName.prefix(1))\(secondName.prefix(1))"
            
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
                //ownerPhotoImgView.sd_setImage(with: URL(string:avatarUrl) as URL!, completed:block)
                let url = URL(string: avatarUrl)
                ownerPhotoImgView.sd_setImage(with: url, completed: block)
            }
        }

        
        let name = data.ownerName!.components(separatedBy: " ")
        msgNameLbl.text = ("\(name[0]) message")
        let decodedString = data.newsItemName?.removingPercentEncoding!
        newsItemNameLbl.text =   decodedString
        
        //newsItemNameLbl.text = data.newsItemName
        //newsItemDescriptionLbl.text = data.newsItemDescription!
        
        let font = UIFont(name: "Helvetica Neue", size: 16.0)
        
        let height = Custom.heightForView(text: data.newsItemName!, font: font!, width: newsItemNameLbl.frame.size.width)
        
        if height > 41 {
            viewHeightConstraint.constant = viewHeightConstraint.constant + height + 10
            labelHeightConstraint.constant = labelHeightConstraint.constant + height
        }
        
        tableView.reloadData()
        collectionView.reloadData()
        dateLbl.text = ("\(Custom.dayStringFromTime(data.createDate!))")
    }
    
    //Post Comment
    func postComment(_ msg: String) {
        let apiName = PostCommentAPI + ("\(data.feedId!)")
       
        let stringPost = "contents=" + msg
        DataConnectionManager.requestPOSTURL1(api: apiName, stringPost: stringPost, success: {
            (response) -> Void in
            print(response)
            
            print(response["status"]!)
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
            
            let alert = UIAlertController(title: "Alert", message: "Error", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Try Again", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    //MARK:- Keyboard
    @objc func HideTextKeyboard(_ sender: UITapGestureRecognizer?) {
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
            let numberOfRows = (self.commentList.count) - self.tableView.numberOfRows(inSection: numberOfSections-1)
            if numberOfRows > 0 {
                let indexPath = IndexPath(row: 0, section: numberOfRows)
                self.tableView.scrollToRow(at: indexPath, at: UITableView.ScrollPosition.bottom, animated: animated)
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
    

    
    
    //MARK: - Button Action
    @IBAction func backBtnClick(_ sender: UIButton) {
        
        self.dismiss(animated: true, completion: nil)
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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.commentList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReadMoreCell") as! ReadMoreCell
        let data = self.commentList[(indexPath as NSIndexPath).row] as? NSDictionary
        cell.updateData(Comment(info: data))
        
        return cell
    }
    
}

//MARK:- CollectionView
extension ReadMoreViewController: UICollectionViewDelegate,UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as! ImageCell
        
        if let newsItemPhotoUrl = data.newsItemPhoto {
            CustomImgView.setUserAvatar(newsItemPhotoUrl,imgView: cell.imageView)
        }

        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let cellSpacing = CGFloat(7) //Define the space between each cell
        let leftRightMargin = CGFloat(20) //If defined in Interface Builder for "Section Insets"
        let numColumns = CGFloat(2) //The total number of columns you want
        
        let totalCellSpace = cellSpacing * (numColumns - 1)
        //collectionViewLayout.sectionInset = UIEdgeInsets(top: 0, left: 5, bottom: 20, right: 5)
        
        
        let screenWidth = UIScreen.main.bounds.width
        let width = (screenWidth - leftRightMargin - totalCellSpace) / numColumns
        let height = CGFloat(200) //whatever height you want
        
        return CGSize(width: width, height: height)
    }
}

// MARK: - Extensions for UITextView

extension ReadMoreViewController: UITextViewDelegate {
    
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



// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromNSAttributedStringKey(_ input: NSAttributedString.Key) -> String {
	return input.rawValue
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToOptionalNSAttributedStringKeyDictionary(_ input: [String: Any]?) -> [NSAttributedString.Key: Any]? {
	guard let input = input else { return nil }
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (NSAttributedString.Key(rawValue: key), value)})
}
