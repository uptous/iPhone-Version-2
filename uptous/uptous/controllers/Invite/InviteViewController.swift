//
//  InviteViewController.swift
//  uptous
//
//  Created by Roshan Gita  on 12/2/16.
//  Copyright © 2016 UpToUs. All rights reserved.
//

import UIKit

class InviteViewController: GeneralViewController,InviteCellDelegate {

    @IBOutlet weak var notifyBtn: UIButton!
    @IBOutlet weak var inviteLbl: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var invitationLbl: UILabel!
    @IBOutlet weak var invitationBtn: UIButton!
    
    var inviteList = [Invite]()
    
    fileprivate struct inviteCellConstants {
        static var cellIdentifier:String = "InviteCell"
        static var rowHeight:CGFloat! = 87
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        notifyBtn.layer.borderWidth = CGFloat(1.0)
        notifyBtn.layer.cornerRadius = 8.0

        let inviteNib = UINib(nibName: "InviteCell", bundle: nil)
        tableView.register(inviteNib, forCellReuseIdentifier: inviteCellConstants.cellIdentifier as String)
        
        fetchInviteList()
    }
    
    func fetchInviteList() {
        self.inviteList.removeAll()
        DataConnectionManager.requestGETURL(api: Invites, para: ["":""], success: {
            (response) -> Void in
            let list = response as! NSArray
            
            for i in 0..<list.count {
                let result = list.object(at: i) as? NSDictionary
                self.inviteList.append(Invite(info: result))
            }
            self.invitationLbl.text = ("\(list.count)")
            self.notifyBtn.setTitle(("\(list.count)"), for: .normal)
            self.tableView.reloadData()
            
        }) { (error) -> Void in
            print(error)
        }
        
    }
    
    func accept(inviteID: Int) {
        let apiName = AcceptInvite + ("\(inviteID)") + ("/accept")
        
        let stringPost = ""
        
        DataConnectionManager.requestPOSTURL1(api: apiName, stringPost: stringPost, success: {
            (response) -> Void in
            
            print(response["status"]!)
            if response["status"] as? String == "0" {
                self.fetchInviteList()
                Utility.showAlertWithoutCancel("Alert", message: "You Successfully Joined This Community.")
            }else if response["status"] as? String == "1" {
                let alert = UIAlertController(title: "Alert", message: response["message"] as? String, preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        })
    }

    
    @IBAction func back(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func inviteAccept(_ sender: NSInteger) {
        let data = inviteList[sender]
        accept(inviteID: data.invitationId!)
    }
    
    // MARK: - UITextFiled Delegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

//MARK:- TableView Delegate
extension InviteViewController: UITableViewDataSource,UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.inviteList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: InviteCell = tableView.dequeueReusableCell(withIdentifier: inviteCellConstants.cellIdentifier) as! InviteCell
        cell.acceptBtn.tag = (indexPath as NSIndexPath).row
        cell.delegate = self
        let data = inviteList[(indexPath as NSIndexPath).row]
        
        let tblView = UIView(frame: CGRect.zero)
        tableView.tableFooterView = tblView
        tableView.tableFooterView?.isHidden = true
        tableView.backgroundColor = UIColor.clear
        cell.updateData(data)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 87
    }
}

