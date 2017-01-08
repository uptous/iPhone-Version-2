//
//  UserPreferences.swift
//  QuranApp
//
//  Created by Shoaib on 9/16/15.
//  Copyright (c) 2015 Cubix. All rights reserved.
//

import UIKit

class UserPreferences: NSObject {
    
    class var SelectedCommunityID: Int {
        get {
            return (UserDefaults.standard.object(forKey: "Community") as? Int) ?? 001
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "Community")
            UserDefaults.standard.synchronize()
        }
    }
    
    class var SelectedCommunityName: String {
        get {
            return (UserDefaults.standard.object(forKey: "CommunityName") as? String) ?? ""
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "CommunityName")
            UserDefaults.standard.synchronize()
        }
    }
    
    class var LoginID: String {
        get {
            return (UserDefaults.standard.object(forKey: "loginID") as? String) ?? ""
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "loginID")
            UserDefaults.standard.synchronize()
        }
    }

    class var Password: String {
        get {
            return (UserDefaults.standard.object(forKey: "pwd") as? String) ?? ""
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "pwd")
            UserDefaults.standard.synchronize()
        }
    }

    
    
}

