//
//  Community.swift
//  uptous
//
//  Created by Roshan Gita  on 11/13/16.
//  Copyright © 2016 UpToUs. All rights reserved.
//

import UIKit

class Community: NSObject {

    var communityId: Int?
    var name: String?
    var country: String?
    var zipCode: String?
    var state: String?
    var city: String?
    var address: String?
    var communityDescription: String?
    
    init(info: NSDictionary?) {
        super.init()
        
        self.communityId = info?.object(forKey: "id") as? Int ?? 0

        self.name = info?.object(forKey: "name") as? String ?? ""
        self.communityDescription = info?.object(forKey: "description") as? String ?? ""
        self.country = info?.object(forKey: "country") as? String ?? ""
        self.zipCode = info?.object(forKey: "zipCode") as? String ?? ""
        self.state = info?.object(forKey: "state") as? String ?? ""
        self.city = info?.object(forKey: "city") as? String ?? ""
        self.address = info?.object(forKey: "address") as? String ?? ""
        
    }
    

}
