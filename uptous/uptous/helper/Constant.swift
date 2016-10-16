//
//  Constant.swift
//  uptous
//
//  Created by Roshan Gita  on 9/11/16.
//  Copyright © 2016 SPA. All rights reserved.
//

import UIKit
//https://www.uptous.com/api/posts/announcement/
//https://www.uptous.com/api/comments/feed/
//https://www.uptous.com/api/signupsheets/thin/days/365
//https://www.uptous.com/api/signupsheets/opportunity/%7bopportunityId%7d

let BASE_URL:String = "https://www.uptous.com/api/"

let LoginAPI:String = ("\(BASE_URL)auth")
let FeedAPI:String = ("\(BASE_URL)feed")
let PostReplyAPI:String = ("\(BASE_URL)posts/announcement/")
let FetchReplyAPI:String = ("\(BASE_URL)posts/announcement/")
let PostCommentAPI:String = ("\(BASE_URL)comments/feed/")
let FetchCommentAPI:String = ("\(BASE_URL)comments/feed/")
let FeedUpdateAPI:String = ("\(BASE_URL)feed/check")
let SignupListSheet: String = ("\(BASE_URL)signupsheets/thin/days/365")
let SignupItems: String = ("\(BASE_URL)signupsheets/opportunity/")


var appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate


class Constant: NSObject {

}
