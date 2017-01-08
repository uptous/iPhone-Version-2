//
//  ImagePostViewController.swift
//  uptous
//
//  Created by Roshan Gita  on 11/21/16.
//  Copyright © 2016 SPA. All rights reserved.
//

import UIKit


class ImagePostViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    @IBOutlet var captionTextField : UITextField!
    @IBOutlet var fileTextField : UITextField!
    var communityTableView = UITableView()
    var communityList = [String]()
    var list = [AnyObject]()
    var selectedCommunityID: Int?
    var menuView : UIView!
    var imageData : String!
    var selectedCommunity = "0"

    @IBOutlet var communityNameTextField : UITextField!
    
    @IBOutlet var dropdownButton: UIButton!
    @IBOutlet weak var displayImage : UIImageView!

    private var imagePicker : UIImagePickerController!


    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        fetchCommunity()
    }
    
    @IBAction func uploadButtonClick(_ sender: UIButton) {
        var stringPost = "caption=" + captionTextField.text!
        stringPost += "&filname=" + "file1"
        stringPost += "&photo=" + ("\(imageData!)")
        
        let urlString = PostImageMessage + ("\(selectedCommunityID!)") + ("/title/\(fileTextField.text!)")
        //print(stringPost) ///title/{title}
        
        DataConnectionManager.requestPOSTURL1(api: urlString, stringPost: stringPost, success: {
            (response) -> Void in
            print(response)
            
            if response["status"] as? String == "0" {
                DispatchQueue.main.async(execute: {
                     self.dismiss(animated: true, completion: {})
                })
            }else {
                let msg = response["message"] as? String
                let alert = UIAlertController(title: "Alert", message: msg, preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        })
    }
    
    //MARK: Fetch Community Records
    func fetchCommunity() {
        DataConnectionManager.requestGETURL(api: TopMenuCommunity, para: ["":""], success: {
            (response) -> Void in
            print(response)
            
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
        
        if selectedCommunity == "0" {
            selectedCommunity = "1"
            menuView = UIView()
            menuView.frame = CGRect(x: dropdownButton.frame.origin.x, y: dropdownButton.frame.origin.y+45, width: dropdownButton.frame.size.width, height: 300)
            menuView.backgroundColor = UIColor.white
            self.view.addSubview(menuView)
            
            communityTableView.frame = CGRect(x: 0, y: 0, width: dropdownButton.frame.size.width, height: 300)
            // Delegates and data Source
            communityTableView.dataSource = self
            communityTableView.delegate = self
            communityTableView.register(DropperCell.self, forCellReuseIdentifier: "cell")
            // Styling
            communityTableView.backgroundColor = UIColor.lightGray
            communityTableView.separatorStyle = UITableViewCellSeparatorStyle.singleLine
            communityTableView.bounces = false
            communityTableView.layer.cornerRadius = 9.0
            communityTableView.clipsToBounds = true
            menuView.addSubview(communityTableView)
        }else {
            selectedCommunity = "0"
            menuView.isHidden = true
        }    }
    
    @IBAction func back(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func uploadNewPicture(sender: UIButton) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        imagePicker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        imagePicker.modalPresentationStyle = .popover
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func takeNewPicture(sender: UIButton) {
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
        self.displayImage.contentMode = .scaleAspectFill //3
        imageData = UIImageJPEGRepresentation(chosenImage, 0.9)?.base64EncodedString()
        self.displayImage.image = cropToBounds(image: chosenImage,width:150,height:150)
        dismiss(animated:true, completion: nil)
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
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
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
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
        // let item = items[indexPath.row]
        cell.backgroundColor = UIColor.white
        cell.textItem.textColor = UIColor.black
        cell.textItem.numberOfLines = 2
        cell.textItem.textAlignment = .center
        cell.textItem.font = UIFont.systemFont(ofSize: 16.0)
        cell.cellType = .Text
        cell.textItem.text = self.communityList[indexPath.row]
        
        return cell
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.communityList.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let community = self.list[indexPath.row] as! Community
        selectedCommunityID = community.communityId
        communityNameTextField.text = community.name
        self.menuView.removeFromSuperview()
    }
}



