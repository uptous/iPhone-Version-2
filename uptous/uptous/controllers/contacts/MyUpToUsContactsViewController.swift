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

class MyUpToUsContactsViewController: GeneralViewController,LandingCellDelegate,ExpandCellDelegate ,CustomSearchControllerDelegate , UISearchBarDelegate,MFMessageComposeViewControllerDelegate,MFMailComposeViewControllerDelegate,UIScrollViewDelegate,LKPullToLoadMoreDelegate,CommunityCellDelegate {
    
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    var selectedIndexPath: Int?
    var selectedIndexPath1 = "Landing"
    var itemsDatas = NSMutableArray()
    var loadMoreControl: LKPullToLoadMore!
    
    
    var searchActive : Bool = false
    var filterListArr : Array<AnyObject>!
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
        
        filterListArr = Array<AnyObject>()
        //CUSTOM SEARCH CONTROLLER
        self.configureCustomSearchController()
        communityView.isHidden = true
        
        
        let landingNib = UINib(nibName: "LandingCell", bundle: nil)
        tableView.register(landingNib, forCellReuseIdentifier: landingCellConstants.cellIdentifier as String)
        
        let expandNib = UINib(nibName: "ExpandCell", bundle: nil)
        tableView.register(expandNib, forCellReuseIdentifier: expandCellConstants.cellIdentifier as String)
        self.search(searchText: "0")
        
        loadMoreControl = LKPullToLoadMore(imageHeight: 40, viewWidth: tableView.frame.width, tableView: tableView)
        loadMoreControl.setIndicatorImage(UIImage(named: "LoadingImage")!)
        loadMoreControl.enable(true)
        loadMoreControl.delegate = self
        loadMoreControl.resetPosition()
        
