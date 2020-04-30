//
//  VolunteeredViewController.swift
//  uptous
//
//  Created by Roshan Gita  on 10/2/16.
//  Copyright © 2016 UpToUs. All rights reserved.
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
    @IBOutlet weak var bottomBtn: UIButton!
    var eventDateValue: String!

    var data: Items!
    var sheetData: SignupSheet!
    var sheetDataID: String?

    var itemsDatas = NSArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        headingLbl.text = ("Join the \((data.volunteers![0] as AnyObject).object(forKey: "firstName") as? String ?? "")")
        fromLbl.text = "Driving from: \(data.name!)"
        toLbl.text = "To: \(data.extra!)"
        if data.dateTime == 0 {
            dateTimeLbl.text = ""
            
        }else {
            if Custom.dayStringFromTime4(data.dateTime!) == "1:00AM" {
                dateTimeLbl.text =  "\(Custom.dayStringSignupItems(data.dateTime!))"
                
            }else if data.endTime == "" || data.endTime == "1:00AM" {
                dateTimeLbl.text = "\(Custom.dayStringSignupItems(data.dateTime!))," + "" + " \(Custom.dayStringFromTime4(data.dateTime!))"
            }else {
                dateTimeLbl.text = "\(Custom.dayStringSignupItems(data.dateTime!)), " + "" + " \(Custom.dayStringFromTime4(data.dateTime!)) - " + "" + "\(data.endTime!)"
            }
        }
        //dateTimeLbl.text = ("\(Custom.dayStringFromTime3(data.dateTime!))")
        
        //let imageData = try? Data(contentsOf: Bundle.main.url(forResource: "smiley_test", withExtension: "gif")!)
        //let advTimeGif = UIImage.gifImageWithData(imageData!)
        //gifImageView.image = advTimeGif
        
        //self.itemsDatas = data.volunteers as! NSArray
        
        bottomBtn.isEnabled = true
        if data.volunteerStatus == "Full" {
            bottomBtn.isEnabled = false
            bottomBtn.setTitle("Full", for: .normal)
        }else if data.volunteerStatus == "Volunteered" {
            bottomBtn.isEnabled = true
            bottomBtn.setTitle("Cancel my assignment", for: .normal)
        }
        
        self.tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.estimatedRowHeight = 95
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    //MARK:- Delete
    @IBAction func deleteButtonClick(_ sender: UIButton) {
        let alertView = UIAlertController(title: "UpToUs", message: "Are you sure that you want to delete your assignment?", preferredStyle: .alert)
        alertView.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (alertAction) -> Void in
            
            DispatchQueue.main.async(execute: { 
                self.delete()

            })
        }))
        alertView.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alertView, animated: true, completion: nil)
    }
    
    func delete() {
        let apiName = SignupItems + ("\(sheetDataID!)") + ("/item/\(data.Id!)/Del")
        
        let stringPost = ""
        DataConnectionManager.requestPOSTURL1(api: apiName, stringPost: stringPost, success: {
            (response) -> Void in
            print(response)
            
            if response["status"] as? String == "0" {
                DispatchQueue.main.async(execute: {
                    self.dismiss(animated: true, completion: nil)
                    let _ = self.navigationController?.popViewController(animated: true)
                })
            }else {
                let msg = response["message"] as? String
                self.showAlertWithoutCancel(title: "Error", message: msg)
            }
        })
    }
    
    func showAlertWithoutCancel(title:String?, message:String?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
            //self.navigationController?.popViewController(animated: true)
            print("you have pressed OK button");
        }
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion: nil)
    }

    
    //MARK: - Button Action
    @IBAction func backBtnClick(_ sender: UIButton) {
        //self.dismissViewControllerAnimated(true, completion: nil)
        self.dismiss(animated: true, completion: nil)
        self.navigationController?.popViewController(animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

//MARK:- TableView
extension VolunteeredViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.data.volunteers!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "VolunteeredCell") as! VolunteeredCell
        let data = self.data.volunteers![(indexPath as NSIndexPath).row] as? NSDictionary
        cell.updateData(data!)
        
        return cell
    }
    
}

