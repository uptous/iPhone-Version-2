//
//  LoginViewController.swift
//  uptous
//
//  Created by Roshan Gita  on 8/10/16.
//  Copyright © 2016 UpToUs. All rights reserved.
//

import UIKit
import Alamofire
import SafariServices

class LoginViewController: GeneralViewController,SFSafariViewControllerDelegate {

    @IBOutlet weak var emailTxtField: UITextField!
    @IBOutlet weak var passwordTxtField: UITextField!
    @IBOutlet weak var signInBtn: UIButton!
    
    let defaults = UserDefaults.standard
    
    var pageNo:Int=0
    var limit:Int=150
    var offset:Int=0

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view. // yuval.spector@uptous.com
        //emailTxtField.text! = "asmithutu@gmail.com"
        //passwordTxtField.text! = "alpha123"
        //emailTxtField.text! = "yuval.spector@uptous.com"
        //passwordTxtField.text! = "aaabbb"  //
        //emailTxtField.text! = "testp2@uptous.com"
        //passwordTxtField.text! = "alpha1"  //
        //emailTxtField.text! = "kalanit@stanford.edu"
        //passwordTxtField.text! = "140796"

        //emailTxtField.text! = "testp1@uptous.com"
        //passwordTxtField.text! = "alpha1"  //
        
        //emailTxtField.becomeFirstResponder()
        let paddingView = UIView(frame: CGRect.init(x: 0, y: 0, width: 10, height:self.emailTxtField.frame.height ))
        emailTxtField.leftView = paddingView
        emailTxtField.leftViewMode = UITextField.ViewMode.always
        
        let paddingView1 = UIView(frame: CGRect.init(x: 0, y: 0, width: 10, height:self.passwordTxtField.frame.height ))
        passwordTxtField.leftView = paddingView1
        passwordTxtField.leftViewMode = UITextField.ViewMode.always
        
        if UserPreferences.LoginStatus ==  "Registered" {
            self.alreadyLoggedIn()
        }
        signInBtn.layer.cornerRadius = 3
        
        //let myColor : UIColor = UIColor( red: 0.5, green: 0.5, blue:0, alpha: 1.0 )
        emailTxtField.layer.masksToBounds = true
        emailTxtField.layer.borderColor = UIColor.lightGray.cgColor //myColor.cgColor
        emailTxtField.layer.borderWidth = 1.0
        emailTxtField.layer.cornerRadius = 3.0
        
