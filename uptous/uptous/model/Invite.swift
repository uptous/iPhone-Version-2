//
//  Invite.swift
//  uptous
//
//  Created by Roshan Gita  on 12/2/16.
//  Copyright © 2016 SPA. All rights reserved.
//

import UIKit

class Invite: NSObject {

    var invitationId: Int?
    var communityName: String?
    var communityId: Int?
    
    init(info: NSDictionary?) {
        super.init()
        
        self.invitationId = info?.object(forKey: "invitationId") as? Int ?? 0
        self.communityName = info?.object(forKey: "communityName") as? String ?? ""
        self.communityId = info?.object(forKey: "communityId") as? Int ?? 0
        
    }
}
