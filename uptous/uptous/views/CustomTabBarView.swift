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
        newsFeedBtn1.hidden = false
        contactsBtn1.hidden = true
        signupBtn1.hidden = true
        libraryBtn1.hidden = true
        calendarBtn1.hidden = true
    }
    
    @IBAction func newsFeedBtnClick(sender: UIButton) {
        newsFeedTapHandler?(self)
    }
    
    @IBAction func contactsBtnClick(sender: UIButton) {
        contactsTapHandler?(self)
    }
    
    @IBAction func signupBtnClick(sender: UIButton) {
        signupTapHandler?(self)
    }
    
    @IBAction func libraryBtnClick(sender: UIButton) {
        libraryTapHandler?(self)
    }
    
    @IBAction func calendarBtnClick(sender: UIButton) {
        calendarTapHandler?(self)
    }
    
    func deselectButton(){
        newsFeedBtn.setImage(UIImage(named: "tabbar1"), forState: .Normal)
        contactsBtn.setImage(UIImage(named: "tabbar2"), forState: .Normal)
        signupBtn.setImage(UIImage(named: "tabbar3"), forState: .Normal)
        libraryBtn.setImage(UIImage(named: "tabbar4"), forState: .Normal)
        calendarBtn.setImage(UIImage(named: "tabbar5"), forState: .Normal)
    }
}
