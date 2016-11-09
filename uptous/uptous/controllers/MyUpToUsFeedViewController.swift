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

class MyUpToUsFeedViewController: GeneralViewController,PhotosCellDelegate,AnnouncementCellDelegate,PrivateThreadsCellDelegate,OpportunityCellDelegate,FileCellDelegate,MFMailComposeViewControllerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var postBtn: UIButton!
    @IBOutlet weak var directBtn: UIButton!
    @IBOutlet weak var pictureBtn: UIButton!
    @IBOutlet weak var messageBtn: UIButton!
    @IBOutlet weak var searchTextField: UITextField!
    var isButtonSelected = false
    var filterStatus = false

    var newsTypeList = [Feed]()
    var newsList = NSArray()
    var searchedArray = [Feed]()
    var refreshControl: UIRefreshControl!
    let defaults = UserDefaults.standard
    

    fileprivate struct photosCellConstants {
        static var cellIdentifier:String = "PhotosCell"
        static var rowHeight:CGFloat! = 450
    }
    
    fileprivate struct fileCellConstants {
        static var cellIdentifier:String = "FileCell"
        static var rowHeight:CGFloat! = 275
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
    
//    private struct  personalAnnouncementCellConstants {
//        static var cellIdentifier:String = "PersonalAnnouncementCell"
//        static var rowHeight:CGFloat! = 310
//    }


    override func viewDidLoad() {
        super.viewDidLoad()

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
        
        //Fetch Feed Items
        let delayTime = DispatchTime.now() + Double(Int64(1 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: delayTime) {
           
            self.getFeedList()
            self.checkNewFeed()
        }
    }
    
    func checkNewFeed() {
        DataConnectionManager.requestGETURL(api: FeedUpdateAPI, para: ["":""], success: {
            (response) -> Void in
            print(response)
            ActivityIndicator.hide()
            let data = response as? NSDictionary
            self.defaults.set(data?.object(forKey: "lastItemTime"), forKey: "LastModified")
            
        }) {
            (error) -> Void in
            ActivityIndicator.hide()
        }
     }
    
    func onTimerTick() {
        DataConnectionManager.requestGETURL(api: FeedUpdateAPI, para: ["":""], success: {
            (response) -> Void in
            print(response)
            ActivityIndicator.hide()
            let data = response as? NSDictionary
            if data?.object(forKey: "lastItemTime") as? NSNumber != self.defaults.object(forKey: "LastModified") as? NSNumber {
                self.getFeedList1()
            }

        }) {
            (error) -> Void in
            ActivityIndicator.hide()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        messageBtn.isHidden = true
        pictureBtn.isHidden = true
        directBtn.isHidden = true
        
        //Schedule For New Feed
        Timer.scheduledTimer(timeInterval: 0, target: self, selector: #selector(MyUpToUsFeedViewController.onTimerTick), userInfo: nil, repeats: false)
    }
    
    //MARK:- Mail Composer
    func sendEmail(_ data: Feed) {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients([data.ownerEmail!])
            mail.setMessageBody("<p>You're so awesome!</p>", isHTML: true)
            
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
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func getFeedList1() {
        DataConnectionManager.requestGETURL(api: FeedAPI, para: ["":""], success: {
            (response) -> Void in
            print(response)
            ActivityIndicator.hide()
             self.newsTypeList.removeAll()
            self.newsList = response as! NSArray
            
            for i in 0 ..< self.newsList.count {
                let result = self.newsList.object(at: i) as? NSDictionary
                let data = Feed(info: result)
                if data.newsType == "File" || data.newsType == "Private Threads" || data.newsType == "Announcement" || data.newsType == "Photos" || data.newsType == "Opportunity" {
                    self.newsTypeList.append(data)
                }
            }
            if self.newsTypeList.count > 0 {
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


    func getFeedList() {
        ActivityIndicator.show()
        DataConnectionManager.requestGETURL(api: FeedAPI, para: ["":""], success: {
            (response) -> Void in
            print(response)
            ActivityIndicator.hide()
             self.newsTypeList.removeAll()
            self.newsList = response as! NSArray
            
            for i in 0 ..< self.newsList.count {
                let result = self.newsList.object(at: i) as? NSDictionary
                let data = Feed(info: result)
                if data.newsType == "File" || data.newsType == "Private Threads" || data.newsType == "Announcement" || data.newsType == "Photos" || data.newsType == "Opportunity" {
                    self.newsTypeList.append(data)
                }
            }
            if self.newsTypeList.count > 0 {
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

    //MARK: PhotoCell Delegate
    func photoReplyTo(_ sender: NSInteger) {
        let data = newsTypeList[sender]
        sendEmail(data)
    }
    
    func photoComment(_ sender: NSInteger) {
        let data = newsTypeList[sender]
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "ReadMoreViewController") as! ReadMoreViewController
        controller.data = data
        self.present(controller, animated: true, completion: nil)
    }
    
    func photoComment1(_ sender: NSInteger) {
        let data = newsTypeList[sender]
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "ReadMoreViewController") as! ReadMoreViewController
        controller.data = data
        self.present(controller, animated: true, completion: nil)
    }
    
    func readMore(_ sender: NSInteger) {
        let data = newsTypeList[sender]
        print(data)
        
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "ReadMoreViewController") as! ReadMoreViewController
        controller.data = data
        self.present(controller, animated: true, completion: nil)
    }
    
    //MARK: AnnouncementCell Delegate
    func announcementReplyTo(_ sender: NSInteger) {
        let data = newsTypeList[sender]
        sendEmail(data)
    }
    
    func announcementReplyAll(_ sender: NSInteger) {
        let data = newsTypeList[sender]
        print(data)
        
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "ReplyAllViewController") as! ReplyAllViewController
        controller.data = data
        self.present(controller, animated: true, completion: nil)
    }
    
    func announcementPost(_ sender: NSInteger) {
        let data = newsTypeList[sender]
        print(data)
        
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "ReplyAllViewController") as! ReplyAllViewController
        controller.data = data
        self.present(controller, animated: true, completion: nil)
    }
    
    //MARK: Private Thread Delegate
    func privateThreadReplyTo(_ sender: NSInteger) {
        let data = newsTypeList[sender]
        sendEmail(data)
    }
    
    func privateThreadReplyAll(_ sender: NSInteger) {
        let data = newsTypeList[sender]
        
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "ReplyAllViewController") as! ReplyAllViewController
        controller.data = data
        self.present(controller, animated: true, completion: nil)
    }
    
    func privateThreadComment(_ sender: NSInteger) {
        let data = newsTypeList[sender]
        
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "ReplyAllViewController") as! ReplyAllViewController
        controller.data = data
        self.present(controller, animated: true, completion: nil)
    }
    
    //MARK: Opportunity Delegate
    func opportunityReplyTo(_ sender: NSInteger) {
        let data = newsTypeList[sender]
        sendEmail(data)
    }
    
    func opportunityComment(_ sender: NSInteger) {
        let data = newsTypeList[sender]
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "CommentViewController") as! CommentViewController
        controller.data = data
        self.present(controller, animated: true, completion: nil)
    }
    
    func opportunityComment1(_ sender: NSInteger) {
        let data = newsTypeList[sender]
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "CommentViewController") as! CommentViewController
        controller.data = data
        self.present(controller, animated: true, completion: nil)
    }
    
    func openSignUpPage(_ sender: NSInteger) {
        
        let event = newsTypeList[sender]
        
        let apiName = SignupItems + ("\(event.newsItemId!)")
        DataConnectionManager.requestGETURL(api: apiName, para: ["":""], success: {
            (response) -> Void in
            print(response)
            ActivityIndicator.hide()
            let driverDatas = (response as? NSArray)!
            let dic = driverDatas.object(at: 0) as? NSDictionary
            let type = dic?.object(forKey: "type") as! String
            self.signupType(newsType: type, event: event)
            
        }) {
            (error) -> Void in
            ActivityIndicator.hide()
//            let alert = UIAlertController(title: "Alert", message: "Error", preferredStyle: UIAlertControllerStyle.alert)
//            alert.addAction(UIAlertAction(title: "Try Again", style: UIAlertActionStyle.default, handler: nil))
//            self.present(alert, animated: true, completion: nil)
        }
        
    }
    
    func signupType(newsType: String,event: Feed) {
        if (newsType == "Drivers") {
            let controller = self.storyboard?.instantiateViewController(withIdentifier: "SignUpDriverViewController") as! SignUpDriverViewController
            controller.data1 = event
            self.navigationController?.pushViewController(controller, animated: true)
            
        }else if (newsType == "RSVP" || event.newsType! == "Vote") {
            let controller = self.storyboard?.instantiateViewController(withIdentifier: "SignUpRSVPViewController") as! SignUpRSVPViewController
            controller.data1 = event
            self.navigationController?.pushViewController(controller, animated: true)
            
        }else if (newsType == "Ongoing") {
            let controller = self.storyboard?.instantiateViewController(withIdentifier: "OnGoingSignUpsViewController") as! OnGoingSignUpsViewController
            controller.data1 = event
            self.navigationController?.pushViewController(controller, animated: true)
            
        }else if (newsType == "Shifts" || event.newsType! == "Snack" || event.newsType! == "Games") {
            let controller = self.storyboard?.instantiateViewController(withIdentifier: "ShiftsSigUpsViewController") as! ShiftsSigUpsViewController
            controller.data1 = event
            self.navigationController?.pushViewController(controller, animated: true)
            
        }else if (newsType == "Volunteer" || event.newsType! == "Potluck" || event.newsType! == "Wish List") {
            let controller = self.storyboard?.instantiateViewController(withIdentifier: "SignUpOpenViewController") as! SignUpOpenViewController
            controller.data1 = event
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    
    //MARK: File Delegate
    func fileReplyTo(_ sender: NSInteger) {
        let data = newsTypeList[sender]
        sendEmail(data)
    }
    
    func fileComment(_ sender: NSInteger) {
        let data = newsTypeList[sender]
        
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "CommentViewController") as! CommentViewController
        controller.data = data
        self.present(controller, animated: true, completion: nil)
    }
    
    func commentBtn(_ sender: NSInteger) {
        let data = newsTypeList[sender]
        
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "CommentViewController") as! CommentViewController
        controller.data = data
        self.present(controller, animated: true, completion: nil)
    }
    
    //MARK:- PDF Download
    func downloadPDF(_ sender: NSInteger) {
        let data = newsTypeList[sender]
        
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "PDFViewerViewController") as! PDFViewerViewController
        controller.data = data
        self.present(controller, animated: true, completion: nil)
        
        
    }
    
    
    
    //MARK:- Post Button
    @IBAction func postButtonClick(_ sender: UIButton) {
        if isButtonSelected == true {
            postBtn.setImage(UIImage(named: "post-selected"), for: UIControlState())
            isButtonSelected = false
            UIView.animate(withDuration: 1.0, animations: {
                
            }) 
            UIView.animate(withDuration: 0.15, animations: {
                self.pictureBtn.center = self.postBtn.center
                self.pictureBtn.center = self.postBtn.center
                self.directBtn.center = self.postBtn.center
                }, completion: { (completed) in
                    self.messageBtn.isHidden = true
                    self.pictureBtn.isHidden = true
                    self.directBtn.isHidden = true
                    
            })
        } else {
            postBtn.setImage(UIImage(named: "post-unselected"), for: UIControlState())
            isButtonSelected = true
            messageBtn.isHidden = false
            pictureBtn.isHidden = false
            directBtn.isHidden = false
            let radius : CGFloat = 200.0
            
            let button2Center = CGPoint(x: postBtn.center.x + radius * sin(-CGFloat(160.degreesToRadians)), y:  postBtn.center.y + radius * cos(-CGFloat(160.degreesToRadians)))
            let button3Center = CGPoint(x: postBtn.center.x + radius * sin(-CGFloat(130.degreesToRadians)), y:  postBtn.center.y + radius * cos(-CGFloat(130.degreesToRadians)))
            let button4Center = CGPoint(x: postBtn.center.x + radius * sin(-CGFloat(100.degreesToRadians)), y:  postBtn.center.y + radius * cos(-CGFloat(100.degreesToRadians)))

            UIView.animate(withDuration: 0.35, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.0, options: .curveEaseOut, animations: {
                self.messageBtn.center = button2Center
                self.pictureBtn.center = button3Center
                self.directBtn.center = button4Center
                }, completion: { (completed) in
                    
            })
        }
    }
    
    @IBAction func messageBtnClick(_ sender: UIButton) {
    
    }
    
    @IBAction func pictureBtnClick(_ sender: UIButton) {
        
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
    var degreesToRadians: Double { return Double(self) * M_PI / 180 }
    var radiansToDegrees: Double { return Double(self) * 180 / M_PI }
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
        return Self(double * M_PI / 180)
    }
    var radiansToDegrees: DoubleConvertible {
        return Self(double * 180 / M_PI)
    }
}
//MARK:- TableView Delegate
extension MyUpToUsFeedViewController: UITableViewDataSource,UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if filterStatus == true {
            return self.searchedArray.count
        }else{
            return self.newsTypeList.count
        }
        //return self.newsTypeList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let data: Feed!
        
        if filterStatus == true {
            data = searchedArray[(indexPath as NSIndexPath).row]
        }else{
            data = newsTypeList[(indexPath as NSIndexPath).row]
        }
        switch feedNewsType(rawValue: data.newsType!)! {
           
            case .Photos :
                let cell: PhotosCell = tableView.dequeueReusableCell(withIdentifier: photosCellConstants.cellIdentifier ) as! PhotosCell
                cell.commentBtn.tag = (indexPath as NSIndexPath).row
                cell.comment1Btn.tag = (indexPath as NSIndexPath).row
                cell.replyToBtn.tag = (indexPath as NSIndexPath).row
                cell.readMoreBtn.tag = (indexPath as NSIndexPath).row
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let data: Feed!
        /*if filterStatus == true {
            data = searchedArray[indexPath.row]
        }else{
            data = newsTypeList[indexPath.row]
        }
        if data.newsType! == "Photos" {
            return 450
        }else if data.newsType! == "File" {
            return 275
        }else if data.newsType! == "Announcement" {
            return 310
        }else if data.newsType! == "Opportunity" {
            return 270
        }else if data.newsType! == "PrivateThreads" {
            return 310
        }else{
            return 0
        }*/
        
        if filterStatus == true {
            data = searchedArray[(indexPath as NSIndexPath).row]
        }else{
            data = newsTypeList[(indexPath as NSIndexPath).row]
        }
        switch feedNewsType(rawValue: data.newsType!)! {
            
        case .Photos :
            return 450
            
        case .File :
            return 275
            
        case .Announcement :
            return 310
            
        case .Opportunity :
            return 270
            
        case .PrivateThreads :
            return 310
            
        }

        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        /*let data = newsTypeList[indexPath.row]
        switch feedNewsType(rawValue: data.newsType!)! {
            
        case .Photos :
            let controller = self.storyboard?.instantiateViewControllerWithIdentifier("ReadMoreViewController") as! ReadMoreViewController
            controller.data = data
            self.presentViewController(controller, animated: true, completion: nil)
            
        case .File :
            let cell: FileCell = tableView.dequeueReusableCellWithIdentifier(fileCellConstants.cellIdentifier ) as! FileCell
            cell.updateData(data)
            return
            
        case .Announcement :
            let cell: AnnouncementCell = tableView.dequeueReusableCellWithIdentifier(announcementCellConstants.cellIdentifier ) as! AnnouncementCell
            cell.delegate = self
            cell.updateData(data)
            return
            
        case .Opportunity :
            let cell: OpportunityCell = tableView.dequeueReusableCellWithIdentifier(opportunityCellConstants.cellIdentifier ) as! OpportunityCell
            cell.updateData(data)
            return
            
        case .PrivateThreads :
            let cell: PrivateThreadsCell = tableView.dequeueReusableCellWithIdentifier(personalThreadsCellConstants.cellIdentifier ) as! PrivateThreadsCell
            cell.updateData(data)
            return
        }*/
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
        
        
        /*let destinations = self.newsTypeList.filter { (destinations ) -> Bool in
            let predicate = NSPredicate(format: "SELF.name beginswith[c] %@", text)
            let feed = (destinations as? [Feed])
            
            let feed = self.newsTypeList.filteredArrayUsingPredicate(predicate) //as! [Feed]
            for city in cities{
                searchedArray.append(city)
            }
            return cities.count != 0
        }*/
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


