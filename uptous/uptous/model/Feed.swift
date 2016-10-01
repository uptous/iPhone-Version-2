//
//  Feed.swift
//  uptous
//
//  Created by Roshan Gita  on 8/14/16.
//  Copyright © 2016 SPA. All rights reserved.
//

import UIKit

class Feed: NSObject {
    var feedId: Int?
    var communityId: Int?
    var ownerId: Int?
    var ownerName: String?
    var ownerPhotoUrl: String?
    var ownerBackgroundColor: String?
    var ownerTextColor: String?
    var createDate: Double?
    var modifiedDate: String?
    var communityName: String?
    var communityLogoUrl: String?
    var communityBackgroundColor: String?
    var communityTextColor: String?
    var newsType: String?
    var newsItemId: Int?
    var newsItemIndex: String?
    var newsItemName: String?
    var newsItemDescription: String?
    var newsItemUrl: String?
    var newsItemPhoto: String?
    var ownerEmail: String?
    var comments: NSArray?
    
    init(info: NSDictionary?) {
        super.init()
        
        self.feedId = info?.objectForKey("feedId") as? Int ?? 0
        self.communityId = info?.objectForKey("communityId") as? Int ?? 0
        self.ownerId = info?.objectForKey("ownerId") as? Int ?? 0
        self.ownerName = info?.objectForKey("ownerName") as? String ?? ""
        self.ownerPhotoUrl = info?.objectForKey("ownerPhotoUrl") as? String ?? ""
        self.ownerBackgroundColor = info?.objectForKey("ownerBackgroundColor") as? String ?? ""
        self.ownerTextColor = info?.objectForKey("ownerTextColor") as? String ?? ""
        self.createDate = info?.objectForKey("createDate") as? Double ?? 0
        self.modifiedDate = info?.objectForKey("modifiedDate") as? String ?? ""
        self.communityName = info?.objectForKey("communityName") as? String ?? ""
        self.communityLogoUrl = info?.objectForKey("communityLogoUrl") as? String ?? ""
        self.communityBackgroundColor = info?.objectForKey("communityBackgroundColor") as? String ?? ""
        self.communityTextColor = info?.objectForKey("communityTextColor") as? String ?? ""
        self.communityName = info?.objectForKey("communityName") as? String ?? ""
        self.newsType = info?.objectForKey("newsType") as? String ?? ""
        self.newsItemId = info?.objectForKey("newsItemId") as? Int ?? 0
        self.newsItemIndex = info?.objectForKey("newsItemIndex") as? String ?? ""
        self.newsItemName = info?.objectForKey("newsItemName") as? String ?? ""
        self.newsItemDescription = info?.objectForKey("newsItemDescription") as? String ?? ""
        self.newsItemUrl = info?.objectForKey("newsItemUrl") as? String ?? ""
        self.newsItemPhoto = info?.objectForKey("newsItemPhoto") as? String ?? ""
        self.ownerEmail = info?.objectForKey("ownerEmail") as? String ?? ""
        self.comments = info?.objectForKey("comments") as? NSArray ?? []
        
    }
}
