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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        emailTxtField.text! = "asmithutu@gmail.com"
        passwordTxtField.text! = "alpha123"
    }
    
    @IBAction func signInBtnClick(sender: UIButton) {
       
        if emailTxtField.text != "" &&  passwordTxtField.text != "" {
            if !Utility.isEmailAdddressValid(emailTxtField.text!) {
                BaseUIView.toast("Please enter a valid email address")
                return
            }
            let username = emailTxtField.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
            let password = passwordTxtField.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
            
            let credentialData = "\(username):\(password)".dataUsingEncoding(NSUTF8StringEncoding)!
            let base64Credentials = credentialData.base64EncodedStringWithOptions([])
            appDelegate.loginHeaderCredentials = ["Authorization": "Basic \(base64Credentials)"]
            
            ActivityIndicator.show()
            Alamofire.request(.GET, LoginAPI, headers: appDelegate.loginHeaderCredentials)
                .responseJSON { response in
                    ActivityIndicator.hide()
                    if let JSON = response.result.value {
                        let result = JSON as? NSDictionary
                        if (result?.objectForKey("result"))! as! String == "Authenticated" {
                            
                                let controller = self.storyboard?.instantiateViewControllerWithIdentifier(MainStoryBoard.ViewControllerIdentifiers.tabbarViewController) as! TabBarViewController
                                controller.selectedIndex = 0
                                
                                self.navigationController?.pushViewController(controller, animated: true)
                        }else {
                            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                let alert = UIAlertController(title: "Alert", message: "Not Valid User", preferredStyle: UIAlertControllerStyle.Alert)
                                alert.addAction(UIAlertAction(title: "Try Again", style: UIAlertActionStyle.Default, handler: nil))
                                self.presentViewController(alert, animated: true, completion: nil)
                            })
                        }
                        
                    }
            }
            
           
            /*APIs.performLogin(username,password: password) { (response) in
                print("response==> \(response)")
                print("response==> \(response.data)")
                print("response==> \(response)")
                //ActivityIndicator.hide()
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension LoginViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
}


