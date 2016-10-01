//
//  TabBarViewController.swift
//  PlaceFinder
//
//  Created by Abdul on 5/5/16.
//  Copyright © 2016 Virtual Employee Pvt Ltd. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {

    var tabbarView: CustomTabBarView?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tabBar.hidden = true
        tabbarView =  NSBundle.mainBundle().loadNibNamed("CustomTabBarView", owner: nil, options: nil).first! as? CustomTabBarView
        tabbarView?.frame = CGRectMake(0, CGRectGetHeight(self.view.frame) - 50, CGRectGetWidth(self.view.frame), 50)
        self.view.addSubview(tabbarView!)
        //self.selectedIndex = 0
        
        //Custom Button Action
        tabbarView!.newsFeedTapHandler = {
            (firstTabBar: CustomTabBarView) in
            self.selectedIndex = 0
            
            firstTabBar.deselectButton()
            firstTabBar.newsFeedBtn.selected = true
            
            firstTabBar.newsFeedBtn1.hidden = false
            firstTabBar.contactsBtn1.hidden = true
            firstTabBar.signupBtn1.hidden = true
            firstTabBar.libraryBtn1.hidden = true
            firstTabBar.calendarBtn1.hidden = true
            
            /*let vc = self.viewControllers![0] as! MyUpToUsFeedViewController
            vc.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            
            appDelegate.window?.rootViewController?.view.addSubview(vc.view)
            appDelegate.window?.rootViewController?.view.bringSubviewToFront(vc.view)*/
        }
        
        tabbarView!.contactsTapHandler = {
            (secondTabBar: CustomTabBarView) in
            self.selectedIndex = 1
            
            secondTabBar.deselectButton()
            secondTabBar.contactsBtn.selected = true
            secondTabBar.newsFeedBtn1.hidden = true
            secondTabBar.contactsBtn1.hidden = false
            secondTabBar.signupBtn1.hidden = true
            secondTabBar.libraryBtn1.hidden = true
            secondTabBar.calendarBtn1.hidden = true
        }
        
        tabbarView!.signupTapHandler = {
            (thirdTabBar: CustomTabBarView) in
            self.selectedIndex = 2
            
            thirdTabBar.deselectButton()
            thirdTabBar.signupBtn.selected = true
            thirdTabBar.newsFeedBtn1.hidden = true
            thirdTabBar.contactsBtn1.hidden = true
            thirdTabBar.signupBtn1.hidden = false
            thirdTabBar.libraryBtn1.hidden = true
            thirdTabBar.calendarBtn1.hidden = true
            
//            let vc = self.viewControllers![2] as! MyUpToUsSignUpViewController
//            vc.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)
//            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
//            
//            appDelegate.window?.rootViewController?.view.addSubview(vc.view)
//            appDelegate.window?.rootViewController?.view.bringSubviewToFront(vc.view)
        }
        
        tabbarView!.libraryTapHandler = {
            (fourthTabBar: CustomTabBarView) in
            self.selectedIndex = 3
            
            fourthTabBar.deselectButton()
            fourthTabBar.libraryBtn.selected = true
            
            fourthTabBar.newsFeedBtn1.hidden = true
            fourthTabBar.contactsBtn1.hidden = true
            fourthTabBar.signupBtn1.hidden = true
            fourthTabBar.libraryBtn1.hidden = false
            fourthTabBar.calendarBtn1.hidden = true
        }
        
        tabbarView!.calendarTapHandler = {
            (fifthTabBar: CustomTabBarView) in
            self.selectedIndex = 4
            
           fifthTabBar.deselectButton()
           fifthTabBar.calendarBtn.selected = true
            
            fifthTabBar.newsFeedBtn1.hidden = true
            fifthTabBar.contactsBtn1.hidden = true
            fifthTabBar.signupBtn1.hidden = true
            fifthTabBar.libraryBtn1.hidden = true
            fifthTabBar.calendarBtn1.hidden = false
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
