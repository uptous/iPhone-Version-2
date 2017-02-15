//
//  ReadOnlyCommentViewController.swift
//  uptous
//
//  Created by Roshan Gita  on 10/8/16.
//  Copyright © 2016 SPA. All rights reserved.
//

import UIKit
import Alamofire


class ReadOnlyCommentViewController: GeneralViewController {

    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var headingLbl: UILabel!
    @IBOutlet weak var eventDateLbl: UILabel!
    
    var selectedItems: Items!
    var data: SignupSheet!
    var sheetDataID: String!
    @IBOutlet weak var detailHeightContraint: NSLayoutConstraint!
    @IBOutlet weak var detailViewHeightContraint: NSLayoutConstraint!


    var voluniteerdDatas = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Custom.cornerView(contentView)
        nameLbl.text = selectedItems.name!
        headingLbl.text = selectedItems.name!
        eventDateLbl.text = ("\(Custom.dayStringFromTime3(selectedItems.dateTime!))")
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        voluniteerdDatas.removeAllObjects()
        for index in 0..<selectedItems.volunteers!.count {
            let volunteer = selectedItems.volunteers!.object(at: index) as? NSDictionary
            voluniteerdDatas.add(volunteer!)
        }
        tableView.estimatedRowHeight = 75
        tableView.rowHeight = UITableViewAutomaticDimension
        
        let when = DispatchTime.now() + 1 // change 2 to desired number of seconds
        DispatchQueue.main.asyncAfter(deadline: when) {
            print(self.selectedItems.name!)
            print(self.calculateHeight(self.selectedItems.name!, width: self.nameLbl.frame.size.width))
            self.detailHeightContraint.constant = 55
            self.detailViewHeightContraint.constant = 110
            
            if self.calculateHeight(self.selectedItems.name!, width: self.nameLbl.frame.size.width) > 55 {
                self.detailHeightContraint.constant = self.calculateHeight(self.selectedItems.name!, width: self.nameLbl.frame.size.width) + 10
                self.detailViewHeightContraint.constant = self.detailViewHeightContraint.constant + self.detailHeightContraint.constant
            }
            //
        }
        
    }
    
    //Mark : Get Label Height with text
    func calculateHeight(_ text:String, width:CGFloat) -> CGFloat {
        let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = UIFont(name: "Helvetica Neue Bold", size: 20)
        label.text = text
        
        label.sizeToFit()
        return label.frame.height
    }
    
    @IBAction func back(_ sender: UIButton) {
        DispatchQueue.main.async(execute: {
            let _ = self.navigationController?.popViewController(animated: true)
        })
    }
    
    
    
    //MARK:- Delete
    @IBAction func deleteButtonClick(_ sender: UIButton) {
        let alertView = UIAlertController(title: "UpToUs", message: "Are you sure that you want to delete your assignment?", preferredStyle: .alert)
        alertView.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (alertAction) -> Void in
            
            DispatchQueue.main.async(execute: {
                self.delete()
            })
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
                DispatchQueue.main.async(execute: {
                    let _ = self.navigationController?.popViewController(animated: true)
                })
            }else {
                let msg = response["message"] as? String
               self.showAlertWithoutCancel(title: "Error", message: msg)
            }
        })
    }
    
    func showAlertWithoutCancel(title:String?, message:String?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
            //self.navigationController?.popViewController(animated: true)
            print("you have pressed OK button");
        }
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

//MARK:- TableView
extension ReadOnlyCommentViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.voluniteerdDatas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReadOnlyCommentCell") as! ReadOnlyCommentCell
        let data = self.voluniteerdDatas[(indexPath as NSIndexPath).row] as? NSDictionary
        let tblView = UIView(frame: CGRect.zero)
        tableView.tableFooterView = tblView
        tableView.tableFooterView?.isHidden = true
        tableView.backgroundColor = UIColor.clear
        cell.updateView(data!)
        return cell
    }
        
}



