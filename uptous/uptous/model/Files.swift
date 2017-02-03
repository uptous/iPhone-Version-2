//
//  Files.swift
//  uptous
//
//  Created by Roshan Gita  on 11/20/16.
//  Copyright © 2016 SPA. All rights reserved.
//

import UIKit

class Files: NSObject {

    var Id: Int?
    var title: String?
    var path: String?
    var createDate: Double?
    var communityId: Int?

    
    init(info: NSDictionary?) {
        super.init()
        self.communityId = info?.object(forKey: "communityId") as? Int ?? 0

        self.Id = info?.object(forKey: "id") as? Int ?? 0
        self.title = info?.object(forKey: "title") as? String ?? ""
        self.path = info?.object(forKey: "path") as? String ?? ""
        self.createDate = info?.object(forKey: "createDate") as? Double ?? 0
        
    }
    

}
