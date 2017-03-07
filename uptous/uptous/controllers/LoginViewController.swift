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
        // Do any additional setup after loading the view. // 
        //emailTxtField.text! = "asmithutu@gmail.com"
        //passwordTxtField.text! = "alpha123"
        
        
        //emailTxtField.text! = "testp2@uptous.com"
        //passwordTxtField.text! = "alpha1"  //
        
        emailTxtField.becomeFirstResponder()
        
        if UserPreferences.LoginStatus ==  "Registered" {
            self.alreadyLoggedIn()
        }
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        emailTxtField.text! = ""
        passwordTxtField.text! = ""
        emailTxtField.becomeFirstResponder()
    }
    
    @IBAction func signInBtnClick(_ sender: UIButton) {
       login()
    }
    
    func alreadyLoggedIn() {
        print(UserPreferences.LoginHeaderCodition)
        appDelegate.loginHeaderCredentials = UserPreferences.LoginHeaderCodition
        let controller = self.storyboard?.instantiateViewController(withIdentifier: MainStoryBoard.ViewControllerIdentifiers.tabbarViewController) as! TabBarViewController
        controller.selectedIndex = 0
        
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func login() {
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
            ActivityIndicator.show()
            Alamofire.request(LoginAPI, method: .get, parameters: nil, encoding: URLEncoding(destination: .methodDependent), headers: appDelegate.loginHeaderCredentials).responseJSON { (response:DataResponse<Any>) in
                
                print(response.result)
                print(response)
                
                ActivityIndicator.hide()
                switch(response.result) {
                case .success(_):
                    if response.result.isSuccess {
                        //let result = response.result.value
                        let result = response.result.value as? NSDictionary
                        if (result?.object(forKey: "result"))! as! String == "Authenticated" {
                            
                            self.getTotalContacts()
                            self.checkNewContact()
                            self.checkNewFeed()
                            UserPreferences.LoginHeaderCodition = appDelegate.loginHeaderCredentials
                            UserPreferences.LoginStatus = "Registered"
                            UserPreferences.LoginID = username
                            UserPreferences.Password = password
                            
                            let controller = self.storyboard?.instantiateViewController(withIdentifier: MainStoryBoard.ViewControllerIdentifiers.tabbarViewController) as! TabBarViewController
                            controller.selectedIndex = 0
                            
                            self.navigationController?.pushViewController(controller, animated: true)
                        }else {
                            DispatchQueue.main.async(execute: { () -> Void in
                                let alert = UIAlertController(title: "Alert", message: "Authentication failed. Please try again or reset your password at www.uptous.com", preferredStyle: UIAlertControllerStyle.alert)
                                alert.addAction(UIAlertAction(title: "Try Again", style: UIAlertActionStyle.default, handler: nil))
                                self.present(alert, animated: true, completion: nil)
                            })
                        }
                    }
                    break
                    
                case .failure(_):
                    
                    /*if response.result.isFailure {
                     let error : Error = response.result.error!
                     failure(error)
                     
                     }*/
                    let alert = UIAlertController(title: "Alert", message: "Authentication failed. Please try again or reset your password at www.uptous.com", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Try Again", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    break
                    
                }
            }
            
            /*DataConnectionManager.requestGETURL(api: LoginAPI, para: ["":""], success: {
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
    
    func checkNewContact() {
        DataConnectionManager.requestGETURL1(api: ContactUpdateAPI, para: ["":""], success: {
            (response) -> Void in
            print("First Time==>\(response)")
            
            let data = response as? NSDictionary
            self.defaults.set(data?.object(forKey: "lastContactChange"), forKey: "LastModifiedContact")
            self.defaults.synchronize()
        }) {
            (error) -> Void in
        }
    }
    

    
    
    //MARK: Fetch Records
    func getTotalContacts() {
        DataConnectionManager.requestGETURL1(api: TotalContacts, para: ["":""], success: {
            (response) -> Void in
            print(response)
            let item = response as! NSDictionary
            let totalContacts = Int((item.object(forKey: "total") as? String)!)!
            self.search(textLimit: totalContacts)
        }) {
            (error) -> Void in
        }
    }
    
    //MARK:- SEARCH API HIT
    func search(textLimit: Int){
        
        let api = ("\(Members)") + ("/community/0") + ("/search/0") + ("/limit/\(textLimit)") + ("/offset/0")
        
        DataConnectionManager.requestGETURL1(api: api, para: ["":""], success: {
            (jsonResult) -> Void in
            print(jsonResult)
            
            let listArr = jsonResult as! NSArray
            print("listArr ==>\(listArr.count)")
            UserPreferences.AllContactList = listArr
            
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
        login()
        return true
    }
}


