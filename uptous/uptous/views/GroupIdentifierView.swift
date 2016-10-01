//
//  GroupIdentifierView.swift
//  ibuzz
//
//  Created by Wahab Qamar on 23/10/2015.
//  Copyright © 2015 buzzyears. All rights reserved.
//

import UIKit

@IBDesignable
class GroupIdentifierView: UIView {

    var backgroundLayer: CAShapeLayer!
    @IBInspectable var backgroundLayerColor: UIColor = UIColor.grayColor()
    
    @IBOutlet weak var abbrLabel: UILabel!
    
    func setBackgroundLayer() {
        let lineWidth: CGFloat = 0.0
        
        if backgroundLayer == nil {
            backgroundLayer = CAShapeLayer()
            //layer.addSublayer(backgroundLayer)
            
            layer.insertSublayer(backgroundLayer, atIndex: 0)
            
            let rect = CGRectInset(bounds, lineWidth / 2.0, lineWidth / 2.0)
            let path = UIBezierPath(ovalInRect: rect)
            backgroundLayer.path = path.CGPath
            backgroundLayer.lineWidth = lineWidth
            backgroundLayer.fillColor = backgroundLayerColor.CGColor
        }
        
        backgroundLayer.frame = layer.bounds
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setBackgroundLayer()
    }
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
