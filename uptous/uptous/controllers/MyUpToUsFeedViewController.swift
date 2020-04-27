//
//  MyUpToUsFeedViewController.swift
//  uptous
//
//  Created by Roshan Gita  on 8/10/16.
//  Copyright © 2016 SPA. All rights reserved.
//

import UIKit
import MessageUI
import Alamofire

enum feedNewsType : String {
    case Photos = "Photos"
    case File   = "File"
    case Announcement = "Announcement"
    case Opportunity = "Opportunity"
    case PrivateThreads = "Private Threads"
    //case PersonalAnnouncement = "Private Threads"
    /*case Post
     case Announcement
     case File
     case Homework
     case Link
     case JoinedUser*/
}

class MyUpToUsFeedViewController: GeneralViewController,PhotosCellDelegate,AnnouncementCellDelegate,PrivateThreadsCellDelegate,OpportunityCellDelegate,FileCellDelegate,MFMailComposeViewControllerDelegate,UISearchBarDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var communityTableView: UITableView!
    @IBOutlet weak var communityView: UIView!
    @IBOutlet weak var headingBtn: UIButton!
    @IBOutlet weak var postBtn: UIButton!
    @IBOutlet weak var directBtn: UIButton!
    @IBOutlet weak var pictureBtn: UIButton!
    @IBOutlet weak var messageBtn: UIButton!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var messageView: UIView!
    var isButtonSelected = false
    var filterStatus = false
    var topMenuStatus = 0
    //@IBOutlet weak var notifNoRecordsView: UIView!
    var topMenuSelected = 0
    
    
    @IBOutlet weak var searchBar: UISearchBar!
    var searchActive : Bool = false
    var filterListArr = [Feed]()
    var searchKey: String = ""
    var searchKeyBool: Bool = false
    
    var newsTypeList = [Feed]()
    var newsList = NSArray()
    var communityList = NSMutableArray()
    
    var searchedArray = [Feed]()
    var refreshControl: UIRefreshControl!
    let defaults = UserDefaults.standard
    
    
    fileprivate struct photosCellConstants {
        static var cellIdentifier:String = "PhotosCell"
        static var rowHeight:CGFloat! = 340
    }
    
    fileprivate struct fileCellConstants {
        static var cellIdentifier:String = "FileCell"
        static var rowHeight:CGFloat! = 250
    }
    
    fileprivate struct announcementCellConstants {
        static var cellIdentifier:String = "AnnouncementCell"
        static var rowHeight:CGFloat! = 310
    }
    
    fileprivate struct opportunityCellConstants {
        static var cellIdentifier:String = "OpportunityCell"
        static var rowHeight:CGFloat! = 270
        
    }
    
    fileprivate struct  personalThreadsCellConstants {
        static var cellIdentifier:String = "PrivateThreadsCell"
        static var rowHeight:CGFloat! = 310
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        communityView.isHidden = true
        self.searchBar.delegate = self
        //MARK:- For UI Design Notification
        let photosNib = UINib(nibName: "PhotosCell", bundle: nil)
        tableView.register(photosNib, forCellReuseIdentifier: photosCellConstants.cellIdentifier as String)
        
        let fileNib = UINib(nibName: "FileCell", bundle: nil)
        tableView.register(fileNib, forCellReuseIdentifier: fileCellConstants.cellIdentifier as String)
        
        let announcementNib = UINib(nibName: "AnnouncementCell", bundle: nil)
        tableView.register(announcementNib, forCellReuseIdentifier: announcementCellConstants.cellIdentifier as String)
        
        let opportunityNib = UINib(nibName: "OpportunityCell", bundle: nil)
        tableView.register(opportunityNib, forCellReuseIdentifier: opportunityCellConstants.cellIdentifier as String)
        
        let personalThreadNib = UINib(nibName: "PrivateThreadsCell", bundle: nil)
        tableView.register(personalThreadNib, forCellReuseIdentifier: personalThreadsCellConstants.cellIdentifier as String)
        
        if UserPreferences.SelectedCommunityName == "" {
            headingBtn.setTitle("Feed - All Communities", for: .normal)
        }else{
            headingBtn.setTitle(UserPreferences.SelectedCommunityName, for: .normal)
        }
         //notifNoRecordsView.isHidden = true
        messageView.isHidden = true
        self.tableView.isHidden = true
        //Fetch Feed Items
        self.getFeedList()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        searchBar.text = ""
        if UserPreferences.SelectedCommunityName == "" {
            headingBtn.setTitle("Feed - All Communities", for: .normal)
        }else{
            headingBtn.setTitle("Feed - \(UserPreferences.SelectedCommunityName)", for: .normal)
        }
        self.tableView.isHidden = true
        messageView.isHidden = true
        messageBtn.isHidden = true
        pictureBtn.isHidden = true
        //directBtn.isHidden = true
        onTimerTick()
        self.getFeedList()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        ActivityIndicator.hide()
    }
    
    // MARK: UISearchBarDelegate functions
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActive = false
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
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
        self.filterListArr = self.newsTypeList.filter({( feed: Feed) -> Bool in
            let tmp = feed.ownerName!.lowercased()
            let tmp1 = feed.communityName!.lowercased()
            let tmp2 = feed.newsType!.lowercased()
            let tmp3 = feed.newsItemName!.lowercased()
            
            //print(tmp?.range(of: searchText.lowercased()))
            //print($0.firstName!.rangeOfString(searchText) != nil)
            return (tmp.range(of: searchText.lowercased()) != nil) || (tmp1.range(of: searchText.lowercased()) != nil) || (tmp2.range(of: searchText.lowercased()) != nil) || (tmp3.range(of: searchText.lowercased()) != nil)
            
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


    @IBAction func menuButtonClick(_ sender: UIButton) {
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
        self.present(controller, animated: true, completion: nil)
    }
    
    @IBAction func inviteButtonClick(_ sender: UIButton) {
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "InviteViewController") as! InviteViewController
        self.present(controller, animated: true, completion: nil)
    }
    
    func onTimerTick() {
        DataConnectionManager.requestGETURL1(api: FeedUpdateAPI, para: ["":""], success: {
            (response) -> Void in
            
            let data = response as? NSDictionary
            
            if data != nil {
                let status = data?.object(forKey: "status") as? String
                if (status == "2") {
                    //self.notifNoRecordsView.isHidden = false

                }else {
                    if data?.object(forKey: "lastItemTime") as? NSNumber != self.defaults.object(forKey: "LastModified") as? NSNumber {
                        self.defaults.set(data?.object(forKey: "lastItemTime"), forKey: "LastModified")
                        self.getFeedList()
                    }
                }
            }
        }) {
            (error) -> Void in
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
    
    
    //MARK:- Mail Composer
    func sendEmail(_ data: Feed) {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients([data.ownerEmail!])
            let sub = "Re: \(data.newsItemName!)"
            mail.setMessageBody("", isHTML: true)
            mail.setSubject("\(sub.removingPercentEncoding!)")
            
            present(mail, animated: true, completion: nil)
        } else {
            // show failure alert
            self.showSendMailErrorAlert()
        }
    }
    
    
    func showSendMailErrorAlert() {
        let sendMailErrorAlert = UIAlertController(title: "Could Not Send Email", message: "Your device could not send the e-mail. Please check configuration.", preferredStyle: UIAlertController.Style.alert)
        sendMailErrorAlert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(sendMailErrorAlert, animated: true, completion: nil)
    }
    
    // MARK: MFMailComposeViewControllerDelegate Method
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func getFeedList1() {
        appDelegate.tabbarView?.isHidden = false
        self.communityView.isHidden = true
        DataConnectionManager.requestGETURL1(api: FeedAPI, para: ["":""], success: {
            (response) -> Void in
            print(response)
            
            self.newsTypeList.removeAll()
            self.newsList = response as! NSArray
            
            for i in 0 ..< self.newsList.count {
                let result = self.newsList.object(at: i) as? NSDictionary
                let data = Feed(info: result)
                
                if UserPreferences.SelectedCommunityID == 001 {
                    if data.newsType == "File" || data.newsType == "Private Threads" || data.newsType == "Announcement" || data.newsType == "Photos" || data.newsType == "Opportunity" {
                        self.newsTypeList.append(data)
                    }
                }else {
                    if data.communityId == UserPreferences.SelectedCommunityID {
                        if data.newsType == "File" || data.newsType == "Private Threads" || data.newsType == "Announcement" || data.newsType == "Photos" || data.newsType == "Opportunity" {
                            self.newsTypeList.append(data)
                        }
                    }
                }
            }
            
            if UserPreferences.SelectedCommunityID == 001 {
            }else {
                let communityID = UserPreferences.SelectedCommunityID
                self.newsTypeList = self.newsTypeList.filter{ $0.communityId == communityID }
            }
            
            if self.newsTypeList.count > 0 {
                self.tableView.isHidden = false
                self.tableView.reloadData()
            }else {
                self.tableView.isHidden = true
                let alert = UIAlertController(title: "Alert", message: "No Record Found", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
            
        }) {
            (error) -> Void in
            
            let alert = UIAlertController(title: "Alert", message: "Error", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Try Again", style: UIAlertAction.Style.default, handler: nil))
            //self.present(alert, animated: true, completion: nil)
        }
    }
    
    
    func getFeedList() {
        appDelegate.tabbarView?.isHidden = false
        self.communityView.isHidden = true
        DataConnectionManager.requestGETURL(api: FeedAPI, para: ["":""], success: {
            (response) -> Void in
            print(response)
            
            self.newsTypeList.removeAll()
            self.newsList = response as! NSArray
            
            for i in 0 ..< self.newsList.count {
                let result = self.newsList.object(at: i) as? NSDictionary
                let data = Feed(info: result)
                
                if UserPreferences.SelectedCommunityID == 001 {
                    if data.newsType == "File" || data.newsType == "Private Threads" || data.newsType == "Announcement" || data.newsType == "Photos" || data.newsType == "Opportunity" {
                        self.newsTypeList.append(data)
                    }
                }else {
                    if data.communityId == UserPreferences.SelectedCommunityID {
                        if data.newsType == "File" || data.newsType == "Private Threads" || data.newsType == "Announcement" || data.newsType == "Photos" || data.newsType == "Opportunity" {
                            self.newsTypeList.append(data)
                        }
                    }
                }
            }
            
            if UserPreferences.SelectedCommunityID == 001 {
            }else {
                let communityID = UserPreferences.SelectedCommunityID
                self.newsTypeList = self.newsTypeList.filter{ $0.communityId == communityID }
            }
            
            if self.newsTypeList.count > 0 {
                self.tableView.isHidden = false
                self.messageView.isHidden = true
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
            //self.present(alert, animated: true, completion: nil)
        }
    }
    
    //MARK: PhotoCell Delegate
    func photoReplyTo(_ sender: NSInteger) {
        if(searchActive == true) {
            let data = filterListArr[sender]
            sendEmail(data)
        } else{
            let data = newsTypeList[sender]
            sendEmail(data)
        }
        
    }
    
    func photoComment(_ sender: NSInteger) {
        let data: Feed!
        if(searchActive == true) {
            data = self.filterListArr[sender]
        }else {
            data = self.newsTypeList[sender]
        }
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "ReadMoreViewController") as! ReadMoreViewController
        controller.data = data
        self.present(controller, animated: true, completion: nil)
    }
    
    func photoComment1(_ sender: NSInteger) {
        let data: Feed!
        if(searchActive == true) {
            data = self.filterListArr[sender]
        }else {
            data = self.newsTypeList[sender]
        }
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "ReadMoreViewController") as! ReadMoreViewController
        controller.data = data
        self.present(controller, animated: true, completion: nil)
    }
    
    func readMore(_ sender: NSInteger) {
        let data: Feed!
        if(searchActive == true) {
            data = self.filterListArr[sender]
        }else {
            data = self.newsTypeList[sender]
        }
        print(data ?? "No Data")
        
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "ReadMoreViewController") as! ReadMoreViewController
        controller.data = data
        self.present(controller, animated: true, completion: nil)
    }
    
    func openAlbumPage(_ sender: NSInteger) {
        let data: Feed!
        if(searchActive == true) {
            data = self.filterListArr[sender]
        }else {
            data = self.newsTypeList[sender]
        }
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "DetailsLibraryViewController") as! DetailsLibraryViewController
        controller.albumID = ("\(data.newsItemId!)")
        self.present(controller, animated: true, completion: nil)
    }
    
    //MARK: AnnouncementCell Delegate
    func announcementReplyTo(_ sender: NSInteger) {
        let data: Feed!
        if(searchActive == true) {
            data = self.filterListArr[sender]
        }else {
            data = self.newsTypeList[sender]
        }
        sendEmail(data)
    }
    
    func announcementReplyAll(_ sender: NSInteger) {
        let data: Feed!
        if(searchActive == true) {
            data = self.filterListArr[sender]
        }else {
            data = self.newsTypeList[sender]
        }
        
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "ReplyAllViewController") as! ReplyAllViewController
        controller.data = data
        self.present(controller, animated: true, completion: nil)
    }
    
    func announcementPost(_ sender: NSInteger) {
        let data: Feed!
        if(searchActive == true) {
            data = self.filterListArr[sender]
        }else {
            data = self.newsTypeList[sender]
        }
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "ReplyAllViewController") as! ReplyAllViewController
        controller.data = data
        self.present(controller, animated: true, completion: nil)
    }
    
    //MARK: Private Thread Delegate
    func privateThreadReplyTo(_ sender: NSInteger) {
        let data: Feed!
        if(searchActive == true) {
            data = self.filterListArr[sender]
        }else {
            data = self.newsTypeList[sender]
        }
        sendEmail(data)
    }
    
    func privateThreadReplyAll(_ sender: NSInteger) {
        let data: Feed!
        if(searchActive == true) {
            data = self.filterListArr[sender]
        }else {
            data = self.newsTypeList[sender]
        }
        
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "ReplyAllViewController") as! ReplyAllViewController
        controller.data = data
        self.present(controller, animated: true, completion: nil)
    }
    
    func privateThreadComment(_ sender: NSInteger) {
        let data: Feed!
        if(searchActive == true) {
            data = self.filterListArr[sender]
        }else {
            data = self.newsTypeList[sender]
        }
        
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "ReplyAllViewController") as! ReplyAllViewController
        controller.data = data
        self.present(controller, animated: true, completion: nil)
    }
    
    //MARK: Opportunity Delegate
    func opportunityReplyTo(_ sender: NSInteger) {
        let data: Feed!
        if(searchActive == true) {
            data = self.filterListArr[sender]
        }else {
            data = self.newsTypeList[sender]
        }
        sendEmail(data)
    }
    
    func opportunityComment(_ sender: NSInteger) {
        let data: Feed!
        if(searchActive == true) {
            data = self.filterListArr[sender]
        }else {
            data = self.newsTypeList[sender]
        }
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "CommentViewController") as! CommentViewController
        controller.data = data
        self.present(controller, animated: true, completion: nil)
    }
    
    func opportunityComment1(_ sender: NSInteger) {
        let data: Feed!
        if(searchActive == true) {
            data = self.filterListArr[sender]
        }else {
            data = self.newsTypeList[sender]
        }
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "CommentViewController") as! CommentViewController
        controller.data = data
        self.present(controller, animated: true, completion: nil)
    }
    
    func openSignUpPage(_ sender: NSInteger) {
        
        let event: Feed!
        if(searchActive == true) {
            event = self.filterListArr[sender]
        }else {
            event = self.newsTypeList[sender]
        }
        print(event.newsType!)
        
        let apiName = SignupItems + ("\(event.newsItemId!)")
        DataConnectionManager.requestGETURL(api: apiName, para: ["":""], success: {
            (response) -> Void in
            print(response)
            
            let driverDatas = (response as? NSArray)!
            let dic = driverDatas.object(at: 0) as? NSDictionary
            let type = dic?.object(forKey: "type") as! String
            self.signupType(newsType: type, event: event)
            
        }) {
            (error) -> Void in
        }
    }
    
    //MARK: Fetch Driver Records
    func fetchDriverItems(data1: Feed, signUpType: String) {
        let apiName = SignupItems + ("\(data1.newsItemId!)")
        
        DataConnectionManager.requestGETURL1(api: apiName, para: ["":""], success: {
            (response) -> Void in
            let driverDatas = (response as? NSArray)!
            let dic = driverDatas.object(at: 0) as? NSDictionary
            let dataSheet = SignupSheet(info: dic)
            
            //appDelegate.globalSignUpData = data
            
            if dataSheet.contact == "" && dataSheet.contact2 == "" {
                let controller = self.storyboard?.instantiateViewController(withIdentifier: "SignUpType1ViewController") as! SignUpType1ViewController
                //controller.data = dataSheet
                controller.data1 = data1
                controller.signUpType = signUpType
                self.present(controller, animated: true, completion: nil)
            }else {
                let controller = self.storyboard?.instantiateViewController(withIdentifier: "SignUpType3ViewController") as! SignUpType3ViewController
                //controller.data = dataSheet
                controller.data1 = data1
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
    
    
    func signupType(newsType: String,event: Feed) {
        if (newsType == "Drivers") {
            fetchDriverItems(data1: event , signUpType: "103")
            
        }else if (newsType == "RSVP" || newsType == "Vote") {
            fetchDriverItems(data1: event , signUpType: "102")
            
        }else if (newsType == "Shifts" || newsType == "Snack" || newsType == "Games" || newsType == "Multi Game/Event RSVP" || newsType == "Snack Schedule") {
            fetchDriverItems(data1: event , signUpType: "100")
            
        }else if (newsType == "Volunteer" || newsType == "Potluck" || newsType == "Wish List" || newsType == "Potluck/Party" || newsType == "Ongoing" || newsType == "Ongoing Volunteering") {
            fetchDriverItems(data1: event , signUpType: "101")
            
        }else {
            let alertView = UIAlertController(title: "UpToUs", message: "We're sorry but for now, this type of sign-up is not accessible with the app", preferredStyle: .alert)
            alertView.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (alertAction) -> Void in
                
            }))
            present(alertView, animated: true, completion: nil)
        }
    }
    
    
    //MARK: File Delegate
    func fileReplyTo(_ sender: NSInteger) {
        let data: Feed!
        if(searchActive == true) {
            data = self.filterListArr[sender]
        }else {
            data = self.newsTypeList[sender]
        }
        sendEmail(data)
    }
    
    func fileComment(_ sender: NSInteger) {
        let data: Feed!
        if(searchActive == true) {
            data = self.filterListArr[sender]
        }else {
            data = self.newsTypeList[sender]
        }
        
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "CommentViewController") as! CommentViewController
        controller.data = data
        self.present(controller, animated: true, completion: nil)
    }
    
    func commentBtn(_ sender: NSInteger) {
        let data: Feed!
        if(searchActive == true) {
            data = self.filterListArr[sender]
        }else {
            data = self.newsTypeList[sender]
        }
        
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "CommentViewController") as! CommentViewController
        controller.data = data
        self.present(controller, animated: true, completion: nil)
    }
    
    //MARK:- PDF Download
    func downloadPDF(_ sender: NSInteger) {
        let data: Feed!
        if(searchActive == true) {
            data = self.filterListArr[sender]
        }else {
            data = self.newsTypeList[sender]
        }
        
        let docFile = data.newsItemUrl?.components(separatedBy: ".").last
        
        if docFile == "doc" || docFile == "docx" || docFile == "pdf" || docFile == "JPG" || docFile == "png" || docFile == "xls" || docFile == "xlsx" || docFile == "MOV" || docFile == "MP3" || docFile == "mp3"  || docFile == "jpg"  || docFile == "PNG"  || docFile == "mov" {
            let controller = self.storyboard?.instantiateViewController(withIdentifier: "FileListViewController") as! FileListViewController
            controller.filePath = data.newsItemUrl
            self.present(controller, animated: true, completion: nil)
            
        }else {
            DispatchQueue.main.async(execute: { () -> Void in
                let alert = UIAlertController(title: "Alert", message: "Files in this format cannot be downloaded to the iPhone", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            })
        }
        
        
        
        /*let controller = self.storyboard?.instantiateViewController(withIdentifier: "PDFViewerViewController") as! PDFViewerViewController
        controller.data = data
        self.present(controller, animated: true, completion: nil)*/
        
    }
    
    //MARK:- Post Button
    @IBAction func postButtonClick(_ sender: UIButton) {
        if isButtonSelected == true {
            isButtonSelected = false
            self.messageBtn.isHidden = true
            self.pictureBtn.isHidden = true
        } else {
            isButtonSelected = true
            messageBtn.isHidden = false
            pictureBtn.isHidden = false
        }
    }
    
    @IBAction func messageBtnClick(_ sender: UIButton) {
        let controller = MessagePostViewController(nibName: "MessagePostViewController", bundle: nil)
        self.present(controller, animated: true, completion: nil)
    }
    
    @IBAction func pictureBtnClick(_ sender: UIButton) {
        let controller = ImagePostViewController(nibName: "ImagePostViewController", bundle: nil)
        self.present(controller, animated: true, completion: nil)
    }
    
    @IBAction func directBtnClick(_ sender: UIButton) {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

//MARK:- Degree To Radians
extension Int {
    var degreesToRadians: Double { return Double(self) * Double.pi / 180 }
    var radiansToDegrees: Double { return Double(self) * 180 / Double.pi }
}

protocol DoubleConvertible {
    init(_ double: Double)
    var double: Double { get }
}
extension Double : DoubleConvertible { var double: Double { return self         } }
extension Float  : DoubleConvertible { var double: Double { return Double(self) } }
extension CGFloat: DoubleConvertible { var double: Double { return Double(self) } }

extension DoubleConvertible {
    var degreesToRadians: DoubleConvertible {
        return Self(double * Double.pi / 180)
    }
    var radiansToDegrees: DoubleConvertible {
        return Self(double * 180 / Double.pi)
    }
}
//MARK:- TableView Delegate
extension MyUpToUsFeedViewController: UITableViewDataSource,UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == communityTableView {
            return self.communityList.count
            
        }else {
            if(searchActive == true) {
                return self.filterListArr.count
            } else{
                return self.newsTypeList.count
            }
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var  sectionName: String = ""
        if tableView != communityTableView {
            if(searchActive == true) {
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
            let data: Feed!
            if(searchActive == true) {
                data = self.filterListArr[(indexPath as NSIndexPath).row]
            }else {
                data = self.newsTypeList[(indexPath as NSIndexPath).row]
            }
            
            switch feedNewsType(rawValue: data.newsType!)! {
                
            case .Photos :
                let cell: PhotosCell = tableView.dequeueReusableCell(withIdentifier: photosCellConstants.cellIdentifier ) as! PhotosCell
                cell.commentBtn.tag = (indexPath as NSIndexPath).row
                cell.comment1Btn.tag = (indexPath as NSIndexPath).row
                cell.replyToBtn.tag = (indexPath as NSIndexPath).row
                //cell.readMoreBtn.tag = (indexPath as NSIndexPath).row
                cell.albumPageBtn.tag = (indexPath as NSIndexPath).row
                cell.delegate = self
                
                cell.updateData(data)
                
                return cell
                
            case .File :
                let cell: FileCell = tableView.dequeueReusableCell(withIdentifier: fileCellConstants.cellIdentifier ) as! FileCell
                cell.commentBtn.tag = (indexPath as NSIndexPath).row
                cell.comment1Btn.tag = (indexPath as NSIndexPath).row
                cell.replyToBtn.tag = (indexPath as NSIndexPath).row
                cell.pdfDownloadBtn.tag = (indexPath as NSIndexPath).row
                cell.delegate = self
                
                cell.updateData(data)
                
                return cell
                
            case .Announcement :
                let cell: AnnouncementCell = tableView.dequeueReusableCell(withIdentifier: announcementCellConstants.cellIdentifier ) as! AnnouncementCell
                cell.replyAllBtn.tag = (indexPath as NSIndexPath).row
                cell.postBtn.tag = (indexPath as NSIndexPath).row
                cell.replyToBtn.tag = (indexPath as NSIndexPath).row
                cell.delegate = self
                
                cell.updateData(data)
                
                return cell
                
            case .Opportunity :
                let cell: OpportunityCell = tableView.dequeueReusableCell(withIdentifier: opportunityCellConstants.cellIdentifier ) as! OpportunityCell
                cell.commentBtn.tag = (indexPath as NSIndexPath).row
                cell.comment1Btn.tag = (indexPath as NSIndexPath).row
                cell.replyToBtn.tag = (indexPath as NSIndexPath).row
                cell.signUpBtn.tag = (indexPath as NSIndexPath).row
                cell.delegate = self
                
                cell.updateData(data)
                
                return cell
                
            case .PrivateThreads :
                let cell: PrivateThreadsCell = tableView.dequeueReusableCell(withIdentifier: personalThreadsCellConstants.cellIdentifier ) as! PrivateThreadsCell
                cell.replyAllBtn.tag = (indexPath as NSIndexPath).row
                cell.replyToBtn.tag = (indexPath as NSIndexPath).row
                cell.commentBtn.tag = (indexPath as NSIndexPath).row
                cell.delegate = self
                
                cell.updateData(data)
                
                return cell
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if tableView == communityTableView {
            return 50
        }else {
            let data: Feed!
            if(searchActive == true) {
                data = self.filterListArr[(indexPath as NSIndexPath).row]
            }else {
                data = self.newsTypeList[(indexPath as NSIndexPath).row]
            }
            switch feedNewsType(rawValue: data.newsType!)! {
                
            case .Photos :
                return 308
                
            case .File :
                return 250
                
            case .Announcement :
                return 310
                
            case .Opportunity :
                return 270
                
            case .PrivateThreads :
                return 310
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView == communityTableView {
            topMenuSelected = 0
            let data = self.communityList[(indexPath as NSIndexPath).row] as? Community
            if data?.name == "All Communities" {
                topMenuStatus = 0
                headingBtn.setImage(UIImage(named: "top-down-arrow"), for: .normal)
                headingBtn.setTitle("Feed - All Communities", for: .normal)
                communityView.isHidden = true
                UserPreferences.SelectedCommunityID = 001
                UserPreferences.SelectedCommunityName = ""
                getFeedList()
            }else {
                headingBtn.setImage(UIImage(named: "top-up-arrow"), for: .normal)
                UserPreferences.SelectedCommunityName = (data?.name)!
                headingBtn.setTitle("Feed - \((data?.name)!)", for: .normal)
                UserPreferences.SelectedCommunityID = (data?.communityId)!
                communityView.isHidden = true
                getFeedList()
            }
        }
    }
}

//MARK:- TextField Delegate
extension MyUpToUsFeedViewController: UITextFieldDelegate {
    func getFilteredFilter(_ text: String){
        searchedArray.removeAll()
        let namePredicate =
            NSPredicate(format: "SELF.newsType beginswith[c] %@", text)
        
        searchedArray = self.newsTypeList.filter { namePredicate.evaluate(with: $0) }
        print("names = ,\(searchedArray)")
        if searchedArray.count > 0 {
            filterStatus = true
        }else {
            filterStatus = false
        }
        tableView.reloadData()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var subString: NSString = searchTextField.text! as NSString
        subString = subString.replacingCharacters(in: range, with: string) as NSString
        print(subString)
        getFilteredFilter(subString as String)
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        searchedArray.removeAll()
        tableView.reloadData()
        
        //Add Search Table View
        /* if !tableView.isDescendantOfView(view) {
         view.addSubview(tableView)
         tableView.layer.cornerRadius = 4.0;
         //tableView.layer.borderColor = cyanColor.CGColor
         tableView.layer.borderWidth = 2.0
         var frame = tableView.frame
         frame.origin.x = filtersContainerView.frame.origin.x
         frame.origin.y = CGRectGetMaxY(filtersContainerView.frame)
         frame.size.width = filtersContainerView.frame.size.width
         frame.size.height = 300
         tableView.frame = frame
         
         UIView.animateWithDuration(0.35, animations: { () -> Void in
         
         var frame = self.tableView.frame
         frame.origin.x = self.filtersContainerView.frame.origin.x
         frame.origin.y = CGRectGetMaxY(self.searchTextField.frame) + 5
         self.tableView.frame = frame
         })
         }*/
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    
}


