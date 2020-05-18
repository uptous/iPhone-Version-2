//
//  MyUpToUsCalendarViewController.swift
//  uptous
//
//  Created by Upendra Narayan on 21/11/16.
//  Copyright © 2016 UpToUs. All rights reserved.
//

import UIKit
import GoogleMaps

class MyUpToUsCalendarViewController: GeneralViewController{

    @IBOutlet weak var lblDateHeader: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var messageView: UIView!

    var newsList = NSArray()
    var eventList = [Event]()
    var filterEventListArr = [Event]()
    var searchActive : Bool = false
    
    @IBOutlet weak var communityTableView: UITableView!
    @IBOutlet weak var communityView: UIView!
    @IBOutlet weak var headingBtn: UIButton!
    var topMenuStatus = 0
    var communityList = NSMutableArray()
    var selectedIndexPath: Int?
    var topMenuSelected = 0


    fileprivate struct landingCellConstants {
        static var cellIdentifier:String = "LandingCell"
        static var rowHeight:CGFloat! = 120
    }
    
    fileprivate struct expandCellConstants {
        static var cellIdentifier:String = "ExpandCell"
        static var rowHeight:CGFloat! = 190
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = 60
        tableView.rowHeight = UITableView.automaticDimension
        
        communityView.isHidden = true
        let landingNib = UINib(nibName: "EventCollapseTableViewCell", bundle: nil)
        tableView.register(landingNib, forCellReuseIdentifier: landingCellConstants.cellIdentifier as String)
        
        let expandNib = UINib(nibName: "CalendarTableViewCell", bundle: nil)
        tableView.register(expandNib, forCellReuseIdentifier: expandCellConstants.cellIdentifier as String)
        messageView.isHidden = true
        self.tableView.isHidden = true
        self.fetchCommunity()
    }

    override func viewWillAppear(_ animated: Bool) {
        searchBar.text = ""
        messageView.isHidden = true
        self.tableView.isHidden = true
        if UserPreferences.SelectedCommunityName == "" {
            headingBtn.setTitle("Calendar - All Communities", for: .normal)
        }else{
            headingBtn.setTitle("Calendar - \(UserPreferences.SelectedCommunityName)", for: .normal)
        }
        self.getEventList()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        ActivityIndicator.hide()
    }
    
