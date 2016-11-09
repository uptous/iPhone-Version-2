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
        headingLbl.text = ("Join the \((data.volunteers![0] as AnyObject).object(forKey: "firstName") as? String ?? "")")
        fromLbl.text = "Driving from: \(data.name!)"
        toLbl.text = "To: \(data.extra!)"
        dateTimeLbl.text = ("\(Custom.dayStringFromTime1(data.dateTime!))")
        
        let imageData = try? Data(contentsOf: Bundle.main.url(forResource: "smiley_test", withExtension: "gif")!)
        let advTimeGif = UIImage.gifImageWithData(imageData!)
        gifImageView.image = advTimeGif
        
        //self.itemsDatas = data.volunteers as! NSArray
        self.tableView.reloadData()
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
        let apiName = SignupItems + ("\(sheetData.id!)") + ("/item/\(data.Id!)/Del")
        ActivityIndicator.show()
        
        ActivityIndicator.show()
        DataConnectionManager.requestPOSTURL(api: apiName, para: ["":""], success: {
            (response) -> Void in
            print(response)
            ActivityIndicator.hide()
            self.navigationController?.popViewController(animated: true)
            
        }) {
            (error) -> Void in
            ActivityIndicator.hide()
            self.navigationController?.popViewController(animated: true)

        }
       /* Alamofire.request(.POST, apiName, headers: appDelegate.loginHeaderCredentials,parameters: nil)
            .responseJSON { response in
                ActivityIndicator.hide()
                self.navigationController?.popViewController(animated: true)
        }*/
        
    }

    
    //MARK: - Button Action
    @IBAction func backBtnClick(_ sender: UIButton) {
        //self.dismissViewControllerAnimated(true, completion: nil)
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "DriverItemCell") as! DriverItemCell
        let data = self.data.volunteers![(indexPath as NSIndexPath).row] as? NSDictionary
        print(data)
        cell.updateData(data!)
        
        return cell
    }
    
}

