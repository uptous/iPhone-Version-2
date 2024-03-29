//
//  DetailsLibraryViewController.swift
//  uptous
//
//  Created by Roshan Gita  on 11/9/16.
//  Copyright © 2016 UpToUs. All rights reserved.
//

import UIKit

class DetailsLibraryViewController: GeneralViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var activityindicatordisplay : UIActivityIndicatorView!
    @IBOutlet weak var displayImage : UIImageView!
    @IBOutlet weak var titleLable : UILabel!
    @IBOutlet weak var titleCreateLable : UILabel!
    @IBOutlet weak var headingLable : UILabel!
    
    //Set property of UICollection
    let columnLayout = ColumnFlowLayout(
        cellsPerRow: 3,
        minimumInteritemSpacing: 10,
        minimumLineSpacing: 10,
        sectionInset: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    )
    
    var itemsDatas = NSMutableArray()
    var currentSelectedIndex = 0
    var selectedIndexPath : IndexPath?
    var albumID: String?
    
    var data: Library!
    
    private struct mediaphotoconstant {
        static var cellIdentifier:String = "MediaCollectionCell"
        static var rowHeight:CGFloat! = 100.0;
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        let nibWishList = UINib(nibName: "MediaCollectionCell", bundle: nil);
        collectionView.register(nibWishList, forCellWithReuseIdentifier: mediaphotoconstant.cellIdentifier as String)
        collectionView.delegate = self
        collectionView.dataSource = self
        //headingLable.text = ("\(data.title!) message")
        
        let leftSwipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(DetailsLibraryViewController.swipeLeft(sender:)))
        leftSwipeGesture.direction = .left
        displayImage.addGestureRecognizer(leftSwipeGesture)
        
        
        let rightSwipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(DetailsLibraryViewController.swipeRight(sender:)))
        rightSwipeGesture.direction = .right
        displayImage.addGestureRecognizer(rightSwipeGesture)
    }
    
    @objc func swipeLeft(sender: UISwipeGestureRecognizer) -> Void {
        
        if currentSelectedIndex+1 < itemsDatas.count {
            let data = self.itemsDatas[currentSelectedIndex+1] as? Library
            
            //animate(image: displayImage.image!, inLeftDirection: true)
            //currentImageView.image = images[currentSelectedIndex+1]
            //displayImage.sd_setImage(with: URL.init(string: (data?.photo)!), completed: nil)
            
            let block: SDWebImageCompletionBlock = {(image: UIImage?, error: Error?, cacheType: SDImageCacheType!, imageURL: URL?) -> Void in
                self.displayImage.image = image
            }
            //displayImage.sd_setImage(with: URL(string:(data?.photo)!) as URL!, completed:block)
            let url = URL(string: (data?.photo)!)
            displayImage.sd_setImage(with: url, completed: block)
            
            titleLable.text = data?.caption
            titleCreateLable.text = ("\(Custom.dayStringFromTime((data?.createTime!)!))")
            
            currentSelectedIndex += 1
            selectedIndexPath = IndexPath(item: currentSelectedIndex, section: 0)
            collectionView.scrollToItem(at: selectedIndexPath!, at: .centeredHorizontally, animated: true)
            collectionView.reloadData()
        }
    }
    
    @objc func swipeRight(sender: UISwipeGestureRecognizer) -> Void {
        if currentSelectedIndex-1 >= 0 {
            let data = self.itemsDatas[currentSelectedIndex-1] as? Library
            //animate(image: displayImage.image!, inLeftDirection: false)
            
            let block: SDWebImageCompletionBlock = {(image: UIImage?, error: Error?, cacheType: SDImageCacheType!, imageURL: URL?) -> Void in
                self.displayImage.image = image
            }
            //displayImage.sd_setImage(with: URL(string:(data?.photo)!) as URL!, completed:block)
            let url = URL(string: (data?.photo)!)
            displayImage.sd_setImage(with: url, completed: block)
            
            titleLable.text = data?.caption
            titleCreateLable.text = ("\(Custom.dayStringFromTime((data?.createTime!)!))")
            
            //currentImageView.image = images[currentSelectedIndex-1]
            //displayImage.sd_setImage(with: URL.init(string: itemsDatas[currentSelectedIndex-1] as! String), completed: nil)
            currentSelectedIndex -= 1
            selectedIndexPath = IndexPath(item: currentSelectedIndex, section: 0)
            collectionView.scrollToItem(at: selectedIndexPath!, at: .centeredHorizontally, animated: true)
            collectionView.reloadData()
        }
    }
    
    func animate(image: UIImage, inLeftDirection: Bool) {
        let imageView = UIImageView(image: image)
        imageView.frame = displayImage.frame
        view.addSubview(imageView)
        UIView.animate(withDuration: 0.7, animations: {
            if inLeftDirection == true {
                imageView.frame.origin = CGPoint(x: -(self.view.frame.width + 10), y: imageView.frame.origin.y)
            } else {
                imageView.frame.origin = CGPoint(x: self.view.frame.width + 10, y: imageView.frame.origin.y)
            }
        }, completion: { finished in
            imageView.removeFromSuperview()
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchRecords()
    }
    
    @IBAction func back(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK: Fetch Records
    func fetchRecords() {
        let apiName: String?
        if albumID == nil {
            apiName = AlbumLibrary + ("\(data.Id!)")
        }else{
            apiName = AlbumLibrary + ("\(albumID!)")
        }
        DataConnectionManager.requestGETURL(api: apiName!, para: ["":""], success: {
            (response) -> Void in
            let item = response as! NSArray
            if item.count > 0 {
                for index in 0..<item.count {
                    let dic = item.object(at: index) as! NSDictionary
                    self.itemsDatas.add(Library(info: dic))
                }
                self.collectionView.reloadData()
            }
            
            if self.itemsDatas.count > 0 {
                let data = self.itemsDatas[0] as? Library
                self.displayImage.sd_setImage(with: URL.init(string: (data?.photo)!), completed: nil)
                self.titleLable.text = data?.caption
                self.titleCreateLable.text = ("\(Custom.dayStringFromTime((data?.createTime!)!))")
            }
        }) {
            (error) -> Void in
            
            let alert = UIAlertController(title: "Alert", message: "Error", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Try Again", style: UIAlertAction.Style.default, handler: nil))
            //self.present(alert, animated: true, completion: nil)
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnDownloadTapped(_ sender: UIButton)
    {
        guard let selectedImage = self.displayImage.image else {
            print("Image not found!")
            return
        }
        UIImageWriteToSavedPhotosAlbum(selectedImage, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    func downloadImage(mediapath: String, cell: MediaCollectionCell, index : Int) {
        let block: SDWebImageCompletionBlock = {(image: UIImage?, error: Error?, cacheType: SDImageCacheType!, imageURL: URL?) -> Void in
            cell.thumnnailv.image = image
            if index == self.currentSelectedIndex {
                UIView.animate(withDuration: 0.3, animations: { () -> Void in
                    cell.thumnnailv.layer.shouldRasterize = true
                    cell.transform = CGAffineTransform(rotationAngle: -CGFloat((.pi / 4) / 8.0))
                })
            }else {
                cell.transform = CGAffineTransform(rotationAngle: -0.0)
            }
            cell.activityindicator.isHidden =  true
        }
        cell.activityindicator.isHidden =  false
        cell.activityindicator.startAnimating()
        //cell.thumnnailv.sd_setImage(with: URL(string:mediapath) as URL!, completed:block)
        let url = URL(string:mediapath)
        cell.thumnnailv.sd_setImage(with: url, completed: block)
        
    }
    
    //MARK: - Add image to Library
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            // we got back an error!
            showAlertWith(title: "Save error", message: error.localizedDescription)
        } else {
            showAlertWith(title: "Saved!", message: "Your image has been saved to your photos.")
        }
    }
    
    func showAlertWith(title: String, message: String){
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    
    //MARK:- Collection Delegate
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: mediaphotoconstant.cellIdentifier, for: indexPath) as! MediaCollectionCell
        
        let data = self.itemsDatas[(indexPath as NSIndexPath).row] as? Library
        cell.thumnnailv.image = nil
        cell.thumnnailv.layer.shouldRasterize = true
        
        //titleLable.text = data?.caption
        //titleCreateLable.text = ("\(Custom.dayStringFromTime((data?.createTime!)!))")
        
        if currentSelectedIndex == indexPath.row {
            let data = self.itemsDatas[currentSelectedIndex] as? Library
            titleLable.text = data?.caption
            titleCreateLable.text = ("\(Custom.dayStringFromTime((data?.createTime!)!))")
        }else {
            let data = self.itemsDatas[currentSelectedIndex] as? Library
            titleLable.text = data?.caption
            titleCreateLable.text = ("\(Custom.dayStringFromTime((data?.createTime!)!))")
        }
        
        if let item = selectedIndexPath?.item {
            cell.thumnnailv.image = nil
            cell.thumnnailv.layer.shouldRasterize = true
            
            //titleLable.text = data?.caption
            //titleCreateLable.text = ("\(Custom.dayStringFromTime((data?.createTime!)!))")
            
            if indexPath.item == item {
                UIView.animate(withDuration: 0.3, animations: {
                    cell.thumnnailv.layer.shouldRasterize = true
                    cell.thumnnailv.transform = CGAffineTransform.init(rotationAngle: -CGFloat((.pi/4) / 8.0))
                }, completion: { (completed) in
                })
            } else {
                cell.thumnnailv.layer.shouldRasterize = true
                cell.thumnnailv.transform = CGAffineTransform.init(rotationAngle: 0.0)
            }
        } else {
            cell.thumnnailv.image = nil
            cell.thumnnailv.layer.shouldRasterize = true
            
            if indexPath.item == 0 {
                UIView.animate(withDuration: 0.3, animations: {
                    cell.thumnnailv.layer.shouldRasterize = true
                    cell.thumnnailv.transform = CGAffineTransform.init(rotationAngle: -CGFloat((.pi/4) / 8.0))
                }, completion: { (completed) in
                })
            }
        }
        downloadImage(mediapath:(data?.photo)! , cell: cell, index: indexPath.row)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // let data = self.itemsDatas[(indexPath as NSIndexPath).row] as? Library
        currentSelectedIndex = indexPath.row
        let collectioncell = collectionView.cellForItem(at: indexPath) as! MediaCollectionCell
        self.displayImage.image = collectioncell.thumnnailv.image
        collectionView.reloadData()
        
        //titleLable.text = data?.caption
        //titleCreateLable.text = ("\(Custom.dayStringFromTime((data?.createTime!)!))")
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.itemsDatas.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 80, height: 80)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        
        let flowLayout = (collectionViewLayout as! UICollectionViewFlowLayout)
        let cellSpacing = flowLayout.minimumInteritemSpacing
        let cellWidth = flowLayout.itemSize.width
        let cellCount = CGFloat(collectionView.numberOfItems(inSection: section))
        
        let collectionViewWidth = collectionView.bounds.size.width
        
        let totalCellWidth = cellCount * cellWidth
        let totalCellSpacing = cellSpacing * (cellCount - 1)
        
        let totalCellsWidth = totalCellWidth + totalCellSpacing
        
        let edgeInsets = (collectionViewWidth - totalCellsWidth) / 2.0
        
        return edgeInsets > 0 ? UIEdgeInsets.init(top: 0, left: edgeInsets, bottom: 0, right: edgeInsets) : UIEdgeInsets.init(top: 0, left: cellSpacing, bottom: 0, right: cellSpacing)
    }
    
    
    
}
