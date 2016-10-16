//
//  ReadOnlyCommentViewController.swift
//  uptous
//
//  Created by Roshan Gita  on 10/8/16.
//  Copyright © 2016 SPA. All rights reserved.
//

import UIKit
import Alamofire


class ReadOnlyCommentViewController: GeneralViewController {

    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var headingLbl: UILabel!
    @IBOutlet weak var eventDateLbl: UILabel!
    
    var selectedItems: Items!
    var data: SignupSheet!
    var voluniteerdDatas = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Custom.cornerView(contentView)
        //voluniteerdDatas = selectedItems.volunteers!
        //print(voluniteerdDatas)
        nameLbl.text = selectedItems.name!
        headingLbl.text = data.name!
        eventDateLbl.text = ("\(Custom.dayStringFromTime1(selectedItems.dateTime!))")
        
    }
    
    @IBAction func back(sender: UIButton) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    override func viewWillAppear(animated: Bool) {
        voluniteerdDatas.removeAllObjects()
        for index in 0..<selectedItems.volunteers!.count {
            let volunteer = selectedItems.volunteers!.objectAtIndex(index) as? NSDictionary
            voluniteerdDatas.addObject(volunteer!)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

//MARK:- TableView
extension ReadOnlyCommentViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.voluniteerdDatas.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ReadOnlyCommentCell") as! ReadOnlyCommentCell
        let data = self.voluniteerdDatas[indexPath.row] as? NSDictionary
        cell.updateView(data!)
        return cell
    }
    
        
}



