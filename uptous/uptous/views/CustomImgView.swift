//
//  CustomImgView.swift
//  uptous
//
//  Created by Roshan Gita  on 8/19/16.
//  Copyright © 2016 SPA. All rights reserved.
//

import UIKit
import SDWebImage

@IBDesignable


class CustomImgView: UIImageView {
        let img = UIImage()
    
    class func setUserAvatar(avatarUrl: String, imgView: UIImageView) {
        let downloader = SDWebImageDownloader.sharedDownloader()
    
        downloader.downloadImageWithURL(NSURL(string: avatarUrl), options: SDWebImageDownloaderOptions.AllowInvalidSSLCertificates, progress: nil) { (image, data, error, finished) -> Void in
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                if let pic = image {
                    imgView.image = pic
                }
            })
            
        }
    }
}
