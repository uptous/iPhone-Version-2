//
//  CircularImageView.swift
//  ibuzz
//
//  Created by Wahab Qamar on 21/10/2015.
//  Copyright © 2015 buzzyears. All rights reserved.
//

import UIKit
//import SDWebImage

@IBDesignable
class CircularImageView: UIView {
    
    var backgroundLayer: CAShapeLayer!
    var imageLayer: CALayer!
    
    @IBInspectable var backgroundLayerColor: UIColor = UIColor.white
    @IBInspectable var lineWidth: CGFloat = 0.5
    
    @IBInspectable var image: UIImage?
    
    func setBackgroundImageLayer() {
        
        image = UIImage(named: "default-user")
        
        if imageLayer == nil {
            let mask = CAShapeLayer()
            let dx = lineWidth + 0.0
            let path = UIBezierPath(ovalIn: self.bounds.insetBy(dx: dx, dy: dx))
            mask.fillColor = UIColor.black.cgColor
            mask.path = path.cgPath
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
            imageLayer.contents = pic.cgImage
        }
    }
    
    func setUserAvatar(_ avatarUrl: String) {
        let downloader = SDWebImageDownloader.shared()
        
        downloader?.downloadImage(with: URL(string: avatarUrl), options: SDWebImageDownloaderOptions.allowInvalidSSLCertificates, progress: nil) { (image, data, error, finished) -> Void in
            DispatchQueue.main.async(execute: { () -> Void in
                if let pic = image {
                    if self.imageLayer != nil {
                        self.imageLayer.contents = pic.cgImage
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
            let rect = bounds.insetBy(dx: lineWidth / 2.0, dy: lineWidth / 2.0)
            let path = UIBezierPath(ovalIn: rect)
            backgroundLayer.path = path.cgPath
            backgroundLayer.lineWidth = lineWidth
            //backgroundLayer.fillColor = backgroundLayerColor.cgColor
           
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
