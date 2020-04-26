//
//  CustomTabBarView.swift
//  uptous
//
//  Created by Roshan Gita  on 8/14/16.
//  Copyright © 2016 SPA. All rights reserved.
//

import UIKit

class CustomTabBarView: UIView {
    
    @IBOutlet var newsFeedBtn: UIButton!
    @IBOutlet var contactsBtn: UIButton!
    @IBOutlet var signupBtn: UIButton!
    @IBOutlet var libraryBtn: UIButton!
    @IBOutlet var calendarBtn: UIButton!
    @IBOutlet var newsFeedBtn1: UIButton!
    @IBOutlet var contactsBtn1: UIButton!
    @IBOutlet var signupBtn1: UIButton!
    @IBOutlet var libraryBtn1: UIButton!
    @IBOutlet var calendarBtn1: UIButton!
    
    var newsFeedTapHandler: ((CustomTabBarView)->())?
    var contactsTapHandler: ((CustomTabBarView)->())?
    var signupTapHandler: ((CustomTabBarView)->())?
    var libraryTapHandler: ((CustomTabBarView)->())?
    var calendarTapHandler: ((CustomTabBarView)->())?
    
    override func awakeFromNib() {
        newsFeedBtn1.isHidden = false
        contactsBtn1.isHidden = true
        signupBtn1.isHidden = true
        libraryBtn1.isHidden = true
        calendarBtn1.isHidden = true
    }
    
    @IBAction func newsFeedBtnClick(_ sender: UIButton) {
        newsFeedTapHandler?(self)
    }
    
    @IBAction func contactsBtnClick(_ sender: UIButton) {
        contactsTapHandler?(self)
    }
    
    @IBAction func signupBtnClick(_ sender: UIButton) {
        signupTapHandler?(self)
    }
    
    @IBAction func libraryBtnClick(_ sender: UIButton) {
        libraryTapHandler?(self)
    }
    
    @IBAction func calendarBtnClick(_ sender: UIButton) {
        calendarTapHandler?(self)
    }
    
    func deselectButton(){
        newsFeedBtn.setImage(UIImage(named: "tabbar1"), for: UIControl.State())
        contactsBtn.setImage(UIImage(named: "tabbar2"), for: UIControl.State())
        signupBtn.setImage(UIImage(named: "tabbar3"), for: UIControl.State())
        libraryBtn.setImage(UIImage(named: "tabbar4"), for: UIControl.State())
        calendarBtn.setImage(UIImage(named: "tabbar5"), for: UIControl.State())
    }
}
