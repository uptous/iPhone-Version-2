//
//  CustomImgView.swift
//  uptous
//
//  Created by Roshan Gita  on 8/19/16.
//  Copyright © 2016 UpToUs. All rights reserved.
//

import UIKit
//import SDWebImage

@IBDesignable


class CustomImgView: UIImageView {
        let img = UIImage()
    
    class func setUserAvatar(_ avatarUrl: String, imgView: UIImageView) {
        let downloader = SDWebImageDownloader.shared()
    
        downloader?.downloadImage(with: URL(string: avatarUrl), options: SDWebImageDownloaderOptions.allowInvalidSSLCertificates, progress: nil) { (image, data, error, finished) -> Void in
            DispatchQueue.main.async(execute: { () -> Void in
                if let pic = image {
                    imgView.image = pic
                }
            })
            
        }
    }
}
