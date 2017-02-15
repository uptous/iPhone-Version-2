//
//  MyUpToUsContactsViewController.swift
//  uptous
//
//  Created by Roshan Gita  on 9/18/16.
//  Copyright © 2016 SPA. All rights reserved.
//

import UIKit
import MessageUI
import LKPullToLoadMore

enum Notes: String {
    case note1 = "note1"
    case note2 = "note2"
    
}

enum Type : String {
    case Landing = "Landing"
    case Expand = "Expand"
}

class MyUpToUsContactsViewController: GeneralViewController,LandingCellDelegate,ExpandCellDelegate , UISearchBarDelegate,MFMessageComposeViewControllerDelegate,MFMailComposeViewControllerDelegate,UIScrollViewDelegate,CommunityCellDelegate {
    
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    var selectedIndexPath: Int?
    var selectedIndexPath1 = "Landing"
    var itemsDatas = NSMutableArray()
    var loadMoreControl: LKPullToLoadMore!
    @IBOutlet weak var searchBar: UISearchBar!

    
    var searchActive : Bool = false
    var filterListArr = [Contacts]()
    var fullListArr = [Contacts]()
    var searchKey: String = ""
    var searchKeyBool: Bool = false
    var page: Int = 0
    var limit: Int = 20
    var loadingData = false
    var customSearchController: CustomSearchController!
    var searchController: UISearchController!
    var cancelbool: Bool = false
    var totalContacts: Int = 0
    
    @IBOutlet weak var communityTableView: UITableView!
    @IBOutlet weak var communityView: UIView!
    @IBOutlet weak var headingBtn: UIButton!
    var topMenuStatus = 0
    var communityList = NSMutableArray()
    
    var EndDisplayCellId = ""
    var WillDisplayCellId = ""
    var dataList = NSMutableArray()
    var loadNumber = 0
    var newFetchBool = 0
    var searchString = ""
    let defaults = UserDefaults.standard
    
    fileprivate struct landingCellConstants {
        static var cellIdentifier:String = "LandingCell"
        static var rowHeight:CGFloat! = 80
    }
    
    fileprivate struct expandCellConstants {
        static var cellIdentifier:String = "ExpandCell"
        static var rowHeight:CGFloat! = 190
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //CUSTOM SEARCH CONTROLLER
        //self.configureCustomSearchController()
        //configureSearchController()
        communityView.isHidden = true
        
        
        let landingNib = UINib(nibName: "LandingCell", bundle: nil)
        tableView.register(landingNib, forCellReuseIdentifier: landingCellConstants.cellIdentifier as String)
        
        let expandNib = UINib(nibName: "ExpandCell", bundle: nil)
        tableView.register(expandNib, forCellReuseIdentifier: expandCellConstants.cellIdentifier as String)
        //self.search(searchText: "0")
         let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(MyUpToUsContactsViewController.dismissKeyboard))
        
        view.addGestureRecognizer(tap)
        
