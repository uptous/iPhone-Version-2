//
//  ProfileViewController.swift
//  uptous
//
//  Created by Roshan Gita  on 11/28/16.
//  Copyright © 2016 SPA. All rights reserved.
//

import UIKit


class ProfileViewController: GeneralViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,RSKImageCropViewControllerDelegate {

    @IBOutlet weak var firstNameTxtField: UITextField!
    @IBOutlet weak var lastNameTxtField: UITextField!
    @IBOutlet weak var emailTxtField: UITextField!
    @IBOutlet weak var mobileTxtField: UITextField!
    @IBOutlet weak var profileImage: UIImageView!
    var imagePicker : UIImagePickerController!
    var imgUploadStatus = false
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       // profileImage.layer.co
        profileImage.layer.borderColor = UIColor.black.cgColor
        profileImage.layer.borderWidth = 2.0
        profileImage.layer.cornerRadius = 60.0
        profileImage.layer.masksToBounds = true

        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        addToolBar(textField: mobileTxtField)
        
        NotificationCenter.default.addObserver(self, selector: #selector(ProfileViewController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ProfileViewController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        let delayTime = DispatchTime.now() + Double(Int64(1 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: delayTime) {
            self.fetchProfile()
        }
    }
    
    func keyboardWillShow(notification: NSNotification) {
        
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
    }
    
    func fetchProfile() {
        DataConnectionManager.requestGETURL(api: Profile, para: ["":""], success: {
                (response) -> Void in
           print(response)
           let data = response as? NSDictionary
           let profileData = UserProfile(info: data)
            self.firstNameTxtField.text = profileData.firstName
            self.lastNameTxtField.text = profileData.lastName
            self.emailTxtField.text = profileData.email
            self.mobileTxtField.text = profileData.phone
            
            if profileData.photo == "https://dsnn35vlkp0h4.cloudfront.net/images/blank_image.gif" {
                let imageData = try? Data(contentsOf: Bundle.main.url(forResource: "upload-image", withExtension: "gif")!)
                //let advTimeGif = UIImage.gifImageWithData(imageData!)
                //self.image.image = advTimeGif
                
            }else {
                let block: SDWebImageCompletionBlock = {(image: UIImage?, error: Error?, cacheType: SDImageCacheType!, imageURL: URL?) -> Void in
                    self.profileImage.image = image
                }
                self.profileImage.sd_setImage(with: URL(string:profileData.photo!) as URL!, completed:block)
            }
                
        }) { (error) -> Void in
            print(error)
        }
        
    }
    
    func updateProfile() {
        let imageData = UIImageJPEGRepresentation(Utility.scaleUIImageToSize(self.profileImage.image!, size: CGSize(width: 120, height: 120)), 0.9)?.base64EncodedString()
        
        var stringPost = "firstname=" + firstNameTxtField.text!
        stringPost += "&lastname=" + lastNameTxtField.text!
        stringPost += "&email=" + emailTxtField.text!
        stringPost += "&phone=" + mobileTxtField.text!
        stringPost += "&photo=" + ("\(imageData!)")
        
        DataConnectionManager.requestPOSTURL1(api: UpdateProfile, stringPost: stringPost, success: {
                (response) -> Void in
            print(response)
            
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
        self.dismiss(animated: true, completion: nil)
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
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera
            imagePicker.cameraCaptureMode = .photo
            imagePicker.modalPresentationStyle = .fullScreen
            present(imagePicker,animated: true,completion: nil)
        }
    }
    
    //MARK: - Delegates
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        var chosenImage = UIImage()
        chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage //2
        //self.image.contentMode = .scaleAspectFill //3
        //self.image.image = chosenImage //4
        //dismiss(animated:true, completion: nil)
        
        
        delay(0.2, closure: { () -> () in
         let imageCropVC =  RSKImageCropViewController (image: chosenImage)
         imageCropVC.delegate = self
            self.imgUploadStatus = true
         self.present(imageCropVC, animated: true, completion:nil)
         })
        dismiss(animated:true, completion: nil)
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.imgUploadStatus = false
        dismiss(animated: true, completion: nil)
    }
    
    // MARK :- RSCROPPER IMAGE DELEGATE
    func imageCropViewController(_ controller: RSKImageCropViewController, didCropImage croppedImage: UIImage, usingCropRect cropRect: CGRect) {
        
    }
    
    func imageCropViewController(_ controller: RSKImageCropViewController, didCropImage croppedImage: UIImage, usingCropRect cropRect: CGRect, rotationAngle: CGFloat) {
        //uploadBool = true
        profileImage.layer.masksToBounds = true
        profileImage.layer.cornerRadius = profileImage.frame.size.width/2
        self.profileImage.image = croppedImage;
        self.dismiss(animated: true, completion:nil)
    }
    
    func imageCropViewController(_ controller: RSKImageCropViewController, willCropImage originalImage: UIImage) {
        
    }
    
    func imageCropViewControllerDidCancelCrop(_ controller: RSKImageCropViewController) {
        self.dismiss(animated: true, completion:nil)
        
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
    
    func addToolBar(textField: UITextField){
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1)
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(ProfileViewController.donePressed))
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.plain, target: self, action: #selector(ProfileViewController.cancelPressed))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        toolBar.sizeToFit()
        
        textField.delegate = self
        textField.inputAccessoryView = toolBar
    }
    func donePressed(){
        view.endEditing(true)
    }
    func cancelPressed(){
        view.endEditing(true) // or do something
    }
}
