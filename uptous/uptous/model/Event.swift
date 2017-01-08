//
//  Event.swift
//  uptous
//
//  Created by Upendra Narayan on 22/11/16.
//  Copyright © 2016 SPA. All rights reserved.
//

import UIKit

class Event: NSObject {
    
    
    //    allDay = 0;
    //    communityId = 486;
    //    description = Meeting;
    //    endTime = 1481270400000;
    //    id = 117468;
    //    location = "";
    //    repeatFrequency = Weekly;
    //    startTime = 1480320000000;
    //    title = "Meeting ";
    
    var title: String?
    var eventDescription: String?
    var location: String?
    var repeatFrequency: String?
    var startTime: Double?
    var endTime: Double?
    var allDay: Bool?
    var ID: Int?
    var isExpendable : Bool?
    var communityId: Int?
    
    
    init(info: NSDictionary?) {
        super.init()
        self.communityId = info?.object(forKey: "communityId") as? Int ?? 0
        self.title = info?.object(forKey: "title") as? String ?? ""
        self.eventDescription = info?.object(forKey: "description") as? String ?? ""
        self.location = info?.object(forKey: "location") as? String ?? ""
        self.repeatFrequency = info?.object(forKey: "repeatFrequency") as? String ?? ""
        self.startTime = info?.object(forKey: "startTime") as? Double
        self.endTime = info?.object(forKey: "endTime") as? Double 
        self.allDay = info?.object(forKey: "allDay") as? Bool ?? false
        self.ID = info?.object(forKey: "id") as? Int ?? 0
        self.isExpendable = true
        
    }
}

