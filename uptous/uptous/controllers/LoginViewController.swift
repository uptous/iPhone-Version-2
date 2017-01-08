//
//  LoginViewController.swift
//  uptous
//
//  Created by Roshan Gita  on 8/10/16.
//  Copyright © 2016 SPA. All rights reserved.
//

import UIKit
import Alamofire

class LoginViewController: GeneralViewController {

    @IBOutlet weak var emailTxtField: UITextField!
    @IBOutlet weak var passwordTxtField: UITextField!
    
    let defaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view. // yuval.spector@uptous.com
        //emailTxtField.text! = "asmithutu@gmail.com"
        //passwordTxtField.text! = "alpha123"
        //emailTxtField.text! = "yuval.spector@uptous.com"
        //passwordTxtField.text! = "postgres"  //
        
        //emailTxtField.text! = "testp1@uptous.com"
        //passwordTxtField.text! = "alpha1"  //testp17@uptous.com
        
        emailTxtField.text! = "testp1@uptous.com"
        passwordTxtField.text! = "alpha1"
        
        
    }
    
    @IBAction func signInBtnClick(_ sender: UIButton) {
       
        if emailTxtField.text != "" &&  passwordTxtField.text != "" {
            if !Utility.isEmailAdddressValid(emailTxtField.text!) {
                BaseUIView.toast("Please enter a valid email address")
                return
            }
            let username = emailTxtField.text!.trimmingCharacters(in: CharacterSet.whitespaces)
            let password = passwordTxtField.text!.trimmingCharacters(in: CharacterSet.whitespaces)
            
            let credentialData = "\(username):\(password)".data(using: String.Encoding.utf8)!
            let base64Credentials = credentialData.base64EncodedString(options: [])
            appDelegate.loginHeader64Credentials = base64Credentials
            appDelegate.loginHeaderCredentials = ["Authorization": "Basic \(base64Credentials)"]
            
            
            DataConnectionManager.requestGETURL(api: LoginAPI, para: ["":""], success: {
                (response) -> Void in
               print(response)
                
                let result = response as? NSDictionary
                if (result?.object(forKey: "result"))! as! String == "Authenticated" {
                    self.checkNewFeed()
                    UserPreferences.LoginID = username
                    UserPreferences.Password = password
                    
                    let controller = self.storyboard?.instantiateViewController(withIdentifier: MainStoryBoard.ViewControllerIdentifiers.tabbarViewController) as! TabBarViewController
                    controller.selectedIndex = 0
                    
                self.navigationController?.pushViewController(controller, animated: true)
                }else {
                    DispatchQueue.main.async(execute: { () -> Void in
                        let alert = UIAlertController(title: "Alert", message: "Not Valid User", preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "Try Again", style: UIAlertActionStyle.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    })
                }
            }) {
                
                (error) -> Void in
                
                let alert = UIAlertController(title: "Alert", message: "Not Valid User", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Try Again", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
            
         /*   let apiName = "https://www.uptous.com/api/comments/feed/1722320"
            let headers = [
                "Content-Type": "application/x-www-form-urlencoded"        ]
            
            
            
            
            Alamofire.request(apiName, method: .post, parameters: ["contents": "RoshAS|1Dn 123456"], encoding: JSONEncoding.default, headers: headers).responseJSON { (response:DataResponse<Any>) in
                
                switch(response.result) {
                case .success(_):
                    if response.result.value != nil{
                        print(response.result.value)
                    }
                    break
                    
                case .failure(_):
                    print(response.result.error)
                    break
                    
                }
            }
                       
            let parameters = ["contents": "123456"]
            
            DataConnectionManager.requestPOSTURL(api: apiName, para: parameters , success: {
                (response) -> Void in
                print(response)
                
                
                
            }) {
                (error) -> Void in
                
                let alert = UIAlertController(title: "Alert", message: "Error", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Try Again", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
            
          
            
            DataConnectionManager.requestGETURL1(api: apiName, para: parameters , success: {
                (response) -> Void in
                print(response)
                
                
                
            }) {
                (error) -> Void in
                
                let alert = UIAlertController(title: "Alert", message: "Error", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Try Again", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }*/

            
           
            /*APIs.performLogin(username,password: password) { (response) in
                print("response==> \(response)")
                print("response==> \(response.data)")
                print("response==> \(response)")
                //
                let result = response.data as? NSDictionary
                
                if (result?.objectForKey("result"))! as! String == "Authenticated" {
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        let credentialData = "\(username):\(password)".dataUsingEncoding(NSUTF8StringEncoding)!
                        let base64Credentials = credentialData.base64EncodedStringWithOptions([])
                        appDelegate.loginHeaderCredentials = ["Authorization": "Basic \(base64Credentials)"]

                        let controller = self.storyboard?.instantiateViewControllerWithIdentifier(MainStoryBoard.ViewControllerIdentifiers.tabbarViewController) as! TabBarViewController
                        controller.selectedIndex = 0
                        
                        self.navigationController?.pushViewController(controller, animated: true)
                    })
                }else {
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        let alert = UIAlertController(title: "Alert", message: "Not Valid User", preferredStyle: UIAlertControllerStyle.Alert)
                        alert.addAction(UIAlertAction(title: "Try Again", style: UIAlertActionStyle.Default, handler: nil))
                        self.presentViewController(alert, animated: true, completion: nil)
                })
              }
            }*/
        }else {
            
            BaseUIView.toast("Please enter email or password")
        }
        return
    }
    
    func checkNewFeed() {
        DataConnectionManager.requestGETURL1(api: FeedUpdateAPI, para: ["":""], success: {
            (response) -> Void in
            print("First Time==>\(response)")
            
            let data = response as? NSDictionary
            self.defaults.set(data?.object(forKey: "lastItemTime"), forKey: "LastModified")
            self.defaults.synchronize()
        }) {
            (error) -> Void in
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension LoginViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
}