        passwordTxtField.layer.masksToBounds = true
        passwordTxtField.layer.borderColor = UIColor.lightGray.cgColor//myColor.cgColor
        passwordTxtField.layer.borderWidth = 1.0
        passwordTxtField.layer.cornerRadius = 3.0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //emailTxtField.text! = ""
        //passwordTxtField.text! = ""
        //UserPreferences.AllContactList.a
    }
    
    @IBAction func forgetPasswordBtnClick(_ sender: UIButton) {
        let url = URL(string: "https://www.uptous.com/mobileForgotPassword")
        let svc = SFSafariViewController(url: url!, entersReaderIfAvailable: true)
        //svc.delegate = self as? SFSafariViewControllerDelegate
        self.present(svc, animated: true, completion: nil)
    }
    
    @IBAction func signUpBtnClick(_ sender: UIButton) {
        let url = URL(string: "https://www.uptous.com/mobileSignup")
        let svc = SFSafariViewController(url: url!, entersReaderIfAvailable: true)
        //svc.delegate = self as? SFSafariViewControllerDelegate
        self.present(svc, animated: true, completion: nil)
    }
    
    //MARK:-SFSafariViewController Delegate
    func safariViewControllerDidFinish(_ controller: SFSafariViewController)
    {
        controller.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func signInBtnClick(_ sender: UIButton) {
       login()
    }
    
    //MARK: Fetch Driver Records
    func fetchSignUpItems(ID: String) {
        let apiName = SignupItems + ("\(ID)")
        
        DataConnectionManager.requestGETURL(api: apiName, para: ["":""], success: {
            (response) -> Void in
            let signUpDatas = (response as? NSArray)!
            let dic = signUpDatas.object(at: 0) as? NSDictionary
            let dataSheet = SignupSheet(info: dic)
            
            //appDelegate.globalSignUpData = data
            
            if dataSheet.contact == "" && dataSheet.contact2 == "" {
                let controller = self.storyboard?.instantiateViewController(withIdentifier: "SignUpType1ViewController") as! SignUpType1ViewController
                controller.data = dataSheet
                //controller.data1 = data1
                if (dataSheet.type! == "Drivers") {
                    controller.signUpType = "103"
                    
                }else if (dataSheet.type! == "RSVP" || dataSheet.type! == "Vote") {
                    controller.signUpType = "102"
                    
                }else if (dataSheet.type! == "Shifts" || dataSheet.type! == "Snack" || dataSheet.type! == "Games" || dataSheet.type! == "Multi Game/Event RSVP" || dataSheet.type! == "Snack Schedule") {
                    controller.signUpType = "100"
                    
                }else if (dataSheet.type! == "Volunteer" || dataSheet.type! == "Potluck" || dataSheet.type! == "Wish List" || dataSheet.type! == "Potluck/Party" || dataSheet.type! == "Ongoing Volunteering") {
                    controller.signUpType = "101"
                }
                
                self.present(controller, animated: true, completion: nil)
            }else {
                let controller = self.storyboard?.instantiateViewController(withIdentifier: "SignUpType3ViewController") as! SignUpType3ViewController
                controller.data = dataSheet
                if (dataSheet.type! == "Drivers") {
                    controller.signUpType = "103"
                    
                }else if (dataSheet.type! == "RSVP" || dataSheet.type! == "Vote") {
                    controller.signUpType = "102"
                    
                }else if (dataSheet.type! == "Shifts" || dataSheet.type! == "Snack" || dataSheet.type! == "Games" || dataSheet.type! == "Multi Game/Event RSVP" || dataSheet.type! == "Snack Schedule") {
                    controller.signUpType = "100"
                    
                }else if (dataSheet.type! == "Volunteer" || dataSheet.type! == "Potluck" || dataSheet.type! == "Wish List" || dataSheet.type! == "Potluck/Party" || dataSheet.type! == "Ongoing Volunteering") {
                    controller.signUpType = "101"
                }
                self.present(controller, animated: true, completion: nil)
            }
            
        }) {
            (error) -> Void in
            
            let alert = UIAlertController(title: "Alert", message: "Error", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Try Again", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func alreadyLoggedIn() {
        
        appDelegate.loginHeaderCredentials.add(name:"Authorization", value:UserPreferences.LoginHeaderCodition.values.first!)

        let controller = self.storyboard?.instantiateViewController(withIdentifier: MainStoryBoard.ViewControllerIdentifiers.tabbarViewController) as! TabBarViewController
        
        if UserPreferences.DeepLinkingStatus == "" {
            controller.selectedIndex = 0
            self.navigationController?.pushViewController(controller, animated: false)
        }else {
            let array = "\(UserPreferences.DeepLinkingStatus)".components(separatedBy: "/")
            if array[3] == "communitySignup" {
                controller.selectedIndex = 2
                
                appDelegate.tabbarView?.deselectButton()
                appDelegate.tabbarView?.signupBtn.isSelected = true
                appDelegate.tabbarView?.newsFeedBtn1.isHidden = true
                appDelegate.tabbarView?.contactsBtn1.isHidden = true
                appDelegate.tabbarView?.signupBtn1.isHidden = false
                appDelegate.tabbarView?.libraryBtn1.isHidden = true
                appDelegate.tabbarView?.calendarBtn1.isHidden = true
                
                self.fetchSignUpItems(ID: array[5])
                self.navigationController?.pushViewController(controller, animated: false)
                UserPreferences.DeepLinkingStatus = ""
                
            }else if array[3] == "communityAlbum" {
                controller.selectedIndex = 3
                appDelegate.tabbarView?.deselectButton()
                appDelegate.tabbarView?.libraryBtn.isSelected = true
                
                appDelegate.tabbarView?.newsFeedBtn1.isHidden = true
                appDelegate.tabbarView?.contactsBtn1.isHidden = true
                appDelegate.tabbarView?.signupBtn1.isHidden = true
                appDelegate.tabbarView?.libraryBtn1.isHidden = false
                appDelegate.tabbarView?.calendarBtn1.isHidden = true
                
                let pushVC = self.storyboard?.instantiateViewController(withIdentifier: "DetailsLibraryViewController") as! DetailsLibraryViewController
                pushVC.albumID = array[5]
                self.present(pushVC, animated: false, completion: nil)
                self.navigationController?.pushViewController(controller, animated: false)
                UserPreferences.DeepLinkingStatus = ""
                
            }else if array[3] == "communityInvite" {
                controller.selectedIndex = 0
                let pushVC = self.storyboard?.instantiateViewController(withIdentifier: "InviteViewController") as! InviteViewController
                self.present(pushVC, animated: false, completion: nil)
                self.navigationController?.pushViewController(controller, animated: false)
                UserPreferences.DeepLinkingStatus = ""
            }
        }
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
            
            print("login request : " + LoginAPI)
            
            
            AF.request(LoginAPI, method: .get, parameters: nil, encoding: URLEncoding(destination: .methodDependent), headers: appDelegate.loginHeaderCredentials).responseJSON { (response:AFDataResponse<Any>) in
                ActivityIndicator.hide()
                switch response.result {
                case .success(let result):
                    let dictionary = result as? [String: Any]
                    let authResult = dictionary?["result"] as? String
                    if (authResult == "Authenticated") {
                        //self.getTotalContacts()
                        self.checkNewContact()
                        self.checkNewFeed()
                        //self.getFirstContacts()
                        UserPreferences.LoginHeaderCodition = ["Authorization": appDelegate.loginHeaderCredentials.value(for: "Authorization")!]
                        UserPreferences.LoginStatus = "Registered"
                        UserPreferences.LoginID = username
                        UserPreferences.Password = password
                        
                        self.alreadyLoggedIn()
                        
                    }else {
                        DispatchQueue.main.async(execute: { () -> Void in
                            let alert = UIAlertController(title: "Alert", message: "Authentication failed. Please try again or reset your password at www.uptous.com", preferredStyle: UIAlertController.Style.alert)
                            alert.addAction(UIAlertAction(title: "Try Again", style: UIAlertAction.Style.default, handler: nil))
                            self.present(alert, animated: true, completion: nil)
                        })
                    }
                    break
                    
                case .failure(_):
                    let alert = UIAlertController(title: "Alert", message: "Authentication failed. Please try again or reset your password at www.uptous.com", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "Try Again", style: UIAlertAction.Style.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    break
                    
                }
            }
        }else {
            
            BaseUIView.toast("Please enter email or password")
        }
        return

    }
    
    func checkNewFeed() {
        print("Checking new feed")
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
            let data = response as? NSDictionary
            self.defaults.set(data?.object(forKey: "lastContactChange"), forKey: "LastModifiedContact")
            self.defaults.synchronize()
        }) {
            (error) -> Void in
        }
    }
    
    
    //******************************
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension LoginViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        //login()
        return true
    }
}


