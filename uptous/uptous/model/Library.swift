//
//  Library.swift
//  uptous
//
//  Created by Roshan Gita  on 11/9/16.
//  Copyright © 2016 UpToUs. All rights reserved.
//

import UIKit

class Library: NSObject {

    var Id: Int?
    var title: String?
    var caption: String?
    var communityId: Int?
    var createTime: Double?
    var thumb: String?
    var photo: String?
    
    init(info: NSDictionary?) {
        super.init()
        
        self.Id = info?.object(forKey: "id") as? Int ?? 0
        self.title = info?.object(forKey: "title") as? String ?? ""
        self.caption = info?.object(forKey: "caption") as? String ?? ""

        self.communityId = info?.object(forKey: "communityId") as? Int ?? 0
        self.createTime = info?.object(forKey: "createTime") as? Double ?? 0
        self.thumb = info?.object(forKey: "thumb") as? String ?? ""
        self.photo = info?.object(forKey: "photo") as? String ?? ""
        
    }

}
