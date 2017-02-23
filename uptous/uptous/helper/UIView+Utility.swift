//
//  UIView+Utility.swift
//  Assess Your Relationships
//
//  Created by Shoaib on 8/18/15.
//  Copyright (c) 2015 Cubix. All rights reserved.
//

import UIKit

extension UIView {
    
    
    class func toast (_ messages:String) {

     let toast =    UIAlertView(title: nil, message: messages, delegate: nil, cancelButtonTitle: nil)
        
        toast.show()
        delay(2) { () -> () in
            toast.dismiss(withClickedButtonIndex: 0, animated: true)
        }
        
    }
//    class func loadWithNib(_ nibName:String, viewIndex:Int, owner: AnyObject) -> AnyObject
//    {
//        return ((Bundle.main.loadNibNamed(nibName, owner: owner, options: nil) as Any) as AnyObject).object(at: viewIndex);
//    } //F.E.
    
    class func loadDynamicViewWithNib(_ nibName:String, viewIndex:Int, owner: AnyObject) -> AnyObject {
        
        let bundle = Bundle(for: type(of: owner));
        let nib = UINib(nibName: nibName, bundle: bundle);
        
        // Assumes UIView is top level and only object in CustomView.xib file
        let rView: AnyObject = nib.instantiate(withOwner: owner, options: nil)[viewIndex] as AnyObject;
        return rView;
    } //F.E.
    
    func addBorder(_ color:UIColor, width:Int){
        let layer:CALayer = self.layer;
        layer.borderColor=color.cgColor
        layer.borderWidth=(CGFloat(width)/CGFloat(2)) as CGFloat
    } //F.E.
    
    func addRoundedCorners() {
        self.addRoundedCorners(self.frame.size.width/2.0);
    } //F.E.
    
    func addRoundedCorners(_ radius:CGFloat) {
        let layer:CALayer = self.layer;
        layer.cornerRadius = radius
        layer.masksToBounds = true
    } //F.E.
    
   
    func fadeIn(_ animated:Bool = true) {
        if (animated) {
            self.alpha=0.0
            UIView.animate(withDuration: 0.25, animations: { () -> Void in
                self.alpha=1.0
            })
        } else {
            self.alpha=1.0;
        }
    } //F.E.
    
    func fadeOut(_ completion:((_ finished:Bool)->())?) {
        self.fadeOut(true, completion: completion);
    }
    
    func fadeOut(_ animated:Bool, completion:((_ finished:Bool)->())?)
    {
        if (animated) {
            self.alpha = 1.0
            UIView.animate(withDuration: 0.25, animations: { () -> Void in
                self.alpha=0.0;
                }, completion: { (finish:Bool) -> Void in
                    completion?(finish)
            }) 
        } else {
            self.alpha=0.0;
            completion?(true);
        }
        
    } //F.E.
    
    func shake() {
        let shake:CABasicAnimation = CABasicAnimation(keyPath: "position");
        shake.duration = 0.1;
        shake.repeatCount = 2;
        shake.autoreverses = true;
        shake.fromValue = NSValue(cgPoint: CGPoint(x: self.center.x - 5, y: self.center.y));
        shake.toValue = NSValue(cgPoint: CGPoint(x: self.center.x + 5, y: self.center.y));
        self.layer.add(shake, forKey: "position");
    } //F.E.
    
    func removeAllSubviews()
    {
        for view in self.subviews {
            view.removeFromSuperview();
        }
    } //F.E.
    
} //E.E.
