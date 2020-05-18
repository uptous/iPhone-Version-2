//
//  ProfileViewController.swift
//  uptous
//
//  Created by Roshan Gita  on 11/28/16.
//  Copyright © 2016 UpToUs. All rights reserved.
//

import UIKit


class ProfileViewController: GeneralViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    @IBOutlet weak var firstNameTxtField: UITextField!
    @IBOutlet weak var lastNameTxtField: UITextField!
    @IBOutlet weak var emailTxtField: UITextField!
    @IBOutlet weak var mobileTxtField: UITextField!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var imagePicker : UIImagePickerController!
    var imgUploadStatus = false
    var activeField: UITextField?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profileImage.layer.borderColor = UIColor.black.cgColor
        profileImage.layer.borderWidth = 2.0
        profileImage.layer.cornerRadius = 60.0
        profileImage.layer.masksToBounds = true

        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        addToolBar(textField: mobileTxtField)
        
        //NotificationCenter.default.addObserver(self, selector: #selector(ProfileViewController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        //NotificationCenter.default.addObserver(self, selector: #selector(ProfileViewController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        let delayTime = DispatchTime.now() + Double(Int64(1 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: delayTime) {
            self.fetchProfile()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        registerForKeyboardNotifications()
    }
    
    //MARK:- Keyboard
    func registerForKeyboardNotifications(){
        //Adding notifies on keyboard appearing
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasShown(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeHidden(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWasShown(notification: NSNotification){
        //Need to calculate keyboard exact size due to Apple suggestions
        self.scrollView.isScrollEnabled = true
        let info = notification.userInfo!
        let keyboardSize = (info[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size
        let contentInsets : UIEdgeInsets = UIEdgeInsets.init(top: 0.0, left: 0.0, bottom: keyboardSize!.height, right: 0.0)
        
        self.scrollView.contentInset = contentInsets
        self.scrollView.scrollIndicatorInsets = contentInsets
        
        var aRect : CGRect = self.view.frame
        aRect.size.height -= keyboardSize!.height
        if let activeField = self.activeField {
            if (!aRect.contains(activeField.frame.origin)){
                self.scrollView.scrollRectToVisible(activeField.frame, animated: true)
            }
        }
    }
    
    @objc func keyboardWillBeHidden(notification: NSNotification){
        //Once keyboard disappears, restore original positions
        let info = notification.userInfo!
        let keyboardSize = (info[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size
        let contentInsets : UIEdgeInsets = UIEdgeInsets.init(top: 0.0, left: 0.0, bottom: -keyboardSize!.height, right: 0.0)
        self.scrollView.contentInset.bottom = 0
        self.scrollView.scrollIndicatorInsets = contentInsets
        self.view.endEditing(true)
        //mainViewConstraintHeight.constant = 1300
        //mainView.layoutIfNeeded()
        self.scrollView.isScrollEnabled = true
    }
    
    /*func keyboardWillShow(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
        
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0{
                self.view.frame.origin.y += keyboardSize.height
            }
        }
    }*/
    
    @IBAction func signOutClick(_ sender: UIButton) {
        UserPreferences.LoginHeaderCodition = [:]
        UserPreferences.LoginStatus = ""
        UserPreferences.LoginID = ""
        UserPreferences.Password = ""
        UserPreferences.SelectedCommunityID = 001
        UserPreferences.SelectedCommunityName = ""
        UserPreferences.AllContactList = []
        UserPreferences.LoginID = ""
        UserPreferences.Password = ""
        
        let navController = appDelegate.window?.rootViewController as? UINavigationController
        navController?.popToRootViewController(animated: true)
    }
    
    func fetchProfile() {
        DataConnectionManager.requestGETURL(api: Profile, para: ["":""], success: {
                (response) -> Void in
           let data = response as? NSDictionary
           let profileData = UserProfile(info: data)
            self.firstNameTxtField.text = profileData.firstName
            self.lastNameTxtField.text = profileData.lastName
            self.emailTxtField.text = profileData.email
            self.mobileTxtField.text = profileData.phone
            
            if profileData.photo == "https://dsnn35vlkp0h4.cloudfront.net/images/blank_image.gif" {
                _ = try? Data(contentsOf: Bundle.main.url(forResource: "upload-image", withExtension: "gif")!)
                //let advTimeGif = UIImage.gifImageWithData(imageData!)
                //self.image.image = advTimeGif
                
            }else {
                let block: SDWebImageCompletionBlock = {(image: UIImage?, error: Error?, cacheType: SDImageCacheType!, imageURL: URL?) -> Void in
                    self.profileImage.image = image
                }
                //self.profileImage.sd_setImage(with: URL(string:profileData.photo!) as URL!, completed:block)
                let url = URL(string:profileData.photo!)
                self.profileImage.sd_setImage(with: url, completed: block)
            }
                
        }) { (error) -> Void in
            print(error)
        }
        
    }
    
    func updateProfile() {
        let imageData = Utility.scaleUIImageToSize(self.profileImage.image!, size: CGSize(width: 120, height: 120)).jpegData(compressionQuality: 0.9)?.base64EncodedString()
        
        var stringPost = "firstname=" + firstNameTxtField.text!
        stringPost += "&lastname=" + lastNameTxtField.text!
        stringPost += "&email=" + emailTxtField.text!
        stringPost += "&phone=" + mobileTxtField.text!
        stringPost += "&photo=" + ("\(imageData!)")
        
        DataConnectionManager.requestPOSTURL1(api: UpdateProfile, stringPost: stringPost, success: {
                (response) -> Void in
            
            if response["status"] as? String == "0" {
                self.imgUploadStatus = false
                self.showAlertWithoutCancel(title: "Alert", message: "Your Profile is successfully updated.")
            }else {
                self.showAlertWithoutCancel(title: "Alert", message: "Your Profile is not updated.")
            }
        })
    }
    
    func showAlertWithoutCancel(title:String?, message:String?) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
            print("you have pressed OK button");
        }
        alertController.addAction(OKAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
       
    @IBAction func back(_ sender: UIButton) {
        self.navigationController!.popViewController(animated: true)
    }
    
    @IBAction func saveClick(_ sender: UIButton) {
        updateProfile()
    }
    
    @IBAction func changeProfilePic(_ sender: UIButton) {
        showActionSheet()
    }
    
    //MARK:- All Action Sheet
    func showActionSheet() {
        let optionMenu = UIAlertController(title: nil, message: "Choose Option", preferredStyle: .actionSheet)
        
        //Add Friend Popup
        let click = UIAlertAction(title: "Open Camera", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            
            self.takeNewPicture()
        })
        
        let library = UIAlertAction(title: "Open Gallery", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            
            self.uploadNewPicture()
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {
            (alert: UIAlertAction!) -> Void in
        })
        optionMenu.addAction(click)
        optionMenu.addAction(library)
        optionMenu.addAction(cancelAction)
        
        //self.modalPresentationStyle = UIModalPresentationStyle.currentContext
        self.present(optionMenu, animated: true, completion: nil)
    }
    
    func uploadNewPicture() {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        imagePicker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        imagePicker.modalPresentationStyle = .popover
        present(imagePicker, animated: true, completion: nil)
    }
    
    func takeNewPicture() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePicker.allowsEditing = false
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            imagePicker.cameraCaptureMode = .photo
            imagePicker.modalPresentationStyle = .fullScreen
            present(imagePicker,animated: true,completion: nil)
        }
    }
    
    //MARK: - Delegates
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
// Local variable inserted by Swift 4.2 migrator.
let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)

        var chosenImage = UIImage()
        chosenImage = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)] as! UIImage //2
        delay(0.2, closure: { () -> () in
            // Mukesh
            self.profileImage.image = chosenImage
            //
         })
        dismiss(animated:true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.imgUploadStatus = false
        dismiss(animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension ProfileViewController: UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeField = textField
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        activeField = nil
    }
    
    func addToolBar(textField: UITextField){
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1)
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: #selector(ProfileViewController.donePressed))
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItem.Style.plain, target: self, action: #selector(ProfileViewController.cancelPressed))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        toolBar.sizeToFit()
        
        textField.delegate = self
        textField.inputAccessoryView = toolBar
    }
    @objc func donePressed(){
        view.endEditing(true)
    }
    @objc func cancelPressed(){
        view.endEditing(true) // or do something
    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
	return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
	return input.rawValue
}
