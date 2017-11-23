//
//  Album.swift
//  uptous
//
//  Created by Roshan on 11/16/17.
//  Copyright © 2017 SPA. All rights reserved.
//

import UIKit

class Album: NSObject {

    var albumId: Int?
    var title: String?
    var path: String?
    var createTime: Double?
    var communityId: Int?
    
    
    init(info: NSDictionary?) {
        super.init()
        self.communityId = info?.object(forKey: "communityId") as? Int ?? 0
        
        self.albumId = info?.object(forKey: "id") as? Int ?? 0
        self.title = info?.object(forKey: "title") as? String ?? ""
        self.path = info?.object(forKey: "path") as? String ?? ""
        self.createTime = info?.object(forKey: "createTime") as? Double ?? 0
        
    }
}
