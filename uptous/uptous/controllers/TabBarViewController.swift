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

        self.tabBar.isHidden = true
        tabbarView =  Bundle.main.loadNibNamed("CustomTabBarView", owner: nil, options: nil)?.first! as? CustomTabBarView
        tabbarView?.frame = CGRect(x: 0, y: self.view.frame.height - 50, width: self.view.frame.width, height: 50)
        self.view.addSubview(tabbarView!)
        //self.selectedIndex = 0
        
        //Custom Button Action
        tabbarView!.newsFeedTapHandler = {
            (firstTabBar: CustomTabBarView) in
            self.selectedIndex = 0
            
            firstTabBar.deselectButton()
            firstTabBar.newsFeedBtn.isSelected = true
            
            firstTabBar.newsFeedBtn1.isHidden = false
            firstTabBar.contactsBtn1.isHidden = true
            firstTabBar.signupBtn1.isHidden = true
            firstTabBar.libraryBtn1.isHidden = true
            firstTabBar.calendarBtn1.isHidden = true
            
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
            secondTabBar.contactsBtn.isSelected = true
            secondTabBar.newsFeedBtn1.isHidden = true
            secondTabBar.contactsBtn1.isHidden = false
            secondTabBar.signupBtn1.isHidden = true
            secondTabBar.libraryBtn1.isHidden = true
            secondTabBar.calendarBtn1.isHidden = true
        }
        
        tabbarView!.signupTapHandler = {
            (thirdTabBar: CustomTabBarView) in
            self.selectedIndex = 2
            
            thirdTabBar.deselectButton()
            thirdTabBar.signupBtn.isSelected = true
            thirdTabBar.newsFeedBtn1.isHidden = true
            thirdTabBar.contactsBtn1.isHidden = true
            thirdTabBar.signupBtn1.isHidden = false
            thirdTabBar.libraryBtn1.isHidden = true
            thirdTabBar.calendarBtn1.isHidden = true
            
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
            fourthTabBar.libraryBtn.isSelected = true
            
            fourthTabBar.newsFeedBtn1.isHidden = true
            fourthTabBar.contactsBtn1.isHidden = true
            fourthTabBar.signupBtn1.isHidden = true
            fourthTabBar.libraryBtn1.isHidden = false
            fourthTabBar.calendarBtn1.isHidden = true
        }
        
        tabbarView!.calendarTapHandler = {
            (fifthTabBar: CustomTabBarView) in
            self.selectedIndex = 4
            
           fifthTabBar.deselectButton()
           fifthTabBar.calendarBtn.isSelected = true
            
            fifthTabBar.newsFeedBtn1.isHidden = true
            fifthTabBar.contactsBtn1.isHidden = true
            fifthTabBar.signupBtn1.isHidden = true
            fifthTabBar.libraryBtn1.isHidden = true
            fifthTabBar.calendarBtn1.isHidden = false
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
