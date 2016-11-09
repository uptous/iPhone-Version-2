//
//  MyUpToUsSignUpViewController.swift
//  uptous
//
//  Created by Roshan Gita  on 9/18/16.
//  Copyright © 2016 SPA. All rights reserved.
//

import UIKit
import Alamofire

class MyUpToUsSignUpViewController: GeneralViewController {

    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!

    var list = NSMutableArray()
    var selectedDateType: Int = 0
    
    fileprivate struct headerCellConstants {
        static var cellIdentifier:String = "CustomHeaderCell"
        static var rowHeight:CGFloat! = 50
    }
    
    fileprivate struct eventCellConstants {
        static var cellIdentifier:String = "EventDateCell"
        static var rowHeight:CGFloat! = 120
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let eventNib = UINib(nibName: "EventDateCell", bundle: nil)
        tableView.register(eventNib, forCellReuseIdentifier: eventCellConstants.cellIdentifier as String)
        //self.tableView.hidden = true

        let delayTime = DispatchTime.now() + Double(Int64(1 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: delayTime) {
            self.fetchSignupSheetList()
        }

    }
    
    func cornerView(_ contentsView: UIView) ->UIView {
        contentsView.layer.borderColor = UIColor(red: CGFloat(0.8), green: CGFloat(0.8), blue: CGFloat(0.8), alpha: CGFloat(1)).cgColor
        contentsView.layer.borderWidth = CGFloat(1.0)
        contentsView.layer.cornerRadius = 8.0
        return contentsView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        ActivityIndicator.hide()
    }

    //MARK:- Signup Sheet List
    func fetchSignupSheetList() {
        ActivityIndicator.show()
        DataConnectionManager.requestGETURL(api: SignupListSheet, para: ["":""], success: {
            (response) -> Void in
            print(response)
            ActivityIndicator.hide()
            let list = response as! NSArray
            if list.count > 0 {
                
                for index in 0..<list.count {
                    let dic = list.object(at: index) as! NSDictionary
                    self.list.add(SignupSheet(info: dic))
                }
                
                self.tableView.reloadData()
            }

        }) {
            (error) -> Void in
            ActivityIndicator.hide()
            let alert = UIAlertController(title: "Alert", message: "Error", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Try Again", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension MyUpToUsSignUpViewController: UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: EventDateCell = tableView.dequeueReusableCell(withIdentifier: eventCellConstants.cellIdentifier ) as! EventDateCell
        let event = self.list.object(at: (indexPath as NSIndexPath).row)
        cell.update(event as! SignupSheet)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let event = self.list.object(at: (indexPath as NSIndexPath).row) as! SignupSheet
        
        if (event.type! == "Drivers") {
            let controller = self.storyboard?.instantiateViewController(withIdentifier: "SignUpDriverViewController") as! SignUpDriverViewController
            controller.data = event
            self.navigationController?.pushViewController(controller, animated: true)
            
        }else if (event.type! == "RSVP" || event.type! == "Vote") {
            let controller = self.storyboard?.instantiateViewController(withIdentifier: "SignUpRSVPViewController") as! SignUpRSVPViewController
            controller.data = event
            self.navigationController?.pushViewController(controller, animated: true)
            
        }else if (event.type! == "Ongoing") {
            let controller = self.storyboard?.instantiateViewController(withIdentifier: "OnGoingSignUpsViewController") as! OnGoingSignUpsViewController
            controller.data = event
            self.navigationController?.pushViewController(controller, animated: true)
            
        }else if (event.type! == "Shifts" || event.type! == "Snack" || event.type! == "Games") {
            let controller = self.storyboard?.instantiateViewController(withIdentifier: "ShiftsSigUpsViewController") as! ShiftsSigUpsViewController
            controller.data = event
            self.navigationController?.pushViewController(controller, animated: true)
            
        }else if (event.type! == "Volunteer" || event.type! == "Potluck" || event.type! == "Wish List") {
            let controller = self.storyboard?.instantiateViewController(withIdentifier: "SignUpOpenViewController") as! SignUpOpenViewController
            controller.data = event
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    /*func tableView(tableView: UITableView, vViiewForHeaderInSection section: Int) -> UIView? {
        let cell: CustomHeaderCell = tableView.dequeueReusableCellWithIdentifier(headerCellConstants.cellIdentifier ) as! CustomHeaderCell
        
        return cell
    }*/
    
}
