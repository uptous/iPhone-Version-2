//
//  MyUpToUsContactsViewController.swift
//  uptous
//
//  Created by Roshan Gita  on 9/18/16.
//  Copyright © 2016 UpToUs. All rights reserved.
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
    var selectedIndexPath2: Int?
    var selectedIndexPath1 = "Landing"
    var itemsDatas = NSMutableArray()
    var loadMoreControl: LKPullToLoadMore!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var messageView: UIView!
    let defaults = UserDefaults.standard
    
    var searchActive : Bool = false
    var filterListArr = [Contacts]()
    var fullListArr = [Contacts]()
    
    var allIDArr = [String]()
    var filterIDArrArr = [String]()
    
    var searchKey: String = ""
    var searchKeyBool: Bool = false
    var page: Int = 0
    //var limit: Int = 20
    var loadingData = false
    var customSearchController: CustomSearchController!
    var searchController: UISearchController!
    var cancelbool: Bool = false
    var totalContacts: Int = 0
    
    var isDataLoading:Bool=false
    var pageNo:Int=0
    var limit:Int=150
    var offset:Int=0 //pageNo*limit
    var didEndReached:Bool=false
    
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
    var topMenuSelected = 0
    var expandStatus = ""
    var searchChar = "0"
    
    fileprivate struct landingCellConstants {
        static var cellIdentifier:String = "LandingCell"
        static var rowHeight:CGFloat! = 70
    }
    
    fileprivate struct expandCellConstants {
        static var cellIdentifier:String = "ExpandCell"
        static var rowHeight:CGFloat! = 190
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        communityView.isHidden = true
        let landingNib = UINib(nibName: "LandingCell", bundle: nil)
        tableView.register(landingNib, forCellReuseIdentifier: landingCellConstants.cellIdentifier as String)
        let expandNib = UINib(nibName: "ExpandCell", bundle: nil)
        tableView.register(expandNib, forCellReuseIdentifier: expandCellConstants.cellIdentifier as String)
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(MyUpToUsContactsViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        messageView.isHidden = true
        
        
        self.fullListArr.removeAll()
        self.allIDArr.removeAll()
        getContacts(searchItem: "0", offset: self.offset, limit: self.limit)
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        print("scrollViewWillBeginDragging")
        isDataLoading = false
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        print("scrollViewDidEndDecelerating")
    }
    
    
    
    //Pagination
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        print("scrollViewDidEndDragging")
        if ((tableView.contentOffset.y + tableView.frame.size.height) >= tableView.contentSize.height)
        {
            if !isDataLoading{
                isDataLoading = true
                self.pageNo=self.pageNo+1
//                self.limit=self.limit+150
                
                self.offset=self.limit * self.pageNo
                //loadCallLogData(offset: self.offset, limit: self.limit)
                getContacts(searchItem: searchChar, offset: self.offset, limit: self.limit)
            }
        }
    }
    
    //MARK:- SEARCH API HIT
    func getContacts(searchItem: String, offset: Int, limit: Int) {
         let api = ("\(Members)") + ("/community/0") + ("/search/\(searchItem)") + ("/limit/\(limit)") + ("/offset/\(offset)")
        print("api==>\(api)")
        DataConnectionManager.requestGETURL(api: api, para: ["":""], success: {
            (jsonResult) -> Void in
            let listArr = jsonResult as! NSArray
            print(listArr.count)
//            print(listArr)

            for index in 0..<listArr.count {
                let dic = listArr.object(at: index) as! NSDictionary
                
                if UserPreferences.SelectedCommunityID == 001 {
                    let email = dic.object(forKey: "email") as? String ?? ""
                    let firstName = dic.object(forKey: "firstName") as? String ?? ""
                    let lastName = dic.object(forKey: "lastName") as? String ?? ""
                    
                    if firstName != "" || lastName != "" {
                        self.fullListArr.append(Contacts(info: dic))
                        self.allIDArr.append(email)
                    }
                }else {
                    let communityID = UserPreferences.SelectedCommunityID
                    let results = dic.object(forKey: "communities") as! NSArray
                    for i in 0..<results.count {
                        let dic1 = results.object(at: i) as! NSDictionary
                        if (dic1.object(forKey: "id") as! Int) == communityID {
                            let firstName = dic.object(forKey: "firstName") as? String ?? ""
                            let lastName = dic.object(forKey: "lastName") as? String ?? ""
                            if firstName != "" || lastName != "" {
                                self.fullListArr.append(Contacts(info: dic))
                                let email = dic1.object(forKey: "email") as? String ?? ""
                                self.allIDArr.append(email)
                            }
                        }
                    }
                }
            }
            
            if self.fullListArr.count > 0 {
                self.messageView.isHidden = true
                self.tableView.isHidden = false
                
                self.tableView.reloadData()
            }else {
                self.tableView.isHidden = true
                self.messageView.isHidden = false
            }
        }) {
            (error) -> Void in
        }
    }
    
    func getContacts1(searchItem: String, offset: Int, limit: Int) {
        
        self.filterListArr.removeAll()
        self.fullListArr.removeAll()
        self.allIDArr.removeAll()
        
        let api = ("\(Members)") + ("/community/0") + ("/search/\(searchItem)") + ("/limit/\(limit)") + ("/offset/\(offset)")
        print("api==>\(api)")
        DataConnectionManager.requestGETURL1(api: api, para: ["":""], success: {
            (jsonResult) -> Void in
            let listArr = jsonResult as! NSArray
            for index in 0..<listArr.count {
                let dic = listArr.object(at: index) as! NSDictionary
                
                if UserPreferences.SelectedCommunityID == 001 {
                    let email = dic.object(forKey: "email") as? String ?? ""
                    let firstName = dic.object(forKey: "firstName") as? String ?? ""
                    let lastName = dic.object(forKey: "lastName") as? String ?? ""
                    
                    if firstName != "" || lastName != "" {
                        self.fullListArr.append(Contacts(info: dic))
                        self.allIDArr.append(email)
                    }
                }else {
                    let communityID = UserPreferences.SelectedCommunityID
                    let results = dic.object(forKey: "communities") as! NSArray
                    for i in 0..<results.count {
                        let dic1 = results.object(at: i) as! NSDictionary
                        if (dic1.object(forKey: "id") as! Int) == communityID {
                            let firstName = dic.object(forKey: "firstName") as? String ?? ""
                            let lastName = dic.object(forKey: "lastName") as? String ?? ""
                            if firstName != "" || lastName != "" {
                                self.fullListArr.append(Contacts(info: dic))
                                let email = dic1.object(forKey: "email") as? String ?? ""
                                self.allIDArr.append(email)
                            }
                        }
                    }
                }
            }
            
            if self.fullListArr.count > 0 {
                self.messageView.isHidden = true
                self.tableView.isHidden = false
                
                self.tableView.reloadData()
            }else {
                self.tableView.isHidden = true
                self.messageView.isHidden = false
            }
        }) {
            (error) -> Void in
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        messageView.isHidden = true
        if UserPreferences.SelectedCommunityName == "" {
            headingBtn.setTitle("Contacts - All Communities", for: .normal)
        }else{
            headingBtn.setTitle("Contacts - \(UserPreferences.SelectedCommunityName)", for: .normal)
        }
    }
    
    // MARK: UISearchBarDelegate functions
    // MARK: UISearchBarDelegate functions
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActive = false
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchActive = false
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //searchBar.resignFirstResponder()
        searchActive = true
        self.filterListArr.removeAll()
        self.fullListArr.removeAll()
        self.allIDArr.removeAll()
        self.offset = 0
        self.page = 0
        
        if (searchBar.text! == "") {
            searchBar.resignFirstResponder()
            searchChar = "0"
            self.limit = 150
            searchBar.text = nil
            searchBar.showsCancelButton = false
            searchBar.endEditing(true)
            getContacts(searchItem: searchChar, offset: self.offset, limit: 150)
            
        }else {
            searchChar = searchBar.text!
            self.filterListArr.removeAll()
            self.fullListArr.removeAll()
            self.allIDArr.removeAll()
            getContacts(searchItem: searchChar, offset: self.offset, limit: 150)
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchActive = false
        self.filterListArr.removeAll()
        self.fullListArr.removeAll()
        self.allIDArr.removeAll()
        searchBar.text = nil
        searchBar.showsCancelButton = false
        searchBar.endEditing(true)
        
        searchChar = "0"
        self.offset = 0
        self.page = 0
        self.limit = 0
        getContacts(searchItem: searchChar, offset: self.offset, limit: 150)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.filterListArr.removeAll()
        self.fullListArr.removeAll()
        self.allIDArr.removeAll()
        
        let text = searchText.trimmingCharacters(in: .whitespaces)
        self.offset = 0
        self.page = 0
        //self.limit = 0
        
        if (searchBar.text! == "") {
            searchBar.resignFirstResponder()
            searchChar = "0"
            self.limit = 150
            getContacts(searchItem: searchChar, offset: self.offset, limit: 150)
            
        }else {
            searchChar = text
            searchBar.becomeFirstResponder()
            getContacts1(searchItem: searchChar, offset: self.offset, limit: 150)
            
        }
    }
    
    /*func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        //searchActive = true
        
        //getContacts(searchItem: searchBar.text!, offset: self.offset, limit: self.limit)
        
        if (searchBar.text! == "") {
            searchText = "0"
            self.offset = 0
            self.limit = 150
            self.fullListArr.removeAll()
            self.allIDArr.removeAll()
            getContacts(searchItem: searchBar.text!, offset: self.offset, limit: self.limit)
            
        }else {
            searchText = searchBar.text!
            self.fullListArr.removeAll()
            self.allIDArr.removeAll()
            getContacts(searchItem: searchText, offset: 0, limit: 150)
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        //searchActive = false
        searchBar.text = ""
        self.fullListArr.removeAll()
        self.allIDArr.removeAll()
        searchText = "0"
        self.offset = 0
        self.limit = 150
        getContacts(searchItem: searchText, offset: self.offset, limit: self.limit)
    }*/
    
    /*func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
     self.filterListArr.removeAll()
     let text = searchText.trimmingCharacters(in: .whitespaces)
     
     self.filterListArr = self.fullListArr.filter({( contact: Contacts) -> Bool in
     var tmp: String?
     var tmp1: String?
     var tmp3: String?
     var tmp4: String?
     var tmp5: String?
     var tmp6: String?
     var tmp7: String?
     var tmp8: String?
     tmp = contact.firstName!.lowercased()
     tmp1 = contact.lastName!.lowercased()
     tmp3 = contact.address!.lowercased()
     tmp4 = contact.mobile!.lowercased()
     tmp5 = contact.phone!.lowercased()
     tmp6 = contact.email!.lowercased()
     tmp8 = contact.firstName!.lowercased() + contact.lastName!.lowercased()
     if contact.children != nil {
     for i in 0..<(contact.children?.count)! {
     let dic = contact.children?.object(at: i) as! NSDictionary
     tmp7 = ("\((dic.object(forKey: "firstName"))!)").lowercased()
     }
     }
     
     return (tmp?.range(of: text.lowercased()) != nil) || (tmp1?.range(of: text.lowercased()) != nil )  || (tmp3?.range(of: text.lowercased()) != nil ) || (tmp4?.range(of: text.lowercased()) != nil) || (tmp5?.range(of: text.lowercased()) != nil) || (tmp6?.range(of: text.lowercased()) != nil) || (tmp7?.range(of: text.lowercased()) != nil) || (tmp8?.range(of: text.lowercased()) != nil)
     
     })
     if(searchText == ""){
     searchActive = false
     if expandStatus == "1" {
     self.selectedIndexPath = self.selectedIndexPath2
     }
     
     } else {
     searchActive = true
     self.filterIDArrArr.removeAll()
     for i in 0..<filterListArr.count {
     let data = filterListArr[i]
     //let email = dic.object(forKey: "email") as? String
     self.filterIDArrArr.append(data.email!)
     }
     }
     
     self.tableView.reloadData()
     }*/
    
    //Calls this function when the tap is recognized.
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @IBAction func topClick(_ sender: UIButton) {
        communityView.isHidden = true
        if self.fullListArr.count > 0 {
            tableView.setContentOffset(CGPoint.zero, animated: true)
        }
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
//        var sectionCount = 0
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
        let tblView = UIView(frame: CGRect.zero)
        tableView.tableFooterView = tblView
        tableView.tableFooterView?.isHidden = true
        
        if tableView == communityTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CommunityCell") as! CommunityCell
            let data = self.communityList[(indexPath as NSIndexPath).row] as? Community
            cell.communityBtn.tag = indexPath.row
            cell.delegate = self
            cell.update(data!)
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
                    
                    
//                    self.filterListArr = self.filterListArr.sorted(by: { (contact1, contact2) -> Bool in
//                        if contact1.lastName == contact2.lastName {
//                            return contact1.firstName! < contact2.firstName!
//                        }else {
//                            return contact1.lastName! < contact2.lastName!
//                        }
//                    })
                    data = self.filterListArr[(indexPath as NSIndexPath).row]
                    
                }else {
//                    self.fullListArr = self.fullListArr.sorted(by: { (contact1, contact2) -> Bool in
//                        if contact1.lastName == contact2.lastName {
//                            return contact1.firstName! < contact2.firstName!
//                        }else {
//                            return contact1.lastName! < contact2.lastName!
//                        }
//                    })
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
//                    self.filterListArr = self.filterListArr.sorted(by: { (contact1, contact2) -> Bool in
//                        if contact1.lastName == contact2.lastName {
//                            return contact1.firstName! < contact2.firstName!
//                        }else {
//                            return contact1.lastName! < contact2.lastName!
//                        }
//
//                    })
                    data = self.filterListArr[(indexPath as NSIndexPath).row]
                }else {
//                    self.fullListArr = self.fullListArr.sorted(by: { (contact1, contact2) -> Bool in
//                        if contact1.lastName == contact2.lastName {
//                            return contact1.firstName! < contact2.firstName!
//                        }else {
//                            return contact1.lastName! < contact2.lastName!
//                        }
//                    })
                    data = self.fullListArr[(indexPath as NSIndexPath).row]
                }
                cell.updateView(data!)
                return cell
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == communityTableView {
            return 50
        }else {
            if(selectedIndexPath == indexPath.row) {
                return 190.0
            }
            return 70.0
        }
    }
    
    func communitySelected(_ sender: NSInteger) {
        topMenuSelected = 0
        appDelegate.tabbarView?.isHidden = false
        let data = self.communityList[sender] as? Community
        if data?.name == "All Communities" {
            topMenuStatus = 0
            headingBtn.setTitle("Contacts - All Communities", for: .normal)
            communityView.isHidden = true
            UserPreferences.SelectedCommunityID = 001
            UserPreferences.SelectedCommunityName = ""
            // getContacts()
            self.fullListArr.removeAll()
            self.allIDArr.removeAll()
            getContacts(searchItem: searchChar, offset: self.offset, limit: self.limit)
        }else {
            headingBtn.setImage(UIImage(named: "top-up-arrow"), for: .normal)
            UserPreferences.SelectedCommunityName = (data?.name)!
            headingBtn.setTitle("Contacts - \((data?.name)!)", for: .normal)
            UserPreferences.SelectedCommunityID = (data?.communityId)!
            communityView.isHidden = true
            //getContacts()
            self.fullListArr.removeAll()
            self.allIDArr.removeAll()
            getContacts(searchItem: searchChar, offset: self.offset, limit: self.limit)
        }
    }
    
    
    @IBAction func menuButtonClick(_ sender: UIButton) {
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
        self.present(controller, animated: true, completion: nil)
    }
    
    func openEmailClick(_ sender: NSInteger) {
        let data: Contacts!
        if(searchActive) {
            data = self.filterListArr[sender]
        }else {
            data = self.fullListArr[sender]
        }
        
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
        let sendMailErrorAlert = UIAlertController(title: "Could Not Send Email", message: "Your device could not send e-mail.  Please check e-mail configuration and try again.", preferredStyle: .alert)
        sendMailErrorAlert.addAction(UIAlertAction(title: "OK", style: .default) { _ in })
        self.present(sendMailErrorAlert, animated: true){}
    }
    
    // MARK: MFMailComposeViewControllerDelegate Method
    @objc(mailComposeController:didFinishWithResult:error:) func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func openPhoneClick(_ sender: NSInteger) {
        let data: Contacts!
        if(searchActive) {
            data = self.filterListArr[sender]
        }else {
            data = self.fullListArr[sender]
        }
        let optionMenu = UIAlertController(title: nil, message: "Choose Option", preferredStyle: .actionSheet)
        
        //Add Friend Popup
        let click = UIAlertAction(title: "Call", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            var number = ""
            if data?.mobile == "" {
                number = (data?.phone)!
            }else {
                number = (data?.mobile)!
            }
            
            if let numberUrl = URL(string: "tel://\(number)") {
                if #available(iOS 10, *) {
                    UIApplication.shared.open(numberUrl)
                } else {
                    UIApplication.shared.openURL(numberUrl)
                }
            }
        })
        
        let library = UIAlertAction(title: "Message", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            
            if (MFMessageComposeViewController.canSendText()) {
                let controller = MFMessageComposeViewController()
                ActivityIndicator.hide()
                controller.body = ""
                controller.recipients = [(data?.mobile)!]
                controller.messageComposeDelegate = self
                self.present(controller, animated: true, completion: nil)
            }
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {
            (alert: UIAlertAction!) -> Void in
        })
        optionMenu.addAction(click)
        optionMenu.addAction(library)
        optionMenu.addAction(cancelAction)
        
        self.present(optionMenu, animated: true, completion: nil)
        
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
        if(searchActive) {
            expandStatus = "1"
            let email = filterIDArrArr[rowNumber] 
            //return self.filterListArr.count
            for i in 0..<self.allIDArr.count {
                let email1 = allIDArr[i]
                if email == email1 {
                    self.selectedIndexPath2 = i
                }
            }
        }
        //self.loadingData = true
        self.tableView.reloadData()
    }
    
    func collapseClick(_ rowNumber: NSInteger) {
        //self.loadingData = true
        expandStatus = ""
        self.selectedIndexPath = nil
        self.tableView.reloadData()
    }
    
}

extension String {
    func condensingWhitespace() -> String {
        return self.components(separatedBy: .whitespacesAndNewlines)
            .filter { !$0.isEmpty }
            .joined(separator: " ")
    }
}