    @IBAction func menuButtonClick(_ sender: UIButton) {
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
        controller.modalPresentationStyle = UIModalPresentationStyle.currentContext
        
        let navController = appDelegate.window?.rootViewController as? UINavigationController
        navController?.pushViewController(controller, animated: true)
        
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


    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getEventList() {
        appDelegate.tabbarView?.isHidden = false
        self.communityView.isHidden = true
        self.eventList.removeAll()
        DataConnectionManager.requestGETURL(api: EventAPI, para: ["":""], success: {
            (response) -> Void in
            self.newsList = response as! NSArray
            
            for i in 0 ..< self.newsList.count {
                let result = self.newsList.object(at: i) as? NSDictionary
                let data = Event(info: result)
                self.eventList.append(data)
            }
            if UserPreferences.SelectedCommunityID == 001 {
                
            }else {
                let communityID = UserPreferences.SelectedCommunityID
                self.eventList = self.eventList.filter{ $0.communityId == communityID }
                
            }
            
            if self.eventList.count > 0 {
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
            ActivityIndicator.hide()
            let alert = UIAlertController(title: "Alert", message: "Error", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Try Again", style: UIAlertAction.Style.default, handler: nil))
            //self.present(alert, animated: true, completion: nil)
        }
    }

    func heightForView(_ text:String, font:UIFont, width:CGFloat) -> CGFloat{
        let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = text
        
        label.sizeToFit()
        return label.frame.height
    }
    
    func calculateHeight(_ text:String, width:CGFloat) -> CGFloat {
        let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = UIFont(name: "Helvetica Neue Regular", size: 16)
        label.text = text
        
        label.sizeToFit()
        return label.frame.height
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
        self.filterEventListArr = self.eventList.filter({( event: Event) -> Bool in
            var tmp: String?
            var tmp1: String?
            tmp = event.title!.lowercased()
            tmp1 = event.eventDescription!.lowercased()
            
            print("MyUpToUsCalendarViewController: searchBar: "); print(tmp?.range(of: searchText.lowercased()) ?? "search text failed to print")
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

}
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

extension MyUpToUsCalendarViewController: EventExpandCellDelegate, EventCellDelegate,UITableViewDelegate, UITableViewDataSource {
    
    //MARK:- Open Map for location
    func openMapForLocation(_ rowNumber: NSInteger) {
        let data: Event!
        if(searchActive) {
            data = self.filterEventListArr[rowNumber]
        }else {
            data = self.eventList[rowNumber]
        }
        
        let address = "\(data.address!), " + "\(data.city!), " + "\(data.state!), " + "\(data.country!), " + "\(data.zipCode!)"
        
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(address) { (placemarks, error) in
            if let error = error {
                print("Unable to Forward Geocode Address (\(error))")
                
            }else {
                var location: CLLocation?
                
                if let placemarks = placemarks, placemarks.count > 0 {
                    location = placemarks.first?.location
                }
                
                if let location = location {
                    let coordinate = location.coordinate
                    //let latitiudeText = "\(coordinate.latitude)"
                    //let longitudeText = "\(coordinate.longitude)"
                    
                    let controller = ShowLocationViewController(nibName: "ShowLocationViewController", bundle: nil)
                    controller.calendarEvent = data
                    controller.latitude = coordinate.latitude
                    controller.longitude = coordinate.longitude
                    controller.modalPresentationStyle = UIModalPresentationStyle.currentContext
                    self.present(controller, animated: true, completion: nil)
                    
                } else {
                    //let msg = "No Matching Location Found"
                }
            }
        }
    }
    
    func openMapForLocation1(_ rowNumber: NSInteger) {
        let data: Event!
        if(searchActive) {
            data = self.filterEventListArr[rowNumber]
        }else {
            data = self.eventList[rowNumber]
        }
        
        let address = "\(data.address!), " + "\(data.city!), " + "\(data.state!), " + "\(data.country!), " + "\(data.zipCode!)"
        
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(address) { (placemarks, error) in
            if let error = error {
                print("Unable to Forward Geocode Address (\(error))")
                
            }else {
                var location: CLLocation?
                
                if let placemarks = placemarks, placemarks.count > 0 {
                    location = placemarks.first?.location
                }
                
                if let location = location {
                    let coordinate = location.coordinate
                    
                    let controller = ShowLocationViewController(nibName: "ShowLocationViewController", bundle: nil)
                    controller.calendarEvent = data
                    controller.latitude = coordinate.latitude
                    controller.longitude = coordinate.longitude
                    controller.modalPresentationStyle = UIModalPresentationStyle.currentContext
                    self.present(controller, animated: true, completion: nil)
                    
                } else {
                    // let msg = "No Matching Location Found"
                }
            }
        }
    }
    
    func getLatLngForAddress(address: String) {
        let data: Event!
        if(searchActive) {
            data = self.filterEventListArr[0]
        }else {
            data = self.eventList[0]
        }
        
        let address = "\(data.address!), " + "\(data.city!), " + "\(data.state!), " + "\(data.country!), " + "\(data.zipCode!)"
        
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(address) { (placemarks, error) in
            if let error = error {
                print("Unable to Forward Geocode Address (\(error))")

            }else {
                var location: CLLocation?
                
                if let placemarks = placemarks, placemarks.count > 0 {
                    location = placemarks.first?.location
                }
                
                if let location = location {
                    let coordinate = location.coordinate
                    //let latitiudeText = "\(coordinate.latitude)"
                    //let longitudeText = "\(coordinate.longitude)"
                    
                    let controller = ShowLocationViewController(nibName: "ShowLocationViewController", bundle: nil)
                    controller.calendarEvent = data
                    controller.latitude = coordinate.latitude
                    controller.longitude = coordinate.longitude
                    controller.modalPresentationStyle = UIModalPresentationStyle.currentContext
                    self.present(controller, animated: true, completion: nil)
                    
                } else {
                    //let msg = "No Matching Location Found"
                }
            }
        }
    }


    func expandClick(_ rowNumber: NSInteger) {
        self.selectedIndexPath = rowNumber
        self.tableView.reloadData()
    }
    
    func collapseClick(_ rowNumber: NSInteger) {
        self.selectedIndexPath = -1
        self.tableView.reloadData()
    }
    //MARK:- TableView Delegate
        
        func numberOfSections(in tableView: UITableView) -> Int {
            return 1
        }
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            if tableView == communityTableView {
                return self.communityList.count
                
            }else {
                if(searchActive) {
                    return self.filterEventListArr.count
                } else {
                    return self.eventList.count
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
                return cell
            }else {
                if(selectedIndexPath == indexPath.row) {
                    let cell: CalendarTableViewCell = tableView.dequeueReusableCell(withIdentifier: expandCellConstants.cellIdentifier ) as! CalendarTableViewCell
                    cell.collapseBtn.tag = indexPath.row
                    
                    cell.delegate = self
                    let data: Event!
                    if(searchActive) {
                        data = self.filterEventListArr[(indexPath as NSIndexPath).row]
                    }else {
                        data = self.eventList[(indexPath as NSIndexPath).row]
                    }
                    cell.updateData(data,communityList: self.communityList)
                    return cell
                }else {
                    
                    let cell: EventCollapseTableViewCell = tableView.dequeueReusableCell(withIdentifier: landingCellConstants.cellIdentifier ) as! EventCollapseTableViewCell
                    cell.expandBtn.tag = indexPath.row
                    cell.delegate = self
                    
                    let data: Event!
                    if(searchActive) {
                        data = self.filterEventListArr[(indexPath as NSIndexPath).row]
                    }else {
                        data = self.eventList[(indexPath as NSIndexPath).row]
                    }
                    cell.updateData(data,communityList: self.communityList)
                    return cell
                }
            }
        }
        
        /*func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            if tableView == communityTableView {
                return 50
            }else if selectedIndexPath == indexPath.row {
                return 215
            }else {
                return 125
            }
        }*/
   
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            
            if tableView == communityTableView {
                topMenuSelected = 0
                let data = self.communityList[(indexPath as NSIndexPath).row] as? Community
                if data?.name == "All Communities" {
                    topMenuStatus = 0
                    headingBtn.setTitle("Calendar - All Communities", for: .normal)
                    communityView.isHidden = true
                    UserPreferences.SelectedCommunityID = 001
                    UserPreferences.SelectedCommunityName = ""
                    getEventList()
                }else {
                    headingBtn.setImage(UIImage(named: "top-up-arrow"), for: .normal)
                    UserPreferences.SelectedCommunityName = (data?.name)!
                    headingBtn.setTitle("Calendar - \((data?.name)!)", for: .normal)
                    UserPreferences.SelectedCommunityID = (data?.communityId)!
                    communityView.isHidden = true
                    getEventList()
                }
            }
        }
        
        /*func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            
            if tableView != communityTableView {
                let cells = self.tableView.visibleCells as! Array<CalendarTableViewCell>
                var detailLabelWidt:CGFloat = 0
                var detailLabelOriginY :CGFloat = 0
                
                for cell in cells {
                    // look at data
                    detailLabelWidt = CGFloat(cell.lblDetailDesc.frame.size.width)
                    detailLabelOriginY = CGFloat(cell.lblDetailDesc.frame.origin.y)
                    break
                }
                
                let data:Event = eventList[(indexPath as NSIndexPath).row]
                
                if data.isExpendable == false {
                    return 100
                }else {
                    if calculateHeight(data.eventDescription!, width: detailLabelWidt)+detailLabelOriginY + 20 < 40 {
                        return 40
                    }else {
                        return calculateHeight(data.eventDescription!, width: detailLabelWidt)+detailLabelOriginY + 20
                    }
                    
                }
            }else {
                return 80
            }
        }*/
        
       
    }

