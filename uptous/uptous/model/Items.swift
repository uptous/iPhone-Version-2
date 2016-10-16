//
//  Items.swift
//  uptous
//
//  Created by Roshan Gita  on 9/25/16.
//  Copyright © 2016 SPA. All rights reserved.
//

import UIKit

class Items: NSObject {

    var Id: Int?
    var dateTime: Double?
    var endTime: Double?
    var name: String?
    var extra: String?
    var volunteerStatus: String?
    var numVolunteers: Int?
    var volunteerCount: Int?
    var volunteers: NSArray?
    
     init(info: NSDictionary?) {
        super.init()
        
        self.Id = info?.objectForKey("id") as? Int ?? 0
        self.dateTime = info?.objectForKey("dateTime") as? Double ?? 0
        self.endTime = info?.objectForKey("endTime") as? Double ?? 0
        self.name = info?.objectForKey("name") as? String ?? ""
        self.extra = info?.objectForKey("extra") as? String ?? ""
        self.volunteerStatus = info?.objectForKey("VolunteerStatus") as? String ?? ""

        self.volunteerCount = info?.objectForKey("VolunteerCount") as? Int ?? 0

        self.numVolunteers = info?.objectForKey("numVolunteers") as? Int ?? 0
        self.volunteers = info?.objectForKey("volunteers") as? NSArray ?? NSArray()
    }
}

