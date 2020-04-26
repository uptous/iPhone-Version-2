//
//  MyUpToUsLibraryViewController.swift
//  uptous
//
//  Created by Roshan Gita  on 11/8/16.
//  Copyright © 2016 SPA. All rights reserved.
//

import UIKit

class MyUpToUsLibraryViewController: GeneralViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,UISearchBarDelegate,ReaderViewControllerDelegate,UIWebViewDelegate,FileListCellDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var backButton : UIButton!
    @IBOutlet weak var menuButton : UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var fileLabel: UILabel!
    @IBOutlet weak var message1View: UIView!
    @IBOutlet weak var message2View: UIView!


    
    @IBOutlet weak var searchBar: UISearchBar!
    var searchActive : Bool = false
    var filterListArr = [Library]()
    var fullListArr = [Library]()
    var filterListArr1 = [Files]()
    var fullListArr1 = [Files]()
    var searchKey: String = ""
    var searchKeyBool: Bool = false
    
    var itemsDatas = NSMutableArray()
    var selectedSegment = "0"
    var screenSize: CGRect!
    var screenWidth: CGFloat!
    var screenHeight: CGFloat!
    var screenComeFrom: String?
    
    @IBOutlet weak var communityTableView: UITableView!
    @IBOutlet weak var communityView: UIView!
    @IBOutlet weak var headingBtn: UIButton!
    var topMenuStatus = 0
    var communityList = NSMutableArray()
    @IBOutlet weak var webView: UIWebView!
    var topMenuSelected = 0


    override func viewDidLoad() {
        super.viewDidLoad()
        communityView.isHidden = true
        tableView.isHidden = true
        if screenComeFrom == "feed" {
            backButton.isHidden = false
            menuButton.isHidden = true
        }else {
            backButton.isHidden = true
            menuButton.isHidden = false
        }
        appDelegate.tabbarView?.isHidden = false
        message1View.isHidden = true
        message2View.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        message1View.isHidden = true
        message2View.isHidden = true
        if UserPreferences.DeepLinkingStatus == "" {
            searchBar.text = ""
            if UserPreferences.SelectedCommunityName == "" {
                headingBtn.setTitle("Library - All Communities", for: .normal)
            }else{
                headingBtn.setTitle("Library - \(UserPreferences.SelectedCommunityName)", for: .normal)
            }
            if selectedSegment == "0" {
                self.fetchLibrary()
            }else {
                self.fetchFiles()
            }
        }else {
            getDeepLinkingData(url: UserPreferences.DeepLinkingStatus)
            
        }
    }
    
    func getDeepLinkingData(url: String) {
        /*let records: Library!
        if(searchActive) {
            records = self.filterListArr[(indexPath as NSIndexPath).row]
        }else {
            records = self.fullListArr[(indexPath as NSIndexPath).row]
        }
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "DetailsLibraryViewController") as! DetailsLibraryViewController
        controller.data = records
        self.present(controller, animated: true, completion: nil)*/
        
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
        
        if selectedSegment == "0" {
            self.filterListArr = self.fullListArr.filter({( library: Library) -> Bool in
                let tmp = library.title!.lowercased()
                let tmp1 = library.caption!.lowercased()
                
                return (tmp.range(of: searchText.lowercased()) != nil) || (tmp1.range(of: searchText.lowercased()) != nil)
                
            })
            if(searchText == ""){
                searchActive = false
            } else {
                searchActive = true
            }
            self.collectionView.reloadData()
        }else {
            self.filterListArr1 = self.fullListArr1.filter({( files: Files) -> Bool in
                let tmp = files.title!.lowercased()
                //tmp1 = sheet.name!.lowercased()
                
               return (tmp.range(of: searchText.lowercased()) != nil)
                
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
    
    @IBAction func back(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func segmentedControlAction(sender: AnyObject) {
        if(segmentedControl.selectedSegmentIndex == 0)
        {
            selectedSegment = "0"
            tableView.isHidden = true
            collectionView.isHidden = false
            fetchLibrary()
        }
        else if(segmentedControl.selectedSegmentIndex == 1)
        {
            selectedSegment = "1"
            tableView.isHidden = false

            fetchFiles()
            collectionView.isHidden = true
        }
    }
    
    @IBAction func menuButtonClick(_ sender: UIButton) {
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
        self.present(controller, animated: true, completion: nil)
    }
    
    //MARK: Fetch Library Records
    func fetchLibrary() {
        self.fullListArr.removeAll()
        appDelegate.tabbarView?.isHidden = false
        collectionView.isHidden = true
        self.communityView.isHidden = true
        self.tableView.isHidden = true
        
        DataConnectionManager.requestGETURL(api: PhotoLibrary, para: ["":""], success: {
            (response) -> Void in
            print(response)
            self.collectionView.isHidden = false

            let item = response as! NSArray
            if item.count > 0 {
                self.fullListArr.removeAll()
                for index in 0..<item.count {
                    let dic = item.object(at: index) as! NSDictionary
                    self.fullListArr.append(Library(info: dic))
                }
            }
            if UserPreferences.SelectedCommunityID == 001 {
            }else {
                let communityID = UserPreferences.SelectedCommunityID
                self.fullListArr = self.fullListArr.filter{ $0.communityId == communityID }
            }
            
            if self.fullListArr.count > 0 {
                self.message1View.isHidden = true
                self.message2View.isHidden = true
                self.collectionView.isHidden = false
                self.collectionView.reloadData()
            }else {
                self.message1View.isHidden = false
                self.message2View.isHidden = true
                self.collectionView.isHidden = true
                /*let alert = UIAlertController(title: "Alert", message: "No Record Found", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)*/
            }
            
        }) {
            (error) -> Void in
            
            let alert = UIAlertController(title: "Alert", message: "No record found.", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Try Again", style: UIAlertAction.Style.default, handler: nil))
            //self.present(alert, animated: true, completion: nil)
        }
    }
    
    //MARK: Fetch Files Records
    func fetchFiles() {
        self.fullListArr1.removeAll()
        collectionView.isHidden = true
        self.communityView.isHidden = true
        appDelegate.tabbarView?.isHidden = false
        DataConnectionManager.requestGETURL(api: FetchAllFiles, para: ["":""], success: {
            (response) -> Void in
            print(response)
            self.collectionView.isHidden = true

            let item = response as! NSArray
            if item.count > 0 {
                self.fullListArr1.removeAll()
                for index in 0..<item.count {
                    let dic = item.object(at: index) as! NSDictionary
                    self.fullListArr1.append(Files(info: dic))
                }
            }
            if UserPreferences.SelectedCommunityID == 001 {
            }else {
                let communityID = UserPreferences.SelectedCommunityID
                self.fullListArr1 = self.fullListArr1.filter{ $0.communityId == communityID }
            }
            
            if self.fullListArr1.count > 0 {
                self.message1View.isHidden = true
                self.message2View.isHidden = true
                self.tableView.isHidden = false
                self.tableView.reloadData()

            }else {
                self.tableView.isHidden = true
                self.message1View.isHidden = true
                self.message2View.isHidden = false
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if(searchActive) {
            return self.filterListArr.count
        } else {
            return self.fullListArr.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CollectionCell
        if selectedSegment == "0" {
            let data: Library!
            if(searchActive) {
                data = self.filterListArr[(indexPath as NSIndexPath).row]
            }else {
                data = self.fullListArr[(indexPath as NSIndexPath).row]
            }
            cell.updateView(data!)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if selectedSegment == "0" {
            let records: Library!
            if(searchActive) {
                records = self.filterListArr[(indexPath as NSIndexPath).row]
            }else {
                records = self.fullListArr[(indexPath as NSIndexPath).row]
            }
            let controller = self.storyboard?.instantiateViewController(withIdentifier: "DetailsLibraryViewController") as! DetailsLibraryViewController
            controller.data = records
            self.present(controller, animated: true, completion: nil)
        }
    }
    
    func downloadAndOpenFile(_ indexPath: NSInteger) {
        let data: Files!
        if(searchActive) {
            data = self.filterListArr1[indexPath]
        }else {
            data = self.fullListArr1[indexPath]
        }
        if data.type == "link" {
            guard let url = URL(string: data.path ?? "") else { return }
            UIApplication.shared.open(url)
        }
        else{
            let docFile = data.path?.components(separatedBy: ".").last
            
            if docFile == "doc" || docFile == "docx" || docFile == "pdf" || docFile == "PDF" || docFile == "JPG" || docFile == "png" || docFile == "xls" || docFile == "xlsx" || docFile == "MOV" || docFile == "MP3" || docFile == "mp3"  || docFile == "jpg"  || docFile == "PNG" || docFile == "mov" {
                let controller = self.storyboard?.instantiateViewController(withIdentifier: "FileListViewController") as! FileListViewController
                controller.filePath = data.path
                self.present(controller, animated: true, completion: nil)
                
            }else {
                DispatchQueue.main.async(execute: { () -> Void in
                    let alert = UIAlertController(title: "Alert", message: "Files in this format cannot be downloaded to the iPhone", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                })
            }
        }
    }
    
    func dismiss(_ viewController: ReaderViewController!) {
        self.navigationController!.popViewController(animated: true)
    }
}

extension MyUpToUsLibraryViewController: UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == communityTableView {
            return self.communityList.count
        }else {
            if(searchActive) {
                return self.filterListArr1.count
            } else {
                return self.fullListArr1.count
            }
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
            let cell = tableView.dequeueReusableCell(withIdentifier: "FileListCell") as! FileListCell
            cell.fileButton.tag = indexPath.row
            cell.delegate = self
            let data: Files!
            if(searchActive) {
                data = self.filterListArr1[(indexPath as NSIndexPath).row]
            }else {
                data = self.fullListArr1[(indexPath as NSIndexPath).row]
            }
            cell.updateView(data: data!)
            
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == communityTableView {
            topMenuSelected = 0
            let data = self.communityList[(indexPath as NSIndexPath).row] as? Community
            if data?.name == "All Communities" {
                topMenuStatus = 0
                headingBtn.setTitle("Library - All Communities", for: .normal)
                communityView.isHidden = true
                UserPreferences.SelectedCommunityID = 001
                UserPreferences.SelectedCommunityName = ""
                if selectedSegment == "0" {
                    fetchLibrary()
                }else {
                    fetchFiles()
                }
            }else {
                headingBtn.setImage(UIImage(named: "top-up-arrow"), for: .normal)
                UserPreferences.SelectedCommunityName = (data?.name)!
                headingBtn.setTitle("Library - \((data?.name)!)", for: .normal)
                UserPreferences.SelectedCommunityID = (data?.communityId)!
                communityView.isHidden = true
                if selectedSegment == "0" {
                    fetchLibrary()
                }else {
                    fetchFiles()
                }
            }
        }else {
            
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == communityTableView {
            return 50
        }else {
            return 90
        }
    }
}