        if UserPreferences.SelectedCommunityName == "" {
            headingBtn.setTitle("All", for: .normal)
        }else{
            headingBtn.setTitle(UserPreferences.SelectedCommunityName, for: .normal)
        }
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(MyUpToUsContactsViewController.dismissKeyboard))
        
       view.addGestureRecognizer(tap)
    }
    
    //Calls this function when the tap is recognized.
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if UserPreferences.SelectedCommunityName == "" {
            headingBtn.setTitle("All", for: .normal)
        }else{
            headingBtn.setTitle(UserPreferences.SelectedCommunityName, for: .normal)
        }

        let delayTime = DispatchTime.now() + Double(Int64(1 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
            DispatchQueue.main.asyncAfter(deadline: delayTime) {
            self.getTotalContacts()
                self.search(searchText: "0")
        }
    }
    
    //MARk:- Top Menu Community
    @IBAction func topMenuButtonClick(_ sender: UIButton) {
        fetchCommunity()
        appDelegate.tabbarView?.isHidden = true
        communityView.isHidden = false
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
            dic1["name"] = "All Community"
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

    //MARK: Fetch Records
    func getTotalContacts() {
        DataConnectionManager.requestGETURL1(api: TotalContacts, para: ["":""], success: {
            (response) -> Void in
            print(response)
            let item = response as! NSDictionary
            self.totalContacts = Int((item.object(forKey: "total") as? String)!)!
            
        }) {
            (error) -> Void in
        }
    }
    
    //MARK:- SEARCH API HIT
    func search(searchText: String){
        appDelegate.tabbarView?.isHidden = false
        //self.filterListArr.removeAll()
        
        var text: String = ""
        if searchText == "" {
            text = "0"
        }else {
            text = searchText
        }
        let api = ("\(Members)") + ("/community/0") + ("/search/\(text)") + ("/limit/\(limit)") + ("/offset/0")
        
        DataConnectionManager.requestGETURL1(api: api, para: ["":""], success: {
            (jsonResult) -> Void in
            print(jsonResult)
            
            let listArr = jsonResult as! NSArray
            print("listArr ==>\(listArr.count)")
            
            self.searchKeyBool = false
            if listArr.count != 0 {
                self.communityView.isHidden = true
                
                for index in 0..<listArr.count {
                    let dic = listArr.object(at: index) as! NSDictionary
                    
                    if UserPreferences.SelectedCommunityID == 001 {
                        self.filterListArr.append(Contacts(info: dic))
                    }else {
                        let communityID = UserPreferences.SelectedCommunityID
                        let results = dic.object(forKey: "communities") as! NSArray
                        for i in 0..<results.count {
                            let dic1 = results.object(at: i) as! NSDictionary
                            if (dic1.object(forKey: "id") as! Int) == communityID {
                                self.filterListArr.append(Contacts(info: dic))
                            }
                        }
                    }
                }
                self.tableView.reloadData()
            }
            
        }) {
            (error) -> Void in
            
            let alert = UIAlertController(title: "Alert", message: "Error", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Try Again", style: UIAlertActionStyle.default, handler: nil))
            //self.present(alert, animated: true, completion: nil)
        }
    }
    
    //MARK: Load More Control
    func loadMore() {
        loadMoreControl.loading(true)
        
        self.limit += 20
        //self.loadingData = false
        self.searchKeyBool = true
        self.filterListArr.removeAll()
        self.search(searchText: self.searchKey)
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(3 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)) {
            self.tableView.reloadData()
            self.loadMoreControl.loading(false)
            self.loadMoreControl.resetPosition()
        }
    }
    
    
    //MARK: - Scroll View
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        loadMoreControl.scrollViewDidScroll(scrollView)
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        loadMoreControl.scrollViewWillEndDragging(scrollView, withVelocity: velocity, targetContentOffset: targetContentOffset)
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
                if(filterListArr.count == 0) {
                    sectionCount = 1
                }else {
                    sectionCount = filterListArr.count
                }
            }else {
                sectionCount=filterListArr.count
            }
            return sectionCount
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
                
                if(self.filterListArr.count > 0){
                    let data = self.filterListArr[(indexPath as NSIndexPath).row] as? Contacts
                    cell.updateView(data!)
                }
                return cell
            }else {
                
                let cell: LandingCell = tableView.dequeueReusableCell(withIdentifier: landingCellConstants.cellIdentifier ) as! LandingCell
                cell.expandBtn.tag = indexPath.row
                cell.delegate = self
                
                if(self.filterListArr.count > 0){
                    let data = self.filterListArr[(indexPath as NSIndexPath).row] as? Contacts
                    cell.updateView(data!)
                }
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
        let data = self.communityList[sender] as? Community
        if data?.name == "All Community" {
            topMenuStatus = 0
            headingBtn.setTitle("All Community", for: .normal)
            communityView.isHidden = true
            UserPreferences.SelectedCommunityID = 001
            UserPreferences.SelectedCommunityName = ""
            self.filterListArr.removeAll()
            if self.searchKey == "" {
                self.search(searchText: "0")
            }else {
                self.search(searchText: self.searchKey)
            }
        }else {
            headingBtn.setImage(UIImage(named: "top-up-arrow"), for: .normal)
            UserPreferences.SelectedCommunityName = (data?.name)!
            headingBtn.setTitle((data?.name)!, for: .normal)
            UserPreferences.SelectedCommunityID = (data?.communityId)!
            communityView.isHidden = true
            self.filterListArr.removeAll()
            if self.searchKey == "" {
                self.search(searchText: "0")
            }else {
                self.search(searchText: self.searchKey)
            }
        }

    }
    
   /* func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView == communityTableView {
            let data = self.communityList[(indexPath as NSIndexPath).row] as? Community
            if data?.name == "My UpToUs Contacts" {
                topMenuStatus = 0
                headingBtn.setTitle("All", for: .normal)
                communityView.isHidden = true
                UserPreferences.SelectedCommunityID = 001
                UserPreferences.SelectedCommunityName = ""
                self.filterListArr.removeAll()
                if self.searchKey == "" {
                    self.search(searchText: "0")
                }else {
                    self.search(searchText: self.searchKey)
                }
            }else {
                headingBtn.setImage(UIImage(named: "top-up-arrow"), for: .normal)
                UserPreferences.SelectedCommunityName = (data?.name)!
                headingBtn.setTitle((data?.name)!, for: .normal)
                UserPreferences.SelectedCommunityID = (data?.communityId)!
                communityView.isHidden = true
                self.filterListArr.removeAll()
                if self.searchKey == "" {
                    self.search(searchText: "0")
                }else {
                    self.search(searchText: self.searchKey)
                }
            }
        }
    }*/

    
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
            controller.recipients = [(data?.phone)!]
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
    
    // Loading More users in serach
    /*func loadMore() {
        DispatchQueue.main.async( execute: {
            if self.filterListArr.count == self.totalContacts - 1 {
                self.loadingData = true
                print("reached end of data. Batch count: \(self.filterListArr.count)")
            }
            
            if self.loadingData == false {
                self.limit += 10
                self.loadingData = false
                self.searchKeyBool = true
                self.filterListArr.removeAll()
                self.search(searchText: self.searchKey)
            }
        })
    }*/
    
    func expandClick(_ rowNumber: NSInteger) {
        self.selectedIndexPath = rowNumber
        self.loadingData = true
        self.tableView.reloadData()
    }
    
    func collapseClick(_ rowNumber: NSInteger) {
        self.loadingData = true
        self.selectedIndexPath = nil
        self.tableView.reloadData()
    }
    
    //Roshan
    //MARK:-SEARCH BAR DELEGATE
    func configureCustomSearchController() {
        customSearchController = CustomSearchController(searchResultsController: self, searchBarFrame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 50), searchBarFont: UIFont(name: "Futura", size: 16.0)!, searchBarTextColor: UIColor.gray, searchBarTintColor: UIColor.white)
        
        let text = "Search Contact"
        let maxSize =   CGSize(width: UIScreen.main.bounds.size.width - 60, height: 40) //CGSize(UIScreen.main.bounds.size.width - 60, 40)
        let wt = text.characters.count
        let spaces = floor(maxSize.width - CGFloat(wt))/7
        var s: String = "Search Contact"
        
        for i in 1..<Int(spaces) {
            let c: Character = " "
            s += "\(c)"
        }
        //		for var i = 1; i <= Int(spaces); i += 1
        //		{
        //			let c: Character = " "
        //			s += "\(c)"
        //		}
        let newText = s
        customSearchController.customSearchBar.placeholder = newText
        //customSearchController.customSearchBar.tag=2
        tableView.tableHeaderView = customSearchController.customSearchBar
        customSearchController.customSearchBar.setImage(UIImage(named: "search_blue"), for: .search, state: .normal)
        customSearchController.customDelegate=self
    }
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        searchActive = true
        tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchActive = false
        customSearchController.searchBar.endEditing(true)
        searchController.searchBar.resignFirstResponder()
        
        tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        if !searchActive {
            searchActive = true
            tableView.reloadData()
        }
        customSearchController.searchBar.endEditing(true)
        
        searchController.searchBar.resignFirstResponder()
    }
    
    // MARK: CustomSearchControllerDelegate functions
    func didStartSearching() {
        searchActive = true
    }
    
    func didTapOnSearchButton() {
        if !searchActive {
            searchActive = true
            tableView.reloadData()
            
        }
    }
    
    func didTapOnCancelButton() {
        cancelbool=true
        searchActive = false
        customSearchController.searchBar.endEditing(true)
        self.filterListArr.removeAll()
        self.limit = 20
        self.search(searchText: "0")
    }
    
    func didChangeSearchText(searchText: String) {
        if (searchText == "") {
            searchActive = false
            customSearchController.customSearchBar.resignFirstResponder()
            customSearchController.searchBar.endEditing(true)
            self.filterListArr.removeAll()
            self.limit = 20
            self.search(searchText: "0")
        }
        searchKey = searchText
        //page = 1
        if(searchText.characters.count != 0) {
            self.filterListArr.removeAll()
            search(searchText: searchText)
            customSearchController.searchBar.endEditing(true)
            
        }else {
            customSearchController.customSearchBar.resignFirstResponder()
            customSearchController.searchBar.endEditing(true)
            
            self.filterListArr.removeAll()
            self.tableView.reloadData()
        }
    }
    

}


