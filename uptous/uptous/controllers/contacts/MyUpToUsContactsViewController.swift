//
//  MyUpToUsContactsViewController.swift
//  uptous
//
//  Created by Roshan Gita  on 9/18/16.
//  Copyright © 2016 SPA. All rights reserved.
//

import UIKit

enum Notes: String {
    
    case note1 = "note1"
    case note2 = "note2"
    
}

enum Type : String {
    case Landing = "Landing"
    case Expand = "Expand"
}

class MyUpToUsContactsViewController: GeneralViewController,LandingCellDelegate,ExpandCellDelegate {
    
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    var selectedIndexPath: Int?
    var selectedIndexPath1 = "Landing"
    var itemsDatas = NSMutableArray()

    
    fileprivate struct landingCellConstants {
        static var cellIdentifier:String = "LandingCell"
        static var rowHeight:CGFloat! = 80
    }
    
    fileprivate struct expandCellConstants {
        static var cellIdentifier:String = "ExpandCell"
        static var rowHeight:CGFloat! = 180
    }


    override func viewDidLoad() {
        super.viewDidLoad()

        let landingNib = UINib(nibName: "LandingCell", bundle: nil)
        tableView.register(landingNib, forCellReuseIdentifier: landingCellConstants.cellIdentifier as String)
        
        let expandNib = UINib(nibName: "ExpandCell", bundle: nil)
        tableView.register(expandNib, forCellReuseIdentifier: expandCellConstants.cellIdentifier as String)
        self.fetchContacts()
    }
    
    //MARK: Fetch Driver Records
    func fetchContacts() {
        
        ActivityIndicator.show()
        DataConnectionManager.requestGETURL(api: Members, para: ["":""], success: {
            (response) -> Void in
            print(response)
            ActivityIndicator.hide()
            
            let item = response as! NSArray
            if item.count > 0 {
                for index in 0..<item.count {
                    let dic = item.object(at: index) as! NSDictionary
                    self.itemsDatas.add(Contacts(info: dic))
                }
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
        return self.itemsDatas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
         if(selectedIndexPath == indexPath.row) {
            let cell: ExpandCell = tableView.dequeueReusableCell(withIdentifier: expandCellConstants.cellIdentifier ) as! ExpandCell
            cell.collapseBtn.tag = indexPath.row
            cell.delegate = self
            
            let data = self.itemsDatas[(indexPath as NSIndexPath).row] as? Contacts
            cell.updateView(data!)
            
            return cell
         }else {
            
            let cell: LandingCell = tableView.dequeueReusableCell(withIdentifier: landingCellConstants.cellIdentifier ) as! LandingCell
            cell.expandBtn.tag = indexPath.row
            cell.delegate = self
            
            let data = self.itemsDatas[(indexPath as NSIndexPath).row] as? Contacts
            cell.updateView(data!)
            
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if(selectedIndexPath == indexPath.row) {
            return 180.0
        }
        return 80.0
    }
    
    func expandClick(_ rowNumber: NSInteger) {
        self.selectedIndexPath = rowNumber
        
        self.tableView.reloadData()
        //selectedIndexPath1 = 1
        //let indexPath = NSIndexPath(row: rowNumber, section: 0)
        //self.tableView.reloadRows(at: [indexPath as IndexPath], with: UITableViewRowAnimation.none)
        
    }
    
    func collapseClick(_ rowNumber: NSInteger) {
        self.selectedIndexPath = nil
        //selectedIndexPath1 = 0
        self.tableView.reloadData()
        //let indexPath = NSIndexPath(row: rowNumber, section: 0)
        //self.tableView.reloadRows(at: [indexPath as IndexPath], with: UITableViewRowAnimation.none)
        
    }
    
}
