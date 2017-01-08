//
//  DetailsLibraryViewController.swift
//  uptous
//
//  Created by Roshan Gita  on 11/9/16.
//  Copyright © 2016 SPA. All rights reserved.
//

import UIKit

class DetailsLibraryViewController: GeneralViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var activityindicatordisplay : UIActivityIndicatorView!
    @IBOutlet weak var displayImage : UIImageView!
    @IBOutlet weak var titleLable : UILabel!
    @IBOutlet weak var titleCreateLable : UILabel!
    @IBOutlet weak var headingLable : UILabel!
    
    
    
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
    
    func swipeLeft(sender: UISwipeGestureRecognizer) -> Void {
        
        if currentSelectedIndex+1 < itemsDatas.count {
            let data = self.itemsDatas[currentSelectedIndex+1] as? Library
            
            animate(image: displayImage.image!, inLeftDirection: true)
            //currentImageView.image = images[currentSelectedIndex+1]
            //displayImage.sd_setImage(with: URL.init(string: (data?.photo)!), completed: nil)
            
            let block: SDWebImageCompletionBlock = {(image: UIImage?, error: Error?, cacheType: SDImageCacheType!, imageURL: URL?) -> Void in
                self.displayImage.image = image
            }
            displayImage.sd_setImage(with: URL(string:(data?.photo)!) as URL!, completed:block)
            

            
            currentSelectedIndex += 1
            selectedIndexPath = IndexPath(item: currentSelectedIndex, section: 0)
            collectionView.scrollToItem(at: selectedIndexPath!, at: .centeredHorizontally, animated: true)
            collectionView.reloadData()
        }
    }
    
    func swipeRight(sender: UISwipeGestureRecognizer) -> Void {
        if currentSelectedIndex-1 >= 0 {
            let data = self.itemsDatas[currentSelectedIndex-1] as? Library
            animate(image: displayImage.image!, inLeftDirection: false)
            
            let block: SDWebImageCompletionBlock = {(image: UIImage?, error: Error?, cacheType: SDImageCacheType!, imageURL: URL?) -> Void in
                self.displayImage.image = image
            }
            displayImage.sd_setImage(with: URL(string:(data?.photo)!) as URL!, completed:block)
            
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
        //self.navigationController?.popViewController(animated: true)
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
            print(response)
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
            
            let alert = UIAlertController(title: "Alert", message: "Error", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Try Again", style: UIAlertActionStyle.default, handler: nil))
            //self.present(alert, animated: true, completion: nil)
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func downloadImage(mediapath: String, cell: MediaCollectionCell, index : Int) {
        
        let block: SDWebImageCompletionBlock = {(image: UIImage?, error: Error?, cacheType: SDImageCacheType!, imageURL: URL?) -> Void in
            cell.thumnnailv.image = image
            if index == self.currentSelectedIndex {
                UIView.animate(withDuration: 0.3, animations: { () -> Void in
                    cell.transform = CGAffineTransform(rotationAngle: -CGFloat(M_PI_4 / 8.0))
                })
            }else {
                cell.transform = CGAffineTransform(rotationAngle: -0.0)
            }
            cell.activityindicator.isHidden =  true
        }
        cell.activityindicator.isHidden =  false
        cell.activityindicator.startAnimating()
        
        cell.thumnnailv.sd_setImage(with: URL(string:mediapath) as URL!, completed:block)
        
        
    }

    
    //MARK:- Collection Delegate
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: mediaphotoconstant.cellIdentifier, for: indexPath) as! MediaCollectionCell
        
        let data = self.itemsDatas[(indexPath as NSIndexPath).row] as? Library
        cell.thumnnailv.image = nil
        cell.thumnnailv.layer.shouldRasterize = true
        
        if let item = selectedIndexPath?.item {
            cell.thumnnailv.image = nil
            cell.thumnnailv.layer.shouldRasterize = true

            if indexPath.item == item {
                UIView.animate(withDuration: 0.3, animations: {
                    cell.thumnnailv.transform = CGAffineTransform.init(rotationAngle: -CGFloat(M_PI_4 / 8.0))
                    }, completion: { (completed) in
                })
            } else {
                cell.thumnnailv.transform = CGAffineTransform.init(rotationAngle: 0.0)
            }
        } else {
            cell.thumnnailv.image = nil
            cell.thumnnailv.layer.shouldRasterize = true

            if indexPath.item == 0 {
                UIView.animate(withDuration: 0.3, animations: {
                    cell.thumnnailv.transform = CGAffineTransform.init(rotationAngle: -CGFloat(M_PI_4 / 8.0))
                    }, completion: { (completed) in
                })
            }
        }
        downloadImage(mediapath:(data?.photo)! , cell: cell, index: indexPath.row)
        cell.thumnnailv.layer.shouldRasterize = true
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let data = self.itemsDatas[(indexPath as NSIndexPath).row] as? Library
        currentSelectedIndex = indexPath.row
        let collectioncell = collectionView.cellForItem(at: indexPath) as! MediaCollectionCell
        self.displayImage.image = collectioncell.thumnnailv.image
        collectionView.reloadData()
        
        titleLable.text = data?.caption
        titleCreateLable.text = ("\(Custom.dayStringFromTime((data?.createTime!)!))")
        
        /*if indexPath.item != currentSelectedIndex {
            currentSelectedIndex = indexPath.row
            selectedIndexPath = indexPath
            displayImage.sd_setImage(with: URL.init(string: (data?.photo)!) , completed: nil)
            collectionView.reloadData()
        }*/
    }

    
    /*func collectionView(_ collectionView: UICollectionView,didSelectItemAt indexPath: IndexPath) {
        
        //activityindicatordisplay.isHidden = true
        
        
        let collectioncell = self.collectionView.cellForItem(at: indexPath as IndexPath) as! MediaCollectionCell
        self.displayImage.image = collectioncell.thumnnailv.image
        
        let data = self.itemsDatas[(indexPath as NSIndexPath).row] as? Library
        
//        if let url = NSURL(string: (data?.thumb)!) {
//            if let data = NSData(contentsOf: url as URL) {
//                displayImage.image = UIImage(data: data as Data)
//            }
//        }
        titleLable.text = data?.title
        titleCreateLable.text = ("\(Custom.dayStringFromTime((data?.createTime!)!))")
    }*/
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.itemsDatas.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 120, height: 100)
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
        
        return edgeInsets > 0 ? UIEdgeInsetsMake(0, edgeInsets, 0, edgeInsets) : UIEdgeInsetsMake(0, cellSpacing, 0, cellSpacing)
    }

    
    
}
