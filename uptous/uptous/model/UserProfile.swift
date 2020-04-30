//
//  UserProfile.swift
//  uptous
//
//  Created by Roshan Gita  on 12/1/16.
//  Copyright © 2016 UpToUs. All rights reserved.
//

import UIKit

class UserProfile: NSObject {
    
    var firstName: String?
    var lastName: String?
    var email: String?
    var phone: String?
    var photo: String?
    
    
    init(info: NSDictionary?) {
        super.init()
        
        self.firstName = info?.object(forKey: "firstName") as? String ?? ""
        self.lastName = info?.object(forKey: "lastName") as? String ?? ""
        self.email = info?.object(forKey: "email") as? String ?? ""
        self.phone = info?.object(forKey: "phone") as? String ?? ""
        self.photo = info?.object(forKey: "photo") as? String ?? ""
    }
}
