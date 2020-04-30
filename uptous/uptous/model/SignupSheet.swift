//
//  SignupSheet.swift
//  uptous
//
//  Created by Roshan Gita  on 9/20/16.
//  Copyright © 2016 UpToUs. All rights reserved.
//

import UIKit

class SignupSheet: NSObject {
    
    var organizer1PhotoUrl: String?
    var organizer2PhotoUrl: String?
    var organizer1BackgroundColor: String?
    var organizer2BackgroundColor: String?
    var organizer1TextColor: String?
    var organizer2TextColor: String?
    
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
        self.organizer1PhotoUrl = info?.object(forKey: "organizer1PhotoUrl") as? String ?? ""
        self.organizer2PhotoUrl = info?.object(forKey: "organizer2PhotoUrl") as? String ?? ""
        self.organizer1BackgroundColor = info?.object(forKey: "organizer1BackgroundColor") as? String ?? ""
        self.organizer2BackgroundColor = info?.object(forKey: "organizer2BackgroundColor") as? String ?? ""
        self.organizer1TextColor = info?.object(forKey: "organizer1TextColor") as? String ?? ""
        self.organizer2TextColor = info?.object(forKey: "organizer2TextColor") as? String ?? ""
        
        self.contact = info?.object(forKey: "contact") as? String ?? ""
        self.contact2 = info?.object(forKey: "contact2") as? String ?? ""
        self.createDate = info?.object(forKey: "createDate") as? Double ?? 0
        self.cutoffDate = info?.object(forKey: "cutoffDate") as? Double ?? 0
        self.dateTime = info?.object(forKey: "dateTime") as? Double ?? 0
        self.endTime = info?.object(forKey: "endTime") as? String ?? ""
        self.location = info?.object(forKey: "location") as? String ?? ""
        self.name = info?.object(forKey: "name") as? String ?? ""
        self.notes = info?.object(forKey: "notes") as? String ?? ""
        self.id = info?.object(forKey: "id") as? Int ?? 0
        self.type = info?.object(forKey: "type") as? String ?? ""
        self.opportunityStatus = info?.object(forKey: "opportunityStatus") as? String ?? ""
        self.communityId = info?.object(forKey: "communityId") as? Int ?? 0
        self.createdByUserId = info?.object(forKey: "createdByUserId") as? Int ?? 0
        self.organizer1Id = info?.object(forKey: "organizer1Id") as? Int ?? 0
        self.organizer2Id = info?.object(forKey: "organizer2Id") as? Int ?? 0
        self.sortOrder = info?.object(forKey: "sortOrder") as? Int ?? 0
        self.items = info?.object(forKey: "items") as? NSArray ?? NSArray()

    }

}
