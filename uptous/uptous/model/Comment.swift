//
//  Comment.swift
//  uptous
//
//  Created by Roshan Gita  on 8/14/16.
//  Copyright © 2016 SPA. All rights reserved.
//

import UIKit

class Comment: NSObject {

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
        
        self.commentId = info?.object(forKey: "commentId") as? Int ?? 0
        self.referenceType = info?.object(forKey: "referenceType") as? String ?? ""
        self.referenceId = info?.object(forKey: "referenceId") as? Int ?? 0
        self.communityId = info?.object(forKey: "communityId") as? Int ?? 0
        self.ownerId = info?.object(forKey: "ownerId") as? Int ?? 0
        self.ownerName = info?.object(forKey: "ownerName") as? String ?? ""
        self.ownerPhotoUrl = info?.object(forKey: "ownerPhotoUrl") as? String ?? ""
        self.ownerBackgroundColor = info?.object(forKey: "ownerBackgroundColor") as? String ?? ""
        self.ownerTextColor = info?.object(forKey: "ownerTextColor") as? String ?? ""
        self.createDate = info?.object(forKey: "createDate") as? Double ?? 0
        self.createTime = info?.object(forKey: "createTime") as? Double ?? 0
        self.modifiedDate = info?.object(forKey: "modifiedDate") as? String ?? ""
        self.body = info?.object(forKey: "body") as? String ?? ""
        self.createdByUserName = info?.object(forKey: "createdByUserName") as? String ?? ""

    }
}
