//
//  CollectionCell.swift
//  CollectionDemo
//
//  Created by Yogendra Singh on 11/8/16.
//  Copyright © 2016 Vertual Employee. All rights reserved.
//

import UIKit

class CollectionCell: UICollectionViewCell {
    
    
    @IBOutlet weak var albumNameLabel: UILabel!
    @IBOutlet weak var fileNameLabel: UILabel!
    @IBOutlet weak var albumView: UIView!
    @IBOutlet weak var fileView: UIView!
    @IBOutlet weak var albumImgView: UIImageView!
    
    func updateView(_ data: Library) {
       
        albumImgView.layer.cornerRadius = 8.0
        albumImgView.layer.masksToBounds = true
        
        albumView.layer.borderColor = UIColor.lightGray.cgColor
        albumView.layer.borderWidth = 1.5
        albumView.layer.cornerRadius = 10.0
        
        fileView.layer.borderColor = UIColor.lightGray.cgColor
        fileView.layer.borderWidth = 1.5
        fileView.layer.cornerRadius = 10.0
        fileView.isHidden = true
        albumView.isHidden = false
        
        albumNameLabel.text = ("\(data.title!.removingPercentEncoding!)")
        
        let block: SDWebImageCompletionBlock = {(image: UIImage?, error: Error?, cacheType: SDImageCacheType!, imageURL: URL?) -> Void in
            self.albumImgView.image = image
        }
        //albumImgView.sd_setImage(with: URL(string:data.thumb!) as URL!, completed:block)
        let url = URL(string: data.thumb!)
        albumImgView.sd_setImage(with: url, completed: block)
    }
    
    func fileUpdateView(_ data: Files) {
        
        fileView.isHidden = false
        albumView.isHidden = true
        fileNameLabel.text = ("\(data.title!)")
    }
}