        print(UserPreferences.AllContactList)
        print(UserPreferences.AllContactList.count)
       // self.fullListArr = UserPreferences.AllContactList
        
    }
    
    func getContacts() {
        
        self.fullListArr.removeAll()
        for index in 0..<UserPreferences.AllContactList.count {
            let dic = UserPreferences.AllContactList.object(at: index) as! NSDictionary
            
            if UserPreferences.SelectedCommunityID == 001 {
                self.fullListArr.append(Contacts(info: dic))
            }else {
                let communityID = UserPreferences.SelectedCommunityID
                let results = dic.object(forKey: "communities") as! NSArray
                for i in 0..<results.count {
                    let dic1 = results.object(at: i) as! NSDictionary
                    if (dic1.object(forKey: "id") as! Int) == communityID {
                        self.fullListArr.append(Contacts(info: dic))
                    }
                }
            }
        }
        
        if self.fullListArr.count > 0 {
            self.tableView.isHidden = false
            self.tableView.reloadData()
        }else {
            self.tableView.isHidden = true
            let alert = UIAlertController(title: "Alert", message: "No Record Found", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
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
        self.filterListArr = self.fullListArr.filter({( contact: Contacts) -> Bool in
            var tmp: String?
            var tmp1: String?
            var tmp3: String?
            var tmp4: String?
            var tmp5: String?
            var tmp6: String?
            var tmp7: String?
            tmp = contact.firstName!.lowercased()
            tmp1 = contact.lastName!.lowercased()
            tmp3 = contact.address!.lowercased()
            tmp4 = contact.mobile!.lowercased()
            tmp5 = contact.phone!.lowercased()
            tmp6 = contact.email!.lowercased()
            
            
            var childrens = [String]()
            if contact.children != nil {
                for i in 0..<(contact.children?.count)! {
                    let dic = contact.children?.object(at: i) as! NSDictionary
                    tmp7 = ("\((dic.object(forKey: "firstName"))!)").lowercased()
                    //childrens.append("\((dic.object(forKey: "firstName"))!)")
                }
                
            }
            
            return (tmp?.range(of: searchText.lowercased()) != nil) || (tmp1?.range(of: searchText.lowercased()) != nil )  || (tmp3?.range(of: searchText.lowercased()) != nil ) || (tmp4?.range(of: searchText.lowercased()) != nil) || (tmp5?.range(of: searchText.lowercased()) != nil) || (tmp6?.range(of: searchText.lowercased()) != nil) || (tmp7?.range(of: searchText.lowercased()) != nil)
            
        })
        if(searchText == ""){
            searchActive = false
        } else {
            searchActive = true
        }
        /*DispatchQueue.main.async( execute: {
            if searchBar.text == "" {
                self.searchBar.resignFirstResponder()
            }
        })*/
        self.tableView.reloadData()
    }
    
    //Calls this function when the tap is recognized.
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @IBAction func topClick(_ sender: UIButton) {
        //fetchCommunity()
        //appDelegate.tabbarView?.isHidden = true
        communityView.isHidden = true
        tableView.setContentOffset(CGPoint.zero, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //searchBar.text = ""
        if UserPreferences.SelectedCommunityName == "" {
            headingBtn.setTitle("Contacts - All Communities", for: .normal)
        }else{
            headingBtn.setTitle("Contacts - \(UserPreferences.SelectedCommunityName)", for: .normal)
        }
        getContacts()
        onTimerTick()
    }
    
    func onTimerTick() {
        DataConnectionManager.requestGETURL1(api: ContactUpdateAPI, para: ["":""], success: {
            (response) -> Void in
            
            let data = response as? NSDictionary
            
            if data != nil {
                let status = data?.object(forKey: "status") as? String
                if (status == "2") {
                    //self.notifNoRecordsView.isHidden = false
                    
                }else {
                    if data?.object(forKey: "lastContactChange") as? NSNumber != self.defaults.object(forKey: "LastModifiedContact") as? NSNumber {
                        self.defaults.set(data?.object(forKey: "lastContactChange"), forKey: "LastModifiedContact")
                        self.getTotalContacts()
                    }
                }
            }
            
        }) {
            (error) -> Void in
        }
    }
    
    //MARK: Fetch Records
    func getTotalContacts() {
        DataConnectionManager.requestGETURL1(api: TotalContacts, para: ["":""], success: {
            (response) -> Void in
            print(response)
            let item = response as! NSDictionary
            let totalContacts = Int((item.object(forKey: "total") as? String)!)!
            self.search(textLimit: totalContacts)
        }) {
            (error) -> Void in
        }
    }
    
    //MARK:- SEARCH API HIT
    func search(textLimit: Int){
        
        let api = ("\(Members)") + ("/community/0") + ("/search/0") + ("/limit/\(textLimit)") + ("/offset/0")
        
        DataConnectionManager.requestGETURL1(api: api, para: ["":""], success: {
            (jsonResult) -> Void in
            print(jsonResult)
            UserPreferences.AllContactList = []
            let listArr = jsonResult as! NSArray
            print("listArr ==>\(listArr.count)")
            UserPreferences.AllContactList = listArr
            self.getContacts()
            
        }) {
            (error) -> Void in
        }
    }


    
    //MARk:- Top Menu Community
    @IBAction func topMenuButtonClick(_ sender: UIButton) {
        fetchCommunity()
        appDelegate.tabbarView?.isHidden = true
        communityView.isHidden = false
        tableView.setContentOffset(CGPoint.zero, animated: true)
    }
    
    @IBAction func closeMenuButtonClick(_ sender: UIButton) {
        communityView.isHidden = true
        appDelegate.tabbarView?.isHidden = false
    }
    
    //MARK: Fetch Community Records
    func fetchCommunity() {
        self.communityList.removeAllObjects()
        
        DataConnectionManager.requestGETURL(api: TopMenuCommunity, para: ["":""], success: {
            (response) -> Void in
            print(response)
            
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
            let alert = UIAlertController(title: "Alert", message: "Error", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Try Again", style: UIAlertActionStyle.default, handler: nil))
            //self.present(alert, animated: true, completion: nil)
        }
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

//MARK:- TableView
extension MyUpToUsContactsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var sectionCount = 0
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
        
        //tableView.tableFooterView = UIView(frame: CGRect.zero)
        let tblView = UIView(frame: CGRect.zero)
        tableView.tableFooterView = tblView
        tableView.tableFooterView?.isHidden = true

        if tableView == communityTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CommunityCell") as! CommunityCell
            let data = self.communityList[(indexPath as NSIndexPath).row] as? Community
            cell.communityBtn.tag = indexPath.row
            cell.delegate = self
            cell.update(data!)
            // cell.communityNameLbl.text = "ghghgjgytjhkjkjhl"
            return cell
            
            
        }else {
            if(selectedIndexPath == indexPath.row) {
                let cell: ExpandCell = tableView.dequeueReusableCell(withIdentifier: expandCellConstants.cellIdentifier ) as! ExpandCell
                cell.collapseBtn.tag = indexPath.row
                cell.emailBtn.tag = indexPath.row
                cell.phoneBtn.tag = indexPath.row
                cell.delegate = self
                
                let data: Contacts!
                if(searchActive) {
                    data = self.filterListArr[(indexPath as NSIndexPath).row]
                }else {
                    data = self.fullListArr[(indexPath as NSIndexPath).row]
                }
                cell.updateView(data!)
                return cell
            }else {
                
                let cell: LandingCell = tableView.dequeueReusableCell(withIdentifier: landingCellConstants.cellIdentifier ) as! LandingCell
                cell.expandBtn.tag = indexPath.row
                cell.delegate = self
                
                let data: Contacts!
                if(searchActive) {
                    data = self.filterListArr[(indexPath as NSIndexPath).row]
                }else {
                    data = self.fullListArr[(indexPath as NSIndexPath).row]
                }
                cell.updateView(data!)
                return cell
            }
        }
    }
    
    //Roshan
    /*func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
     if tableView != communityTableView {
     self.loadingData = false
     loadMore()
     }
     }*/
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == communityTableView {
            return 50
        }else {
            if(selectedIndexPath == indexPath.row) {
                return 190.0
            }
            return 80.0
        }
    }
    
    func communitySelected(_ sender: NSInteger) {
        appDelegate.tabbarView?.isHidden = false
        let data = self.communityList[sender] as? Community
        if data?.name == "All Communities" {
            topMenuStatus = 0
            headingBtn.setTitle("Contacts - All Communities", for: .normal)
            communityView.isHidden = true
            UserPreferences.SelectedCommunityID = 001
            UserPreferences.SelectedCommunityName = ""
            getContacts()
        }else {
            headingBtn.setImage(UIImage(named: "top-up-arrow"), for: .normal)
            UserPreferences.SelectedCommunityName = (data?.name)!
            headingBtn.setTitle("Contacts - \((data?.name)!)", for: .normal)
            UserPreferences.SelectedCommunityID = (data?.communityId)!
            communityView.isHidden = true
            getContacts()
        }
    }
   
    
    @IBAction func menuButtonClick(_ sender: UIButton) {
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
        self.present(controller, animated: true, completion: nil)
    }
    
    func openEmailClick(_ sender: NSInteger) {
        let data = self.filterListArr[sender] as? Contacts
        
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients([(data?.email!)!])
            mail.setMessageBody("", isHTML: true)
            
            present(mail, animated: true, completion: nil)
        } else {
            // show failure alert
            self.showSendMailErrorAlert()
        }
    }
    
    
    func showSendMailErrorAlert() {
        let sendMailErrorAlert = UIAlertView(title: "Could Not Send Email", message: "Your device could not send e-mail.  Please check e-mail configuration and try again.", delegate: self, cancelButtonTitle: "OK")
        sendMailErrorAlert.show()
    }
    
    // MARK: MFMailComposeViewControllerDelegate Method
    @objc(mailComposeController:didFinishWithResult:error:) func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func openPhoneClick(_ sender: NSInteger) {
        ActivityIndicator.show()
        let data = self.filterListArr[sender] as? Contacts
        if (MFMessageComposeViewController.canSendText()) {
            let controller = MFMessageComposeViewController()
            ActivityIndicator.hide()
            controller.body = ""
            controller.recipients = [(data?.mobile)!]
            controller.messageComposeDelegate = self
            self.present(controller, animated: true, completion: nil)
        }
    }
    
    @objc(messageComposeViewController:didFinishWithResult:) func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        ActivityIndicator.hide()
        //... handle sms screen actions
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        ActivityIndicator.hide()
        self.navigationController?.isNavigationBarHidden = true
    }
    
    
    
    func expandClick(_ rowNumber: NSInteger) {
        self.selectedIndexPath = rowNumber
        //self.loadingData = true
        self.tableView.reloadData()
    }
    
    func collapseClick(_ rowNumber: NSInteger) {
        //self.loadingData = true
        self.selectedIndexPath = nil
        self.tableView.reloadData()
    }
    
}


