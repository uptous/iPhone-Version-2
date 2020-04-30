//
//  Contacts.swift
//  uptous
//
//  Created by Roshan Gita  on 10/25/16.
//  Copyright © 2016 UpToUs. All rights reserved.
//

import UIKit

class Contacts: NSObject {

    var firstName: String?
    var lastName: String?
    var address: String?
    var city: String?
    var state: String?
    var zipcode: String?
    var country: String?
    var email: String?
    var website: String?
    var phone: String?
    var photo: String?
    var mobile: String?
    var memberBackgroundColor: String?
    var memberTextColor: String?
    var children: NSArray?
    var communities: Array<Community>?
    var isExpendable : Bool?
    
    init(info: NSDictionary?) {
        super.init()
        
        self.firstName = info?.object(forKey: "firstName") as? String ?? ""
        self.lastName = info?.object(forKey: "lastName") as? String ?? ""
        self.address = info?.object(forKey: "address") as? String ?? ""
        self.city = info?.object(forKey: "city") as? String ?? ""
        self.state = info?.object(forKey: "state") as? String ?? ""
        self.zipcode = info?.object(forKey: "zipcode") as? String ?? ""
        self.country = info?.object(forKey: "country") as? String ?? ""
        self.email = info?.object(forKey: "email") as? String ?? ""
        self.website = info?.object(forKey: "website") as? String ?? ""
        self.phone = info?.object(forKey: "phone") as? String ?? ""
        self.mobile = info?.object(forKey: "mobile") as? String ?? ""

        self.photo = info?.object(forKey: "photo") as? String ?? ""
        self.memberBackgroundColor = info?.object(forKey: "memberBackgroundColor") as? String ?? ""
        self.memberTextColor = info?.object(forKey: "memberTextColor") as? String ?? ""
        self.children = info?.object(forKey: "children") as? NSArray
        self.communities = info?.object(forKey: "communities") as! Array<Community>? 
        self.isExpendable = false

    }

}
