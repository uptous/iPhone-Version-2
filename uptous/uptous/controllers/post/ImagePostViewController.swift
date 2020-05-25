//
//  ImagePostViewController.swift
//  uptous
//
//  Created by Roshan Gita  on 11/21/16.
//  Copyright © 2016 UpToUs. All rights reserved.
//

import UIKit
import IBAnimatable

class ImagePostViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    @IBOutlet var captionTextField : UITextField!
    @IBOutlet var fileTextField : UITextField!
    @IBOutlet var addNewAlbumTextField : UITextField!
    @IBOutlet var addNewAlbumButton : UIButton!
    @IBOutlet var communityNameTextField : UITextField!
    @IBOutlet var dropdownButton: UIButton!
    @IBOutlet weak var displayImage : UIImageView!
    @IBOutlet weak var displayImage1 : UIImageView!
    @IBOutlet weak var displayImage2 : UIImageView!
    @IBOutlet weak var displayImage3 : UIImageView!
    @IBOutlet weak var displayImage4 : UIImageView!
    
    //@IBOutlet weak var albumView1 : AnimatableView!
    @IBOutlet weak var albumView2 : UIView!
    
    var selectedAlbumStatus = "1"
    var selectedAlbumID = 0
    var uploadedAlbumID = 0
    var selectedImg = 0
    var allImageData = [Any]()
    
    var communityTableView = UITableView()
    var communityAlbumTableView = UITableView()
    
    var communityList = [String]()
    var albumList = [String]()
    var albumListID = [Int]()
    var list = [AnyObject]()
    var selectedCommunityID: Int?
    var menuView : UIView!
    var albumMenuView : UIView!
    var imageData : String!
    var imageData1 : String!
    var imageData2 : String!
    var imageData3 : String!
    var imageData4 : String!
    var selectedCommunity = "0"
    var selectedAlbum = "0"
    var lastImageId = -1

    private var imagePicker : UIImagePickerController!


    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        addNewAlbumButton.isEnabled = false
        fetchCommunity()
        let _ : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ImagePostViewController.dismissKeyboard))
         //NotificationCenter.default.addObserver(self, selector: #selector(ImagePostViewController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        //NotificationCenter.default.addObserver(self, selector: #selector(ImagePostViewController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        menuView = UIView()
        albumMenuView = UIView()
    }
    
    //MARK:- Dismiss Keyboard
    @objc func dismissKeyboard(){
        //view.endEditing(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        menuView.isHidden = true
        albumMenuView.isHidden = true
        lastImageId = -1
    }
    
    func uploadExitingAlbum(imgData: String, toDismiss: Bool) {
        
        if selectedAlbumID != 0 {
            let urlString = PostImageMessage + ("\(selectedCommunityID!)") + ("/album/\(selectedAlbumID)")
            
            let para = ["filname":addNewAlbumTextField.text!,"photo":("\(imgData)")]
            
            DataConnectionManager.requestPOSTURL(api: urlString, para: para, success: {
                (response) -> Void in
                
                if response["status"] as? String == "0" {
                    if toDismiss {
                        self.dismiss(animated: true, completion: nil)
                    }
                }else {
                    let msg = response["message"] as? String
                    let alert = UIAlertController(title: "Alert", message: msg, preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            }, failure: {
                (error) -> Void in
            })
        }
    }
    
    func uploadImage(imgData: String) {
        
        let albumTitle = fileTextField.text!.replacingOccurrences(of: " ", with: "%20")
        
        let urlString = PostImageMessage + ("\(selectedCommunityID!)") + ("/title/\(albumTitle)")
        let para = ["caption":captionTextField.text!,"filname":albumTitle,"photo":("\(imgData)")]
        
        DataConnectionManager.requestPOSTURL(api: urlString, para: para, success: {
            (response) -> Void in
            
            if response["status"] as? String == "0" {
                self.uploadedAlbumID = Int(response["albumId"] as! String)!
                
                if self.lastImageId == 0 {
                    self.dismiss(animated: true, completion: nil)
                } else {
                
                    //DispatchQueue.main.async(execute: {
                        if self.displayImage1.image != nil {
                            self.selectedAlbumID = self.uploadedAlbumID
                            self.uploadExitingAlbum(imgData: self.imageData1, toDismiss: self.lastImageId == 1)
                        }
                        
                        if self.displayImage2.image != nil {
                            self.selectedAlbumID = self.uploadedAlbumID
                            self.uploadExitingAlbum(imgData: self.imageData2, toDismiss: self.lastImageId == 2)
                        }
                        
                        if self.displayImage3.image != nil {
                            self.selectedAlbumID = self.uploadedAlbumID
                            self.uploadExitingAlbum(imgData: self.imageData3, toDismiss: self.lastImageId == 3)
                        }
                        
                        if self.displayImage4.image != nil {
                            self.selectedAlbumID = self.uploadedAlbumID
                            self.uploadExitingAlbum(imgData: self.imageData4, toDismiss: self.lastImageId == 4)
                        }
                    //})
                }
                
            } else {
                let msg = response["message"] as? String
                let alert = UIAlertController(title: "Alert", message: msg, preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }, failure: {
            (error) -> Void in
        })
        
    }
    
    @IBAction func uploadButtonClick(_ sender: UIButton) {
        if (selectedAlbumStatus == "1") {
            if (fileTextField.text != "") {
                //Uploading multiple images
                if displayImage.image != nil {
                    self.uploadImage(imgData: imageData)
                }
                
            }else {
                let alert = UIAlertController(title: "Alert", message: "Please fill in all fields", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Try Again", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
            
        }else if (selectedAlbumStatus == "2") {
            if displayImage.image != nil {
                self.uploadExitingAlbum(imgData: imageData, toDismiss: false)
            }
            
            if displayImage1.image != nil {
                self.uploadExitingAlbum(imgData: imageData1, toDismiss: false)
            }
            
            if displayImage2.image != nil {
                self.uploadExitingAlbum(imgData: imageData2, toDismiss: false)
            }
            
            if displayImage3.image != nil {
                self.uploadExitingAlbum(imgData: imageData3, toDismiss: false)
            }
            
            if displayImage4.image != nil {
                self.uploadExitingAlbum(imgData: imageData4, toDismiss: false)
            }
            self.dismiss(animated: true, completion: nil)
        }
        //self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func fetchAlbumClick(_ sender: UIButton) {
        menuView.isHidden = true
        albumMenuView.isHidden = false
        
        if selectedAlbum == "0" {
            selectedAlbum = "1"
            albumMenuView.frame = CGRect(x: addNewAlbumButton.frame.origin.x, y: addNewAlbumButton.frame.origin.y+35, width: addNewAlbumButton.frame.size.width, height: self.view.frame.size.height - 300)
            albumMenuView.backgroundColor = UIColor.white
            self.view.addSubview(albumMenuView)
            
            communityAlbumTableView.frame = CGRect(x: 0, y: 0, width: addNewAlbumButton.frame.size.width, height: self.view.frame.size.height - 300)
            // Delegates and data Source
            communityAlbumTableView.dataSource = self
            communityAlbumTableView.delegate = self
            communityAlbumTableView.register(DropperCell.self, forCellReuseIdentifier: "cell")
            // Styling
            communityAlbumTableView.backgroundColor = UIColor.white
            communityAlbumTableView.separatorStyle = UITableViewCell.SeparatorStyle.singleLine
            communityAlbumTableView.bounces = false
            communityAlbumTableView.layer.cornerRadius = 9.0
            communityAlbumTableView.clipsToBounds = true
            albumMenuView.addSubview(communityAlbumTableView)
        }else {
            selectedAlbum = "0"
            menuView.isHidden = true
            albumMenuView.isHidden = true
        }
        
    }
    
    //MARK: Fetch Community Records
    func fetchAlbumBasedCommunity(communityID: Int) {
        addNewAlbumButton.isEnabled = true
        addNewAlbumTextField.isEnabled = true
        self.albumList.removeAll()
        self.albumList.append("ADD NEW ALBUM")
        self.albumListID.append(0)
        //addNewAlbumTextField.text = "ADD NEW ALBUM"
        let url = FetchAlbumAPI + "\(communityID)"
        DataConnectionManager.requestGETURL(api: url, para: ["":""], success: {
            (response) -> Void in
            let item = response as! NSArray
            for index in 0..<item.count {
                let dic = item.object(at: index) as! NSDictionary
                let item = CommunityAlbum(info: dic)
                self.albumList.append(item.title!)
                self.albumListID.append(item.Id!)
            }
            self.communityAlbumTableView.reloadData()
        }) {
            (error) -> Void in
        }
    }
    
    //MARK: Fetch Community Records
    func fetchCommunity() {
        DataConnectionManager.requestGETURL(api: TopMenuCommunity, para: ["":""], success: {
            (response) -> Void in
           let item = response as! NSArray
            for index in 0..<item.count {
                let dic = item.object(at: index) as! NSDictionary
                let item = Community(info: dic)
                self.list.append(item)
                self.communityList.append(item.name!)
            }
        }) {
            (error) -> Void in
        }
    }
    
    @IBAction func menuButtonClick(_ sender: UIButton) {
        albumMenuView.isHidden = true
        menuView.isHidden = false
        if selectedCommunity == "0" {
            selectedCommunity = "1"
            menuView.frame = CGRect(x: dropdownButton.frame.origin.x, y: dropdownButton.frame.origin.y+35, width: dropdownButton.frame.size.width, height: self.view.frame.size.height - 200)
            menuView.backgroundColor = UIColor.white
            self.view.addSubview(menuView)
            
            communityTableView.frame = CGRect(x: 0, y: 0, width: dropdownButton.frame.size.width, height: self.view.frame.size.height - 200)
            // Delegates and data Source
            communityTableView.dataSource = self
            communityTableView.delegate = self
            communityTableView.register(DropperCell.self, forCellReuseIdentifier: "cell")
            // Styling
            communityTableView.backgroundColor = UIColor.white
            communityTableView.separatorStyle = UITableViewCell.SeparatorStyle.singleLine
            communityTableView.bounces = false
            communityTableView.layer.cornerRadius = 9.0
            communityTableView.clipsToBounds = true
            //self.view.bringSubview(toFront: communityTableView)
            menuView.addSubview(communityTableView)
        }else {
            selectedCommunity = "0"
            menuView.isHidden = true
        }
    }
    
    @IBAction func back(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK: - Delegates
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
// Local variable inserted by Swift 4.2 migrator.
        
        let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)
        
        var chosenImage = UIImage()
        chosenImage = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)] as! UIImage //2
        //self.displayImage.contentMode = .scaleAspectFill //3
        //let fixOrientationImage=chosenImage.fixOrientation1()
        //self.displayImage.image = fixOrientationImage
        //chosenImage = fixOrientationImage

        if selectedImg == 0 {
            imageData = chosenImage.jpegData(compressionQuality: 0.5)?.base64EncodedString()
            self.displayImage.image = chosenImage
            if self.lastImageId <= 0 {
                self.lastImageId = 0
            }
        }else if selectedImg == 1 {
            imageData1 = chosenImage.jpegData(compressionQuality: 0.5)?.base64EncodedString()
            self.displayImage1.image = chosenImage
            if self.lastImageId <= 1 {
                self.lastImageId = 1
            }
        }else if selectedImg == 2 {
            imageData2 = chosenImage.jpegData(compressionQuality: 0.5)?.base64EncodedString()
            self.displayImage2.image = chosenImage
            if self.lastImageId <= 2 {
                self.lastImageId = 2
            }
        }else if selectedImg == 3 {
            imageData3 = chosenImage.jpegData(compressionQuality: 0.5)?.base64EncodedString()
            self.displayImage3.image = chosenImage
            if self.lastImageId <= 3 {
                self.lastImageId = 3
            }
        }else if selectedImg == 4 {
            imageData4 = chosenImage.jpegData(compressionQuality: 0.5)?.base64EncodedString()
            self.displayImage4.image = chosenImage
            if self.lastImageId <= 4 {
                self.lastImageId = 4
            }
        }
        
        picker.dismiss(animated:true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    //MARK: - Crop Photo
    func cropToBounds(image: UIImage, width: Double, height: Double) -> UIImage {
        
        let contextImage: UIImage = UIImage(cgImage: image.cgImage!)
        
        let contextSize: CGSize = contextImage.size
        
        var posX: CGFloat = 0.0
        var posY: CGFloat = 0.0
        var cgwidth: CGFloat = CGFloat(width)
        var cgheight: CGFloat = CGFloat(height)
        
        // See what size is longer and create the center off of that
        if contextSize.width > contextSize.height {
            posX = ((contextSize.width - contextSize.height) / 2)
            posY = 0
            cgwidth = contextSize.height
            cgheight = contextSize.height
        } else {
            posX = 0
            posY = ((contextSize.height - contextSize.width) / 2)
            cgwidth = contextSize.width
            cgheight = contextSize.width
        }
        
        let rect: CGRect = CGRect(x: posX, y: posY, width: cgwidth, height: cgheight)//CGRectMake(posX, posY, cgwidth, cgheight)
        
        // Create bitmap image from context using the rect
        let imageRef: CGImage = contextImage.cgImage!.cropping(to: rect)!
        
        // Create a new image based on the imageRef and rotate back to the original orientation
        let image: UIImage = UIImage(cgImage: imageRef, scale: image.scale, orientation: image.imageOrientation)
        
        return image
    }
    
    func keyboardWillShow(notification: NSNotification) {
        
        if ((notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue) != nil {
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y -= 50
            }
        }
        
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if ((notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue) != nil {
            if self.view.frame.origin.y != 0{
                self.view.frame.origin.y += 50
            }
        }
    }
    
     func uploadNewPicture() {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        imagePicker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        imagePicker.modalPresentationStyle = .overCurrentContext
        present(imagePicker, animated: true, completion: nil)
    }
    
     func takeNewPicture() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePicker.allowsEditing = false
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            imagePicker.cameraCaptureMode = .photo
            imagePicker.modalPresentationStyle = .overCurrentContext
            present(imagePicker,animated: true,completion: nil)
        }
    }
    
    @IBAction func selectImg(_ sender: UIButton) {
        if sender.tag == 100 {
            selectedImg = 0
            showActionSheet()
        }else if sender.tag == 101 {
            selectedImg = 1
           showActionSheet()
        }else if sender.tag == 102 {
            selectedImg = 2
            showActionSheet()
        }else if sender.tag == 103 {
            selectedImg = 3
            showActionSheet()
        }else if sender.tag == 104 {
            selectedImg = 4
            showActionSheet()
        }
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

//MARK: TextField Delegate
extension ImagePostViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension ImagePostViewController: UITableViewDelegate, UITableViewDataSource {
    
    public var border: (width: CGFloat, color: UIColor) {
        get { return (communityTableView.layer.borderWidth, UIColor(cgColor: communityTableView.layer.borderColor!)) }
        set {
            let (borderWidth, borderColor) = newValue
            communityTableView.layer.borderWidth = borderWidth
            communityTableView.layer.borderColor = borderColor.cgColor
        }
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! DropperCell
        // Sets up Cell
        // Removes image and text just in case the cell still contains the view
        cell.textItem.removeFromSuperview()
        //cell.last = items.count - 1  // Sets the last item to the cell
        cell.indexPath = indexPath as NSIndexPath? // Sets index path to the cell
        cell.borderColor = border.color // Sets the border color for the seperator
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        tableView.backgroundColor = UIColor.white
        cell.backgroundColor = UIColor.white
        cell.textItem.textColor = UIColor.black
        cell.textItem.numberOfLines = 2
        cell.textItem.textAlignment = .center
        cell.textItem.font = UIFont.systemFont(ofSize: 16.0)
        cell.cellType = .Text
        if tableView == communityAlbumTableView {
            let decodedString = self.albumList[indexPath.row].removingPercentEncoding!
            cell.textItem.text =  decodedString
            
            //cell.textItem.text = self.albumList[indexPath.row]
        }else {
            let decodedString = self.communityList[indexPath.row].removingPercentEncoding!
            cell.textItem.text =  decodedString
            //cell.textItem.text = self.communityList[indexPath.row]
        }
        return cell
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == communityAlbumTableView {
            return self.albumList.count
        }else {
            return self.communityList.count
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == communityAlbumTableView {
            let album = self.albumList[indexPath.row] //as! CommunityAlbum
            if album == "ADD NEW ALBUM" {
                captionTextField.isHidden = false
                fileTextField.isHidden = false
                selectedAlbumStatus = "1"
            }else {
                fileTextField.text = ""
                captionTextField.isHidden = true
                fileTextField.isHidden = true
                selectedAlbumStatus = "2"
            }
            selectedAlbumID = self.albumListID[indexPath.row]
            addNewAlbumTextField.text = ""
            addNewAlbumTextField.text = album
            self.albumMenuView.removeFromSuperview()
        }else {
            let community = self.list[indexPath.row] as! Community
            selectedCommunityID = community.communityId
            communityNameTextField.text = community.name
            self.fetchAlbumBasedCommunity(communityID: selectedCommunityID!)
            self.menuView.removeFromSuperview()
        }
        
    }
}

//MARK:- Image Orientation fix

extension UIImage {
    
    func fixOrientation1() -> UIImage {
        
        // No-op if the orientation is already correct
        if ( self.imageOrientation == UIImage.Orientation.up ) {
            return self;
        }
        
        // We need to calculate the proper transformation to make the image upright.
        // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
        var transform: CGAffineTransform = CGAffineTransform.identity
        
        if ( self.imageOrientation == UIImage.Orientation.down || self.imageOrientation == UIImage.Orientation.downMirrored ) {
            transform = transform.translatedBy(x: self.size.width, y: self.size.height)
            transform = transform.rotated(by: CGFloat(Double.pi))
        }
        
        if ( self.imageOrientation == UIImage.Orientation.left || self.imageOrientation == UIImage.Orientation.leftMirrored ) {
            transform = transform.translatedBy(x: self.size.width, y: 0)
            transform = transform.rotated(by: CGFloat(Double.pi/2))
        }
        
        if ( self.imageOrientation == UIImage.Orientation.right || self.imageOrientation == UIImage.Orientation.rightMirrored ) {
            transform = transform.translatedBy(x: 0, y: self.size.height);
            transform = transform.rotated(by: CGFloat(-Double.pi/2));
        }
        
        if ( self.imageOrientation == UIImage.Orientation.upMirrored || self.imageOrientation == UIImage.Orientation.downMirrored ) {
            transform = transform.translatedBy(x: self.size.width, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
        }
        
        if ( self.imageOrientation == UIImage.Orientation.leftMirrored || self.imageOrientation == UIImage.Orientation.rightMirrored ) {
            transform = transform.translatedBy(x: self.size.height, y: 0);
            transform = transform.scaledBy(x: -1, y: 1);
        }
        
        // Now we draw the underlying CGImage into a new context, applying the transform
        // calculated above.
        let ctx: CGContext = CGContext(data: nil, width: Int(self.size.width), height: Int(self.size.height),
                                       bitsPerComponent: self.cgImage!.bitsPerComponent, bytesPerRow: 0,
                                       space: self.cgImage!.colorSpace!,
                                       bitmapInfo: self.cgImage!.bitmapInfo.rawValue)!;
        
        ctx.concatenate(transform)
        
        if ( self.imageOrientation == UIImage.Orientation.left ||
            self.imageOrientation == UIImage.Orientation.leftMirrored ||
            self.imageOrientation == UIImage.Orientation.right ||
            self.imageOrientation == UIImage.Orientation.rightMirrored ) {
            ctx.draw(self.cgImage!, in: CGRect(x: 0,y: 0,width: self.size.height,height: self.size.width))
        } else {
            ctx.draw(self.cgImage!, in: CGRect(x: 0,y: 0,width: self.size.width,height: self.size.height))
        }
        
        // And now we just create a new UIImage from the drawing context and return it
        return UIImage(cgImage: ctx.makeImage()!)
    }
}

extension Data {
    var attributedString: NSAttributedString? {
        do {
            return try NSAttributedString(data: self, options:convertToNSAttributedStringDocumentReadingOptionKeyDictionary([convertFromNSAttributedStringDocumentAttributeKey(NSAttributedString.DocumentAttributeKey.documentType): convertFromNSAttributedStringDocumentType(NSAttributedString.DocumentType.html), convertFromNSAttributedStringDocumentAttributeKey(NSAttributedString.DocumentAttributeKey.characterEncoding): String.Encoding.utf8.rawValue]), documentAttributes: nil)
        } catch {
            print(error)
        }
        return nil
    }
}
extension String {
    var data: Data {
        return Data(utf8)
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

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToNSAttributedStringDocumentReadingOptionKeyDictionary(_ input: [String: Any]) -> [NSAttributedString.DocumentReadingOptionKey: Any] {
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (NSAttributedString.DocumentReadingOptionKey(rawValue: key), value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromNSAttributedStringDocumentAttributeKey(_ input: NSAttributedString.DocumentAttributeKey) -> String {
	return input.rawValue
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromNSAttributedStringDocumentType(_ input: NSAttributedString.DocumentType) -> String {
	return input.rawValue
}
