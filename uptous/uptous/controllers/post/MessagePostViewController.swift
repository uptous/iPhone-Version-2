//
//  MessagePostViewController.swift
//  uptous
//
//  Created by Roshan   on 11/20/16.
//  Copyright © 2016 SPA. All rights reserved.
//

import UIKit
import Dropper
import Alamofire

class MessagePostViewController: UIViewController,DropperDelegate {
    
    @IBOutlet var subjectTextField : UITextField!
    @IBOutlet var communityNameTextField : UITextField!
    @IBOutlet var messageTextView : KMPlaceholderTextView!
    var communityTableView = UITableView()
    var communityList = [String]()
    var list = [AnyObject]()
    var selectedCommunityID: Int?
    var selectedCommunity = "0"
    var menuView : UIView!

    @IBOutlet var dropdownButton: UIButton!
    let dropper = Dropper(width: 200, height: 250)

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchCommunity()
    }
    
    //MARK: Fetch Community Records
    func fetchCommunity() {
        DataConnectionManager.requestGETURL(api: TopMenuCommunity, para: ["":""], success: {
            (response) -> Void in
            print(response)
            
            let item = response as! NSArray
            for index in 0..<item.count {
                let dic = item.object(at: index) as! NSDictionary
                let item = Community(info: dic)
                self.list.append(item)
                self.communityList.append(item.name!)
            }
        }) {
            (error) -> Void in
        }
    }
    
    @IBAction func sendButtonClick(_ sender: UIButton) {
        UIView.animate(withDuration: 0.1, animations: {
            self.postComment(self.subjectTextField.text!, content: self.messageTextView.text!)

            }) { (completion) in
                
        }
    }
    
    @IBAction func menuButtonClick(_ sender: UIButton) {
        
        if selectedCommunity == "0" {
            selectedCommunity = "1"
            menuView = UIView()
            menuView.frame = CGRect(x: dropdownButton.frame.origin.x, y: dropdownButton.frame.origin.y+45, width: dropdownButton.frame.size.width, height: 300)
            menuView.backgroundColor = UIColor.white
            self.view.addSubview(menuView)
            
            communityTableView.frame = CGRect(x: 0, y: 0, width: dropdownButton.frame.size.width, height: 300)
            // Delegates and data Source
            communityTableView.dataSource = self
            communityTableView.delegate = self
            communityTableView.register(DropperCell.self, forCellReuseIdentifier: "cell")
            // Styling
            communityTableView.backgroundColor = UIColor.lightGray
            communityTableView.separatorStyle = UITableViewCellSeparatorStyle.singleLine
            communityTableView.bounces = false
            communityTableView.layer.cornerRadius = 9.0
            communityTableView.clipsToBounds = true
            menuView.addSubview(communityTableView)
        }else {
            selectedCommunity = "0"
            menuView.isHidden = true
        }
        
        
    }
    
    @IBAction func back(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    //Post Comment
    func postComment(_ msg: String, content: String) {
        let urlString = PostMessage + ("\(selectedCommunityID!)")
        var stringPost = "subject=" + msg
        stringPost += "&contents=" + content
        
        DataConnectionManager.requestPOSTURL1(api: urlString, stringPost: stringPost, success: {
            (response) -> Void in
            if response["status"] as? String == "0" {
                self.dismiss(animated: true, completion: nil)

            }else {
                //Utility.showAlertWithoutCancel("Alert", message: "Your Post is not Uploaded.")
                let msg = response["message"] as? String
                let alert = UIAlertController(title: "Alert", message: msg, preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

//MARK: TextView Delegate
extension MessagePostViewController: UITextViewDelegate {
    
    /* func textViewDidBeginEditing(_ textView: UITextView) {
        //type_message.hidden = true
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
    }*/
    
}

//MARK: TextField Delegate
extension MessagePostViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }
}

extension MessagePostViewController: UITableViewDelegate, UITableViewDataSource {
    
    public var border: (width: CGFloat, color: UIColor) {
        get { return (communityTableView.layer.borderWidth, UIColor(cgColor: communityTableView.layer.borderColor!)) }
        set {
            let (borderWidth, borderColor) = newValue
            communityTableView.layer.borderWidth = borderWidth
            communityTableView.layer.borderColor = borderColor.cgColor
        }
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! DropperCell
        // Sets up Cell
        // Removes image and text just in case the cell still contains the view
        cell.textItem.removeFromSuperview()
        //cell.last = items.count - 1  // Sets the last item to the cell
        cell.indexPath = indexPath as NSIndexPath? // Sets index path to the cell
        cell.borderColor = border.color // Sets the border color for the seperator
       // let item = items[indexPath.row]
        cell.backgroundColor = UIColor.white
        cell.textItem.textColor = UIColor.black
        cell.textItem.numberOfLines = 2
        cell.textItem.textAlignment = .center
        cell.textItem.font = UIFont.systemFont(ofSize: 16.0)
        cell.cellType = .Text
        cell.textItem.text = self.communityList[indexPath.row]
        
        return cell
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.communityList.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let community = self.list[indexPath.row] as! Community
        selectedCommunityID = community.communityId
        communityNameTextField.text = community.name
        self.menuView.removeFromSuperview()
    }
}



