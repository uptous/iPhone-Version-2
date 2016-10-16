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
    let defaults = NSUserDefaults.standardUserDefaults()
    

    private struct photosCellConstants {
        static var cellIdentifier:String = "PhotosCell"
        static var rowHeight:CGFloat! = 450
    }
    
    private struct fileCellConstants {
        static var cellIdentifier:String = "FileCell"
        static var rowHeight:CGFloat! = 275
    }
    
    private struct announcementCellConstants {
        static var cellIdentifier:String = "AnnouncementCell"
        static var rowHeight:CGFloat! = 310
    }
    
    private struct opportunityCellConstants {
        static var cellIdentifier:String = "OpportunityCell"
        static var rowHeight:CGFloat! = 270
        
    }
    
    private struct  personalThreadsCellConstants {
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
        tableView.registerNib(photosNib, forCellReuseIdentifier: photosCellConstants.cellIdentifier as String)
        
        let fileNib = UINib(nibName: "FileCell", bundle: nil)
        tableView.registerNib(fileNib, forCellReuseIdentifier: fileCellConstants.cellIdentifier as String)
        
        let announcementNib = UINib(nibName: "AnnouncementCell", bundle: nil)
        tableView.registerNib(announcementNib, forCellReuseIdentifier: announcementCellConstants.cellIdentifier as String)
        
        let opportunityNib = UINib(nibName: "OpportunityCell", bundle: nil)
        tableView.registerNib(opportunityNib, forCellReuseIdentifier: opportunityCellConstants.cellIdentifier as String)
        
        let personalThreadNib = UINib(nibName: "PrivateThreadsCell", bundle: nil)
        tableView.registerNib(personalThreadNib, forCellReuseIdentifier: personalThreadsCellConstants.cellIdentifier as String)
        
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(MyUpToUsFeedViewController.refresh(_:)), forControlEvents: UIControlEvents.ValueChanged)
        tableView.addSubview(refreshControl)
        
        //Fetch Feed Items
        let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(1 * Double(NSEC_PER_SEC)))
        dispatch_after(delayTime, dispatch_get_main_queue()) {
            self.getFeedList()
            self.checkNewFeed()
        }
    }
    
    func checkNewFeed() {
        Alamofire.request(.GET, FeedUpdateAPI, headers: appDelegate.loginHeaderCredentials)
            .responseJSON { response in
               if let JSON = response.result.value {
                    let data = JSON as? NSDictionary
                    self.defaults.setObject(data?.objectForKey("lastItemTime"), forKey: "LastModified")
                }
        }
    }
    
    func onTimerTick() {
        Alamofire.request(.GET, FeedUpdateAPI, headers: appDelegate.loginHeaderCredentials)
            .responseJSON { response in
                if let JSON = response.result.value {
                    let data = JSON as? NSDictionary
                    if data?.objectForKey("lastItemTime") as! NSNumber != self.defaults.objectForKey("LastModified") as! NSNumber {
                        self.getFeedList()
                    }
                }
        }
    }
    
    
    //MARK:- Refreshing
    func refresh(sender:AnyObject) {
        // Updating your data here...
        self.tableView.reloadData()
        self.refreshControl?.endRefreshing()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        messageBtn.hidden = true
        pictureBtn.hidden = true
        directBtn.hidden = true
        
        //Schedule For New Feed
        NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(MyUpToUsFeedViewController.onTimerTick), userInfo: nil, repeats: false)
    }
    
    //MARK:- Mail Composer
    func sendEmail(data: Feed) {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients([data.ownerEmail!])
            mail.setMessageBody("<p>You're so awesome!</p>", isHTML: true)
            
            presentViewController(mail, animated: true, completion: nil)
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
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        controller.dismissViewControllerAnimated(true, completion: nil)
    }

    func getFeedList() {
        self.newsTypeList.removeAll()
        ActivityIndicator.show()
        Alamofire.request(.GET, FeedAPI, headers: appDelegate.loginHeaderCredentials)
            .responseJSON { response in
                ActivityIndicator.hide()
                if let JSON = response.result.value {
                    self.newsList = JSON as! NSArray
                    
                    for i in 0 ..< self.newsList.count {
                        let result = self.newsList.objectAtIndex(i) as? NSDictionary
                        let data = Feed(info: result)
                        if data.newsType == "File" || data.newsType == "Private Threads" || data.newsType == "Announcement" || data.newsType == "Photos" || data.newsType == "Opportunity" {
                            self.newsTypeList.append(data)
                        }
                    }
                    if self.newsTypeList.count > 0 {
                        self.tableView.reloadData()
                    }
                }
                print("self.newsTypeList=>\(self.newsTypeList.count)")
                print("self.newsTypeList=>\(self.newsTypeList)")
        }
    }

    //MARK: PhotoCell Delegate
    func photoReplyTo(sender: NSInteger) {
        let data = newsTypeList[sender]
        sendEmail(data)
    }
    
    func photoComment(sender: NSInteger) {
        let data = newsTypeList[sender]
        let controller = self.storyboard?.instantiateViewControllerWithIdentifier("ReadMoreViewController") as! ReadMoreViewController
        controller.data = data
        self.presentViewController(controller, animated: true, completion: nil)
    }
    
    func photoComment1(sender: NSInteger) {
        let data = newsTypeList[sender]
        let controller = self.storyboard?.instantiateViewControllerWithIdentifier("ReadMoreViewController") as! ReadMoreViewController
        controller.data = data
        self.presentViewController(controller, animated: true, completion: nil)
    }
    
    func readMore(sender: NSInteger) {
        let data = newsTypeList[sender]
        print(data)
        
        let controller = self.storyboard?.instantiateViewControllerWithIdentifier("ReadMoreViewController") as! ReadMoreViewController
        controller.data = data
        self.presentViewController(controller, animated: true, completion: nil)
    }
    
    //MARK: AnnouncementCell Delegate
    func announcementReplyTo(sender: NSInteger) {
        let data = newsTypeList[sender]
        sendEmail(data)
    }
    
    func announcementReplyAll(sender: NSInteger) {
        let data = newsTypeList[sender]
        print(data)
        
        let controller = self.storyboard?.instantiateViewControllerWithIdentifier("ReplyAllViewController") as! ReplyAllViewController
        controller.data = data
        self.presentViewController(controller, animated: true, completion: nil)
    }
    
    func announcementPost(sender: NSInteger) {
        let data = newsTypeList[sender]
        print(data)
        
        let controller = self.storyboard?.instantiateViewControllerWithIdentifier("ReplyAllViewController") as! ReplyAllViewController
        controller.data = data
        self.presentViewController(controller, animated: true, completion: nil)
    }
    
    //MARK: Private Thread Delegate
    func privateThreadReplyTo(sender: NSInteger) {
        let data = newsTypeList[sender]
        sendEmail(data)
    }
    
    func privateThreadReplyAll(sender: NSInteger) {
        let data = newsTypeList[sender]
        
        let controller = self.storyboard?.instantiateViewControllerWithIdentifier("ReplyAllViewController") as! ReplyAllViewController
        controller.data = data
        self.presentViewController(controller, animated: true, completion: nil)
    }
    
    func privateThreadComment(sender: NSInteger) {
        let data = newsTypeList[sender]
        
        let controller = self.storyboard?.instantiateViewControllerWithIdentifier("ReplyAllViewController") as! ReplyAllViewController
        controller.data = data
        self.presentViewController(controller, animated: true, completion: nil)
    }
    
    //MARK: Opportunity Delegate
    func opportunityReplyTo(sender: NSInteger) {
        let data = newsTypeList[sender]
        sendEmail(data)

    }
    
    func opportunityComment(sender: NSInteger) {
        let data = newsTypeList[sender]
        let controller = self.storyboard?.instantiateViewControllerWithIdentifier("CommentViewController") as! CommentViewController
        controller.data = data
        self.presentViewController(controller, animated: true, completion: nil)
    }
    
    func opportunityComment1(sender: NSInteger) {
        let data = newsTypeList[sender]
        let controller = self.storyboard?.instantiateViewControllerWithIdentifier("CommentViewController") as! CommentViewController
        controller.data = data
        self.presentViewController(controller, animated: true, completion: nil)
    }
    
    //MARK: File Delegate
    func fileReplyTo(sender: NSInteger) {
        let data = newsTypeList[sender]
        sendEmail(data)
    }
    
    func fileComment(sender: NSInteger) {
        let data = newsTypeList[sender]
        
        let controller = self.storyboard?.instantiateViewControllerWithIdentifier("CommentViewController") as! CommentViewController
        controller.data = data
        self.presentViewController(controller, animated: true, completion: nil)
    }
    
    func commentBtn(sender: NSInteger) {
        let data = newsTypeList[sender]
        
        let controller = self.storyboard?.instantiateViewControllerWithIdentifier("CommentViewController") as! CommentViewController
        controller.data = data
        self.presentViewController(controller, animated: true, completion: nil)
    }
    
    //MARK:- PDF Download
    func downloadPDF(sender: NSInteger) {
        let data = newsTypeList[sender]
        
        let controller = self.storyboard?.instantiateViewControllerWithIdentifier("PDFViewerViewController") as! PDFViewerViewController
        controller.data = data
        self.presentViewController(controller, animated: true, completion: nil)
        
        
        /*ActivityIndicator.show()
        
        var localPath: NSURL?
        Alamofire.download(.GET,
            url!,
            destination: { (temporaryURL, response) in
                let directoryURL = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)[0]
                let pathComponent = response.suggestedFilename
                
                localPath = directoryURL.URLByAppendingPathComponent(pathComponent!)
                return localPath!
        })
            .response { (request, response, _, error) in
                print(response)
                ActivityIndicator.hide()
                let alert = UIAlertController(title: "Alert", message: "File Downloaded", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
                //print("Downloaded file to \(localPath!)")
        }*/
    }
    
    
    
    //MARK:- Post Button
    @IBAction func postButtonClick(sender: UIButton) {
        if isButtonSelected == true {
            postBtn.setImage(UIImage(named: "post-selected"), forState: .Normal)
            isButtonSelected = false
            UIView.animateWithDuration(1.0) {
                
            }
            UIView.animateWithDuration(0.15, animations: {
                self.pictureBtn.center = self.postBtn.center
                self.pictureBtn.center = self.postBtn.center
                self.directBtn.center = self.postBtn.center
                }, completion: { (completed) in
                    self.messageBtn.hidden = true
                    self.pictureBtn.hidden = true
                    self.directBtn.hidden = true
                    
            })
        } else {
            postBtn.setImage(UIImage(named: "post-unselected"), forState: .Normal)
            isButtonSelected = true
            messageBtn.hidden = false
            pictureBtn.hidden = false
            directBtn.hidden = false
            let radius : CGFloat = 200.0
            
            let button2Center = CGPoint(x: postBtn.center.x + radius * sin(-CGFloat(160.degreesToRadians)), y:  postBtn.center.y + radius * cos(-CGFloat(160.degreesToRadians)))
            let button3Center = CGPoint(x: postBtn.center.x + radius * sin(-CGFloat(130.degreesToRadians)), y:  postBtn.center.y + radius * cos(-CGFloat(130.degreesToRadians)))
            let button4Center = CGPoint(x: postBtn.center.x + radius * sin(-CGFloat(100.degreesToRadians)), y:  postBtn.center.y + radius * cos(-CGFloat(100.degreesToRadians)))

            UIView.animateWithDuration(0.35, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.0, options: .CurveEaseOut, animations: {
                self.messageBtn.center = button2Center
                self.pictureBtn.center = button3Center
                self.directBtn.center = button4Center
                }, completion: { (completed) in
                    
            })
        }
    }
    
    @IBAction func messageBtnClick(sender: UIButton) {
    
    }
    
    @IBAction func pictureBtnClick(sender: UIButton) {
        
    }
    
    @IBAction func directBtnClick(sender: UIButton) {
        
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
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if filterStatus == true {
            return self.searchedArray.count
        }else{
            return self.newsTypeList.count
        }
        //return self.newsTypeList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let data: Feed!
        
        if filterStatus == true {
            data = searchedArray[indexPath.row]
        }else{
            data = newsTypeList[indexPath.row]
        }
        switch feedNewsType(rawValue: data.newsType!)! {
           
            case .Photos :
                let cell: PhotosCell = tableView.dequeueReusableCellWithIdentifier(photosCellConstants.cellIdentifier ) as! PhotosCell
                cell.commentBtn.tag = indexPath.row
                cell.comment1Btn.tag = indexPath.row
                cell.replyToBtn.tag = indexPath.row
                cell.readMoreBtn.tag = indexPath.row
                cell.delegate = self
                
                cell.updateData(data)
            
                return cell
            
        case .File :
            let cell: FileCell = tableView.dequeueReusableCellWithIdentifier(fileCellConstants.cellIdentifier ) as! FileCell
            cell.commentBtn.tag = indexPath.row
            cell.comment1Btn.tag = indexPath.row
            cell.replyToBtn.tag = indexPath.row
            cell.pdfDownloadBtn.tag = indexPath.row
            cell.delegate = self

            cell.updateData(data)
            
            return cell
            
        case .Announcement :
            let cell: AnnouncementCell = tableView.dequeueReusableCellWithIdentifier(announcementCellConstants.cellIdentifier ) as! AnnouncementCell
            cell.replyAllBtn.tag = indexPath.row
            cell.postBtn.tag = indexPath.row
            cell.replyToBtn.tag = indexPath.row
            cell.delegate = self

            cell.updateData(data)
            
            return cell
            
        case .Opportunity :
            let cell: OpportunityCell = tableView.dequeueReusableCellWithIdentifier(opportunityCellConstants.cellIdentifier ) as! OpportunityCell
            cell.commentBtn.tag = indexPath.row
            cell.comment1Btn.tag = indexPath.row
            cell.replyToBtn.tag = indexPath.row
            cell.delegate = self

            cell.updateData(data)
            
            return cell
            
        case .PrivateThreads :
            let cell: PrivateThreadsCell = tableView.dequeueReusableCellWithIdentifier(personalThreadsCellConstants.cellIdentifier ) as! PrivateThreadsCell
            cell.replyAllBtn.tag = indexPath.row
            cell.replyToBtn.tag = indexPath.row
            cell.commentBtn.tag = indexPath.row
            cell.delegate = self

            cell.updateData(data)
            
            return cell
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
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
            data = searchedArray[indexPath.row]
        }else{
            data = newsTypeList[indexPath.row]
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
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

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
    func getFilteredFilter(text: String){
        searchedArray.removeAll()
        let namePredicate =
            NSPredicate(format: "SELF.newsType beginswith[c] %@", text)
        
        searchedArray = self.newsTypeList.filter { namePredicate.evaluateWithObject($0) }
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

    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        var subString: NSString = searchTextField.text! as NSString
        subString = subString.stringByReplacingCharactersInRange(range, withString: string)
        print(subString)
        getFilteredFilter(subString as String)
        return true
    }

    func textFieldDidBeginEditing(textField: UITextField) {
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

func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
    return true
}


}


