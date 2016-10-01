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
    
    private struct headerCellConstants {
        static var cellIdentifier:String = "CustomHeaderCell"
        static var rowHeight:CGFloat! = 50
    }
    
    private struct eventCellConstants {
        static var cellIdentifier:String = "EventDateCell"
        static var rowHeight:CGFloat! = 120
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let eventNib = UINib(nibName: "EventDateCell", bundle: nil)
        tableView.registerNib(eventNib, forCellReuseIdentifier: eventCellConstants.cellIdentifier as String)
        //self.tableView.hidden = true

        let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(1 * Double(NSEC_PER_SEC)))
        dispatch_after(delayTime, dispatch_get_main_queue()) {
            self.fetchSignupSheetList()
        }

    }
    
    func cornerView(contentsView: UIView) ->UIView {
        contentsView.layer.borderColor = UIColor(red: CGFloat(0.8), green: CGFloat(0.8), blue: CGFloat(0.8), alpha: CGFloat(1)).CGColor
        contentsView.layer.borderWidth = CGFloat(1.0)
        contentsView.layer.cornerRadius = 8.0
        return contentsView
    }

    //MARK:- Signup Sheet List
    func fetchSignupSheetList() {
        //let user = "asmithutu@gmail.com"
        //let password = "alpha123"
        let username = "asmithutu@gmail.com".stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        let password = "alpha123".stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        
        let base64Credentials = "\(username):\(password)".dataUsingEncoding(NSUTF8StringEncoding)!
        //appDelegate.loginHeaderCredentials = ["Authorization": "Basic \(base64Credentials)"]
        
        ActivityIndicator.show()
        //self.cutOffDateList.removeAllObjects()
        //self.eventDateList.removeAllObjects()
        
        Alamofire.request(.GET, SignupListSheet, headers: appDelegate.loginHeaderCredentials)
            .responseJSON { response in
                print(response.result.value)
                if let result = response.result.value {
                    ActivityIndicator.hide()
                    
                    let list = result as! NSArray
                    if list.count > 0 {
                        
                        for index in 0..<list.count {
                            let dic = list.objectAtIndex(index) as! NSDictionary
                            self.list.addObject(SignupSheet(info: dic))
                        }
                        self.tableView.reloadData()
                    }
                }else {
                    ActivityIndicator.hide()
                }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension MyUpToUsSignUpViewController: UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.list.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell: EventDateCell = tableView.dequeueReusableCellWithIdentifier(eventCellConstants.cellIdentifier ) as! EventDateCell
        let event = self.list.objectAtIndex(indexPath.row)
        cell.update(event as! SignupSheet)
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let event = self.list.objectAtIndex(indexPath.row) as! SignupSheet
        
        if (event.type! == "Drivers") {
            let controller = self.storyboard?.instantiateViewControllerWithIdentifier("SignUpDriverViewController") as! SignUpDriverViewController
            controller.data = event
            self.navigationController?.pushViewController(controller, animated: true)
            
        }else if (event.type! == "RSVP" || event.type! == "Vote") {
            let controller = self.storyboard?.instantiateViewControllerWithIdentifier("SignUpDriverViewController") as! SignUpDriverViewController
            controller.data = event
            self.navigationController?.pushViewController(controller, animated: true)
            
        }else if (event.type! == "Ongoing") {
            let controller = self.storyboard?.instantiateViewControllerWithIdentifier("OnGoingSignUpsViewController") as! OnGoingSignUpsViewController
            controller.data = event
            self.navigationController?.pushViewController(controller, animated: true)
            
        }else if (event.type! == "Shifts" || event.type! == "Snack" || event.type! == "Games") {
            let controller = self.storyboard?.instantiateViewControllerWithIdentifier("ShiftsSigUpsViewController") as! ShiftsSigUpsViewController
            controller.data = event
            self.navigationController?.pushViewController(controller, animated: true)
            
        }else if (event.type! == "Volunteer" || event.type! == "Potluck" || event.type! == "Wish List") {
            
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 120
    }
    
    /*func tableView(tableView: UITableView, vViiewForHeaderInSection section: Int) -> UIView? {
        let cell: CustomHeaderCell = tableView.dequeueReusableCellWithIdentifier(headerCellConstants.cellIdentifier ) as! CustomHeaderCell
        
        return cell
    }*/
    
}
