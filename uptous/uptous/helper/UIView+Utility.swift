//
//  UIView+Utility.swift
//  Assess Your Relationships
//
//  Created by Shoaib on 8/18/15.
//  Copyright (c) 2015 Cubix. All rights reserved.
//

import UIKit

extension UIView {
    
    
    class func toast (messages:String) {

     let toast =    UIAlertView(title: nil, message: messages, delegate: nil, cancelButtonTitle: nil)
        
        toast.show()
        delay(2) { () -> () in
            toast.dismissWithClickedButtonIndex(0, animated: true)
        }
        
    }
    class func loadWithNib(nibName:String, viewIndex:Int, owner: AnyObject) -> AnyObject
    {
        return (NSBundle.mainBundle().loadNibNamed(nibName, owner: owner, options: nil) as NSArray).objectAtIndex(viewIndex);
    } //F.E.
    
    class func loadDynamicViewWithNib(nibName:String, viewIndex:Int, owner: AnyObject) -> AnyObject {
        
        let bundle = NSBundle(forClass: owner.dynamicType);
        let nib = UINib(nibName: nibName, bundle: bundle);
        
        // Assumes UIView is top level and only object in CustomView.xib file
        let rView: AnyObject = nib.instantiateWithOwner(owner, options: nil)[viewIndex];
        return rView;
    } //F.E.
    
    func addBorder(color:UIColor, width:Int){
        let layer:CALayer = self.layer;
        layer.borderColor=color.CGColor
        layer.borderWidth=(CGFloat(width)/CGFloat(2)) as CGFloat
    } //F.E.
    
    func addRoundedCorners() {
        self.addRoundedCorners(self.frame.size.width/2.0);
    } //F.E.
    
    func addRoundedCorners(radius:CGFloat) {
        let layer:CALayer = self.layer;
        layer.cornerRadius = radius
        layer.masksToBounds = true
    } //F.E.
    
   
    func fadeIn(animated:Bool = true) {
        if (animated) {
            self.alpha=0.0
            UIView.animateWithDuration(0.25, animations: { () -> Void in
                self.alpha=1.0
            })
        } else {
            self.alpha=1.0;
        }
    } //F.E.
    
    func fadeOut(completion:((finished:Bool)->())?) {
        self.fadeOut(true, completion: completion);
    }
    
    func fadeOut(animated:Bool, completion:((finished:Bool)->())?)
    {
        if (animated) {
            self.alpha = 1.0
            UIView.animateWithDuration(0.25, animations: { () -> Void in
                self.alpha=0.0;
                }) { (finish:Bool) -> Void in
                    completion?(finished: finish)
            }
        } else {
            self.alpha=0.0;
            completion?(finished: true);
        }
        
    } //F.E.
    
    func shake() {
        let shake:CABasicAnimation = CABasicAnimation(keyPath: "position");
        shake.duration = 0.1;
        shake.repeatCount = 2;
        shake.autoreverses = true;
        shake.fromValue = NSValue(CGPoint: CGPoint(x: self.center.x - 5, y: self.center.y));
        shake.toValue = NSValue(CGPoint: CGPoint(x: self.center.x + 5, y: self.center.y));
        self.layer.addAnimation(shake, forKey: "position");
    } //F.E.
    
    func removeAllSubviews()
    {
        for view in self.subviews {
            view.removeFromSuperview();
        }
    } //F.E.
    
} //E.E.