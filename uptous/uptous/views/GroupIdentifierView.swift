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
    @IBInspectable var backgroundLayerColor: UIColor = UIColor.gray
    
    @IBOutlet weak var abbrLabel: UILabel!
    
    func setBackgroundLayer() {
        let lineWidth: CGFloat = 0.0
        
        if backgroundLayer == nil {
            backgroundLayer = CAShapeLayer()
            //layer.addSublayer(backgroundLayer)
            
            layer.insertSublayer(backgroundLayer, at: 0)
            
            let rect = bounds.insetBy(dx: lineWidth / 2.0, dy: lineWidth / 2.0)
            let path = UIBezierPath(ovalIn: rect)
            backgroundLayer.path = path.cgPath
            backgroundLayer.lineWidth = lineWidth
            backgroundLayer.fillColor = backgroundLayerColor.cgColor
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
