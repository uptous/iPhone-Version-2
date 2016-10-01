//
//  SignupSheet.swift
//  uptous
//
//  Created by Roshan Gita  on 9/20/16.
//  Copyright © 2016 SPA. All rights reserved.
//

import UIKit

class SignupSheet: NSObject {
    var contact: String?
    var contact2: String?
    var dateTime: Double?
    var cutoffDate: Double?
    var endTime: String?
    var location: String?
    var name: String?
    var notes: String?
    var id: Int?
    var type: String?
    var opportunityStatus: String?
    var communityId: Int?
    var createdByUserId: Int?
    var organizer1Id: Int?
    var organizer2Id: Int?
    var createDate: Double? //256019
    var sortOrder: Int?
    var items: NSArray?
    
    init(info: NSDictionary?) {
        super.init()
        
        self.contact = info?.objectForKey("contact") as? String ?? ""
        self.contact2 = info?.objectForKey("contact2") as? String ?? ""
        self.dateTime = info?.objectForKey("dateTime") as? Double ?? 0
        self.cutoffDate = info?.objectForKey("cutoffDate") as? Double ?? 0
        self.endTime = info?.objectForKey("endTime") as? String ?? ""
        self.location = info?.objectForKey("location") as? String ?? ""
        self.name = info?.objectForKey("name") as? String ?? ""
        self.notes = info?.objectForKey("notes") as? String ?? ""
        self.id = info?.objectForKey("id") as? Int ?? 0
        self.type = info?.objectForKey("type") as? String ?? ""
        self.opportunityStatus = info?.objectForKey("opportunityStatus") as? String ?? ""
        self.communityId = info?.objectForKey("communityId") as? Int ?? 0
        self.createdByUserId = info?.objectForKey("createdByUserId") as? Int ?? 0
        self.organizer1Id = info?.objectForKey("organizer1Id") as? Int ?? 0
        self.organizer2Id = info?.objectForKey("organizer2Id") as? Int ?? 0
        self.createDate = info?.objectForKey("createDate") as? Double ?? 0
        self.sortOrder = info?.objectForKey("sortOrder") as? Int ?? 0
        self.items = info?.objectForKey("items") as? NSArray ?? NSArray()

    }

}
