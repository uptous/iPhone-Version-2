//
//  VolunteeredViewController.swift
//  uptous
//
//  Created by Roshan Gita  on 10/2/16.
//  Copyright © 2016 SPA. All rights reserved.
//

import UIKit
import Alamofire


class VolunteeredViewController: GeneralViewController {
    @IBOutlet weak var headingLbl: UILabel!
    @IBOutlet weak var fromLbl: UILabel!
    @IBOutlet weak var toLbl: UILabel!
    @IBOutlet weak var dateTimeLbl: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var gifImageView: UIImageView!

    var data: Items!
    var sheetData: SignupSheet!
    var itemsDatas = NSArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        headingLbl.text = ("Join the \(data.volunteers![0].objectForKey("firstName") as? String ?? "")")
        fromLbl.text = "Driving from: \(data.name!)"
        toLbl.text = "To: \(data.extra!)"
        dateTimeLbl.text = ("\(Custom.dayStringFromTime1(data.dateTime!))")
        
        let imageData = NSData(contentsOfURL: NSBundle.mainBundle().URLForResource("smiley_test", withExtension: "gif")!)
        let advTimeGif = UIImage.gifImageWithData(imageData!)
        gifImageView.image = advTimeGif
        
        //self.itemsDatas = data.volunteers as! NSArray
        self.tableView.reloadData()
    }
    
    //MARK:- Delete
    @IBAction func deleteButtonClick(sender: UIButton) {
        let alertView = UIAlertController(title: "UpToUs", message: "are you sure you want to delete this record?", preferredStyle: .Alert)
        alertView.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (alertAction) -> Void in
            
            dispatch_async(dispatch_get_main_queue(), { 
                self.delete()

            })
        }))
        alertView.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        presentViewController(alertView, animated: true, completion: nil)
    }
    
    func delete() {
        let apiName = SignupItems + ("\(sheetData.id!)") + ("/item/\(data.Id!)/Del")
        ActivityIndicator.show()
        
        Alamofire.request(.POST, apiName, headers: appDelegate.loginHeaderCredentials,parameters: nil)
            .responseJSON { response in
                ActivityIndicator.hide()
                self.navigationController?.popViewControllerAnimated(true)
        }
        
    }

    
    //MARK: - Button Action
    @IBAction func backBtnClick(sender: UIButton) {
        //self.dismissViewControllerAnimated(true, completion: nil)
        self.navigationController?.popViewControllerAnimated(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

//MARK:- TableView
extension VolunteeredViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.data.volunteers!.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("DriverItemCell") as! DriverItemCell
        let data = self.data.volunteers![indexPath.row] as? NSDictionary
        print(data)
        cell.updateData(data!)
        
        return cell
    }
    
}

