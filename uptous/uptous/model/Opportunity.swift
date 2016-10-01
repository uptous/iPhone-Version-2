//
//  Opportunity.swift
//  uptous
//
//  Created by Roshan Gita  on 9/25/16.
//  Copyright © 2016 SPA. All rights reserved.
//

import UIKit

class Opportunity: NSObject {

    var commentId: Int?
    var referenceType: String?
    var referenceId: Int?
    var communityId: Int?
    var ownerId: Int?
    var ownerName: String?
    var ownerPhotoUrl: String?
    var ownerBackgroundColor: String?
    var ownerTextColor: String?
    var createDate: Double?
    var createTime: Double?
    var modifiedDate: String?
    var body: String?
    var createdByUserName: String?
    
    init(info: NSDictionary?) {
        super.init()
        
        self.commentId = info?.objectForKey("commentId") as? Int ?? 0
        self.referenceType = info?.objectForKey("referenceType") as? String ?? ""
        self.referenceId = info?.objectForKey("referenceId") as? Int ?? 0
        self.communityId = info?.objectForKey("communityId") as? Int ?? 0
        self.ownerId = info?.objectForKey("ownerId") as? Int ?? 0
        self.ownerName = info?.objectForKey("ownerName") as? String ?? ""
        self.ownerPhotoUrl = info?.objectForKey("ownerPhotoUrl") as? String ?? ""
        self.ownerBackgroundColor = info?.objectForKey("ownerBackgroundColor") as? String ?? ""
        self.ownerTextColor = info?.objectForKey("ownerTextColor") as? String ?? ""
        self.createDate = info?.objectForKey("createDate") as? Double ?? 0
        self.createTime = info?.objectForKey("createTime") as? Double ?? 0
        self.modifiedDate = info?.objectForKey("modifiedDate") as? String ?? ""
        self.body = info?.objectForKey("body") as? String ?? ""
        self.createdByUserName = info?.objectForKey("createdByUserName") as? String ?? ""
        
    }
}

