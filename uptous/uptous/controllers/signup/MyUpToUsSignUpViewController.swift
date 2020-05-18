//
//  MyUpToUsSignUpViewController.swift
//  uptous
//
//  Created by Roshan Gita  on 9/18/16.
//  Copyright © 2016 UpToUs. All rights reserved.
//

import UIKit
import Alamofire

class MyUpToUsSignUpViewController: GeneralViewController,UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var searchBar: UISearchBar!
    var searchActive : Bool = false
    var filterListArr = [SignupSheet]()
    var fullListArr = [SignupSheet]()
    var searchKey: String = ""
    var searchKeyBool: Bool = false

    var list = NSMutableArray()
    var selectedDateType: Int = 0
    var topMenuSelected = 0
    
    @IBOutlet weak var communityTableView: UITableView!
    @IBOutlet weak var communityView: UIView!
    @IBOutlet weak var headingBtn: UIButton!
    @IBOutlet weak var messageView: UIView!
    
    var topMenuStatus = 0
    var communityList = NSMutableArray()
    
    
    fileprivate struct headerCellConstants {
        static var cellIdentifier:String = "CustomHeaderCell"
        static var rowHeight:CGFloat! = 50
    }
    
    fileprivate struct eventCellConstants {
        static var cellIdentifier:String = "EventDateCell"
        static var rowHeight:CGFloat! = 150
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.searchBar.delegate = self
        communityView.isHidden = true

        let eventNib = UINib(nibName: "EventDateCell", bundle: nil)
        tableView.register(eventNib, forCellReuseIdentifier: eventCellConstants.cellIdentifier as String)
        messageView.isHidden = true
        self.tableView.isHidden = true
       self.fetchCommunity()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        ActivityIndicator.hide()
    }
    
    //MARk:- Top Menu Community
    @IBAction func topMenuButtonClick(_ sender: UIButton) {
        if topMenuSelected == 0 {
            headingBtn.setImage(UIImage(named: "top-up-arrow"), for: .normal)
            fetchCommunity()
            appDelegate.tabbarView?.isHidden = true
            communityView.isHidden = false
            topMenuSelected = 1
        }else {
            headingBtn.setImage(UIImage(named: "top-down-arrow"), for: .normal)
            communityView.isHidden = true
            appDelegate.tabbarView?.isHidden = false
            topMenuSelected = 0
        }
    }
    
    @IBAction func closeMenuButtonClick(_ sender: UIButton) {
        headingBtn.setImage(UIImage(named: "top-down-arrow"), for: .normal)
        communityView.isHidden = true
        appDelegate.tabbarView?.isHidden = false
        topMenuSelected = 0
    }
    
    //MARK: Fetch Community Records
    func fetchCommunity() {
        self.communityList.removeAllObjects()
        DataConnectionManager.requestGETURL(api: TopMenuCommunity, para: ["":""], success: {
            (response) -> Void in
            
            let item = response as! NSArray
            var dic1 = [String : String]()
            dic1["id"] = "0"
            dic1["name"] = "All Communities"
            self.communityList.add(Community(info: dic1 as NSDictionary?))
            for index in 0..<item.count {
                let dic = item.object(at: index) as! NSDictionary
                self.communityList.add(Community(info: dic))
            }
            self.communityTableView.reloadData()
            
        }) {
            (error) -> Void in
            
            let alert = UIAlertController(title: "Alert", message: "Error", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Try Again", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }

    func cornerView(_ contentsView: UIView) ->UIView {
        contentsView.layer.borderColor = UIColor(red: CGFloat(0.8), green: CGFloat(0.8), blue: CGFloat(0.8), alpha: CGFloat(1)).cgColor
        contentsView.layer.borderWidth = CGFloat(1.0)
        contentsView.layer.cornerRadius = 8.0
        return contentsView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        searchBar.text = ""
        if UserPreferences.SelectedCommunityName == "" {
            headingBtn.setTitle("Sign-Ups - All Communities", for: .normal)
        }else{
            headingBtn.setTitle("Sign-Ups - \(UserPreferences.SelectedCommunityName)", for: .normal)
        }
        self.tableView.isHidden = true
        messageView.isHidden = true
        self.fetchSignupSheetList()

    }
    
    @IBAction func menuButtonClick(_ sender: UIButton) {
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
        
        let navController = appDelegate.window?.rootViewController as? UINavigationController
        navController?.pushViewController(controller, animated: true)
    }

    //MARK:- Signup Sheet List
    func fetchSignupSheetList() {
        appDelegate.tabbarView?.isHidden = false
        self.communityView.isHidden = true
         DataConnectionManager.requestGETURL(api: SignupListSheet, para: ["":""], success: {
            (response) -> Void in
            
            let item = response as! NSArray
            if item.count > 0 {
                self.fullListArr.removeAll()
                for index in 0..<item.count {
                    let dic = item.object(at: index) as! NSDictionary
                    self.fullListArr.append(SignupSheet(info: dic))
                }
                //self.tableView.reloadData()
            }
            if UserPreferences.SelectedCommunityID == 001 {
                
            }else {
                let communityID = UserPreferences.SelectedCommunityID
                self.fullListArr = self.fullListArr.filter{ $0.communityId == communityID }
                print("MyUpToUsSignUpViewController: fetchSignupSheetList: ");print(self.fullListArr.count)
            }
            
            if self.fullListArr.count > 0 {
                self.messageView.isHidden = true
                self.tableView.isHidden = false
                self.tableView.reloadData()
            }else {
                self.tableView.isHidden = true
                self.messageView.isHidden = false
                /*let alert = UIAlertController(title: "Alert", message: "No Record Found", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)*/
            }
            
        }) {
            (error) -> Void in
            
            let alert = UIAlertController(title: "Alert", message: "Error", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Try Again", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    // MARK: UISearchBarDelegate functions
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActive = false
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchActive = false
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchActive = true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchActive = false
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.filterListArr.removeAll()
        self.filterListArr = self.fullListArr.filter({( sheet: SignupSheet) -> Bool in
            var tmp: String?
            var tmp1: String?
            tmp = sheet.type!.lowercased()
            tmp1 = sheet.name!.lowercased()
            
            return (tmp?.range(of: searchText.lowercased()) != nil) || (tmp1?.range(of: searchText.lowercased()) != nil)
            
        })
        if(searchText == ""){
            searchActive = false
        } else {
            searchActive = true
        }
        DispatchQueue.main.async( execute: {
            if searchBar.text == "" {
                self.searchBar.resignFirstResponder()
            }
        })
        self.tableView.reloadData()
    }
    
    //MARK: Fetch Driver Records
    func fetchDriverItems(data: SignupSheet, signUpType: String) {
        let apiName = SignupItems + ("\(data.id!)")
        
        DataConnectionManager.requestGETURL1(api: apiName, para: ["":""], success: {
            (response) -> Void in
            let driverDatas = (response as? NSArray)!
            let dic = driverDatas.object(at: 0) as? NSDictionary
            let dataSheet = SignupSheet(info: dic)
            
            appDelegate.globalSignUpData = data
            
            if dataSheet.contact == "" && dataSheet.contact2 == "" {
                let controller = self.storyboard?.instantiateViewController(withIdentifier: "SignUpType1ViewController") as! SignUpType1ViewController
                controller.modalPresentationStyle = UIModalPresentationStyle.currentContext
                controller.data = dataSheet
                //controller.data1 = data1
                controller.signUpType = signUpType
                self.present(controller, animated: true, completion: nil)
            }else {
                let controller = self.storyboard?.instantiateViewController(withIdentifier: "SignUpType3ViewController") as! SignUpType3ViewController
                controller.modalPresentationStyle = UIModalPresentationStyle.currentContext
                controller.data = dataSheet
                //controller.data1 = data1
                controller.signUpType = signUpType
                self.present(controller, animated: true, completion: nil)
            }
            
            //self.updateData(SignupSheet(info: dic))
            //self.itemsDatas = (dic?.object(forKey: "items")) as! NSArray
            //self.tableView.reloadData()
        }) {
            (error) -> Void in
            
            let alert = UIAlertController(title: "Alert", message: "Error", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Try Again", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }

    //MARK:-UITableView
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == communityTableView {
            return self.communityList.count
            
        }else {
            if(searchActive) {
                return self.filterListArr.count
            } else {
                return self.fullListArr.count
            }
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var  sectionName: String = ""
        if tableView != communityTableView {
            if(searchActive) {
                sectionName = "SEARCH RESULTS"
            }
            return sectionName
        }else {
            return ""
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == communityTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CommunityCell") as! CommunityCell
            let data = self.communityList[(indexPath as NSIndexPath).row] as? Community
            cell.update(data!)
            // cell.communityNameLbl.text = "ghghgjgytjhkjkjhl"
            return cell
            
            
        }else {
            let cell: EventDateCell = tableView.dequeueReusableCell(withIdentifier: eventCellConstants.cellIdentifier ) as! EventDateCell
            let data: SignupSheet!
            if(searchActive) {
                data = self.filterListArr[(indexPath as NSIndexPath).row]
            }else {
                data = self.fullListArr[(indexPath as NSIndexPath).row]
            }
            cell.update(data,communityList: self.communityList)
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView == communityTableView {
            topMenuSelected = 0
            let data = self.communityList[(indexPath as NSIndexPath).row] as? Community
            if data?.name == "All Communities" {
                topMenuStatus = 0
                headingBtn.setTitle("Sign-Ups - All Communities", for: .normal)
                communityView.isHidden = true
                UserPreferences.SelectedCommunityID = 001
                UserPreferences.SelectedCommunityName = ""
                fetchSignupSheetList()
            }else {
                headingBtn.setImage(UIImage(named: "top-up-arrow"), for: .normal)
                UserPreferences.SelectedCommunityName = (data?.name)!
                headingBtn.setTitle("Sign-Ups - \((data?.name)!)", for: .normal)
                UserPreferences.SelectedCommunityID = (data?.communityId)!
                communityView.isHidden = true
                fetchSignupSheetList()
            }
        }else {
            let event: SignupSheet!
            if(searchActive) {
                event = self.filterListArr[(indexPath as NSIndexPath).row]
            }else {
                event = self.fullListArr[(indexPath as NSIndexPath).row]
            }
            
            if (event.type! == "Drivers") {
                fetchDriverItems(data: event , signUpType: "103")
                
            }else if (event.type! == "RSVP" || event.type! == "Vote") {
                fetchDriverItems(data: event , signUpType: "102")
                
            }else if (event.type! == "Shifts" || event.type! == "Snack" || event.type! == "Games" || event.type! == "Multi Game/Event RSVP" || event.type! == "Snack Schedule") {
                fetchDriverItems(data: event , signUpType: "100")
                
           }else if (event.type! == "Volunteer" || event.type! == "Potluck" || event.type! == "Wish List" || event.type! == "Potluck/Party" || event.type! == "Ongoing Volunteering") {
                fetchDriverItems(data: event , signUpType: "101")
                
            }else {
                let alertView = UIAlertController(title: "UpToUs", message: "We're sorry but for now, this type of sign-up is not accessible with the app", preferredStyle: .alert)
                alertView.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (alertAction) -> Void in
                    
                }))
                present(alertView, animated: true, completion: nil)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == communityTableView {
            return 50
        }else {
            return 150
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}


