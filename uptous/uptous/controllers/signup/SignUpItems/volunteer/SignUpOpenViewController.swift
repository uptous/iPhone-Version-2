//
//  SignUpOpenViewController.swift
//  uptous
//
//  Created by Roshan Gita  on 10/8/16.
//  Copyright © 2016 UpToUs. All rights reserved.
//

import UIKit
import Alamofire


class SignUpOpenViewController: GeneralViewController {
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var notesLbl: UILabel!
    @IBOutlet weak var contact1Lbl: UILabel!
    @IBOutlet weak var contact2Lbl: UILabel!
    @IBOutlet weak var eventDateLbl: UILabel!
    @IBOutlet weak var eventTimeLbl: UILabel!
    @IBOutlet weak var cutoffDateLbl: UILabel!
    @IBOutlet weak var cutoffTimeLbl: UILabel!
    @IBOutlet weak var contact1PhotoImgView: UIImageView!
    @IBOutlet weak var contact2PhotoImgView: UIImageView!
    @IBOutlet weak var owner1View: UIView!
    @IBOutlet weak var owner1NameLbl: UILabel!
    @IBOutlet weak var owner2View: UIView!
    @IBOutlet weak var owner2NameLbl: UILabel!
    @IBOutlet weak var detailHeightContraint: NSLayoutConstraint!
    @IBOutlet weak var detailViewHeightContraint: NSLayoutConstraint!
    @IBOutlet weak var organizerViewYContraint: NSLayoutConstraint!
    @IBOutlet weak var eventViewYContraint: NSLayoutConstraint!
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var organizerView: UIView!
    @IBOutlet weak var organizerLbl: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!

    
    var data: SignupSheet!
    var data1: Feed!
    var driverDatas = NSArray()
    var itemsDatas = NSArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = 81
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    func updateData(_ data: SignupSheet) {
        appDelegate.globalSignUpData = data
        
        if data.contact == "" && data.contact2 == "" {
            let controller = self.storyboard?.instantiateViewController(withIdentifier: "SignUpType1ViewController") as! SignUpType1ViewController
            controller.data = data
            controller.data1 = data1
            controller.signUpType = "101"
            self.present(controller, animated: true, completion: nil)
        }else {
            let controller = self.storyboard?.instantiateViewController(withIdentifier: "SignUpType3ViewController") as! SignUpType3ViewController
            controller.data = data
            controller.data1 = data1
            controller.signUpType = "101"
            self.present(controller, animated: true, completion: nil)
        }
    }
    
    @IBAction func back(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.estimatedRowHeight = 81
        tableView.rowHeight = UITableView.automaticDimension
        
        let when = DispatchTime.now() + 1 // change 2 to desired number of seconds
        DispatchQueue.main.asyncAfter(deadline: when) {
            self.fetchDriverItems()
        }
    }
    
    //MARK: Fetch Driver Records
    func fetchDriverItems() {
        let apiName: String!
        if data1 != nil {
            apiName = SignupItems + ("\(data1.newsItemId!)")
        }else {
            apiName = SignupItems + ("\(data.id!)")
        }

        DataConnectionManager.requestGETURL(api: apiName, para: ["":""], success: {
            (response) -> Void in
            self.driverDatas = (response as? NSArray)!
            let dic = self.driverDatas.object(at: 0) as? NSDictionary
            self.updateData(SignupSheet(info: dic))
            self.itemsDatas = (dic?.object(forKey: "items")) as! NSArray
            self.tableView.reloadData()
        }) {
            (error) -> Void in
            
            let alert = UIAlertController(title: "Alert", message: "Error", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Try Again", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

//MARK:- TableView
extension SignUpOpenViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.itemsDatas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "VolunteerwCell") as! VolunteerwCell
        let data = self.itemsDatas[(indexPath as NSIndexPath).row] as? NSDictionary
        cell.updateView(Items(info: data!))
        cell.setNeedsUpdateConstraints()
        cell.updateConstraintsIfNeeded()
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let dic = self.itemsDatas[(indexPath as NSIndexPath).row] as? NSDictionary
        let item = Items(info: dic!)
        if item.volunteerStatus == "Open" {
            let controller = self.storyboard?.instantiateViewController(withIdentifier: "ItemDetailsEditingMsgViewController") as! ItemDetailsEditingMsgViewController
            controller.selectedItems = item
            if data1 != nil {
                controller.sheetDataID = ("\(data1.newsItemId!)")
            }else {
                controller.sheetDataID = ("\(self.data.id!)")
            }
            self.navigationController?.pushViewController(controller, animated: true)
            
        }else if item.volunteerStatus == "Volunteered" || item.volunteerStatus == "Full"{
            let controller = self.storyboard?.instantiateViewController(withIdentifier: "ReadOnlyCommentViewController") as! ReadOnlyCommentViewController
            controller.selectedItems = item
            if data1 != nil {
                controller.sheetDataID = ("\(data1.newsItemId!)")
            }else {
                controller.sheetDataID = ("\(data.id!)")
            }
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }    
}



