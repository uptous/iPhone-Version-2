//
//  CircularImageView.swift
//  ibuzz
//
//  Created by Wahab Qamar on 21/10/2015.
//  Copyright © 2015 buzzyears. All rights reserved.
//

import UIKit
import SDWebImage

@IBDesignable
class CircularImageView: UIView {
    
    var backgroundLayer: CAShapeLayer!
    var imageLayer: CALayer!
    
    @IBInspectable var backgroundLayerColor: UIColor = UIColor.grayColor()
    @IBInspectable var lineWidth: CGFloat = 1.0
    
    @IBInspectable var image: UIImage?
    
    func setBackgroundImageLayer() {
        
        image = UIImage(named: "default-user")
        
        if imageLayer == nil {
            let mask = CAShapeLayer()
            let dx = lineWidth + 0.0
            let path = UIBezierPath(ovalInRect: CGRectInset(self.bounds, dx, dx))
            mask.fillColor = UIColor.blackColor().CGColor
            mask.path = path.CGPath
            mask.frame = self.bounds
            layer.addSublayer(mask)
            imageLayer = CAShapeLayer()
            imageLayer.frame = self.bounds
            imageLayer.mask = mask

            imageLayer.contentsGravity = kCAGravityResizeAspectFill
            layer.addSublayer(imageLayer)
        }
        
    }
    
    func setImage() {
        if let pic = image {
            imageLayer.contents = pic.CGImage
        }
    }
    
    func setUserAvatar(avatarUrl: String) {
        let downloader = SDWebImageDownloader.sharedDownloader()
        
        downloader.downloadImageWithURL(NSURL(string: avatarUrl), options: SDWebImageDownloaderOptions.AllowInvalidSSLCertificates, progress: nil) { (image, data, error, finished) -> Void in
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                if let pic = image {
                    if self.imageLayer != nil {
                        self.imageLayer.contents = pic.CGImage
                    }
                }
            })
            
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        setBackgroundLayer()
        setBackgroundImageLayer()
        setImage()
    }
    
    func setBackgroundLayer() {
        
        if backgroundLayer == nil {
            backgroundLayer = CAShapeLayer()
            layer.addSublayer(backgroundLayer)
            let rect = CGRectInset(bounds, lineWidth / 2.0, lineWidth / 2.0)
            let path = UIBezierPath(ovalInRect: rect)
            backgroundLayer.path = path.CGPath
            backgroundLayer.lineWidth = lineWidth
            backgroundLayer.fillColor = backgroundLayerColor.CGColor
           
        }
        
        backgroundLayer.frame = layer.bounds
    }
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
