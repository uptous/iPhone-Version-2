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
        
        self.Id = info?.object(forKey: "id") as? Int ?? 0
        self.dateTime = info?.object(forKey: "dateTime") as? Double ?? 0
        self.endTime = info?.object(forKey: "endTime") as? Double ?? 0
        self.name = info?.object(forKey: "name") as? String ?? ""
        self.extra = info?.object(forKey: "extra") as? String ?? ""
        self.volunteerStatus = info?.object(forKey: "VolunteerStatus") as? String ?? ""

        self.volunteerCount = info?.object(forKey: "VolunteerCount") as? Int ?? 0

        self.numVolunteers = info?.object(forKey: "numVolunteers") as? Int ?? 0
        self.volunteers = info?.object(forKey: "volunteers") as? NSArray ?? NSArray()
    }
}

