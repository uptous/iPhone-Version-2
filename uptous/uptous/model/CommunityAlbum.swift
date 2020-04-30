//
//  CommunityAlbum.swift
//  uptous
//
//  Created by Roshan on 10/31/17.
//  Copyright © 2017 UpToUs. All rights reserved.
//

import UIKit

class CommunityAlbum: NSObject {

    var communityId: Int?
    var Id: Int?
    var createTime: String?
    var thumb: String?
    var title: String?
    
    init(info: NSDictionary?) {
        super.init()
        self.communityId = info?.object(forKey: "communityId") as? Int ?? 0
        self.Id = info?.object(forKey: "id") as? Int ?? 0
        self.createTime = info?.object(forKey: "createTime") as? String ?? ""
        self.thumb = info?.object(forKey: "thumb") as? String ?? ""
        self.title = info?.object(forKey: "title") as? String ?? ""
    }
}
