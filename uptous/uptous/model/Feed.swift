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
    var modifiedDate: Double?
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
        
        self.feedId = info?.object(forKey: "feedId") as? Int ?? 0
        self.communityId = info?.object(forKey: "communityId") as? Int ?? 0
        self.ownerId = info?.object(forKey: "ownerId") as? Int ?? 0
        self.ownerName = info?.object(forKey: "ownerName") as? String ?? ""
        self.ownerPhotoUrl = info?.object(forKey: "ownerPhotoUrl") as? String ?? ""
        self.ownerBackgroundColor = info?.object(forKey: "ownerBackgroundColor") as? String ?? ""
        self.ownerTextColor = info?.object(forKey: "ownerTextColor") as? String ?? ""
        self.createDate = info?.object(forKey: "createDate") as? Double ?? 0
        self.modifiedDate = info?.object(forKey: "modifiedDate") as? Double ?? 0
        self.communityName = info?.object(forKey: "communityName") as? String ?? ""
        self.communityLogoUrl = info?.object(forKey: "communityLogoUrl") as? String ?? ""
        self.communityBackgroundColor = info?.object(forKey: "communityBackgroundColor") as? String ?? ""
        self.communityTextColor = info?.object(forKey: "communityTextColor") as? String ?? ""
        self.communityName = info?.object(forKey: "communityName") as? String ?? ""
        self.newsType = info?.object(forKey: "newsType") as? String ?? ""
        self.newsItemId = info?.object(forKey: "newsItemId") as? Int ?? 0
        self.newsItemIndex = info?.object(forKey: "newsItemIndex") as? String ?? ""
        self.newsItemName = info?.object(forKey: "newsItemName") as? String ?? ""
        self.newsItemDescription = info?.object(forKey: "newsItemDescription") as? String ?? ""
        self.newsItemUrl = info?.object(forKey: "newsItemUrl") as? String ?? ""
        self.newsItemPhoto = info?.object(forKey: "newsItemPhoto") as? String ?? ""
        self.ownerEmail = info?.object(forKey: "ownerEmail") as? String ?? ""
        self.comments = info?.object(forKey: "comments") as? NSArray ?? []
        
    }
}
