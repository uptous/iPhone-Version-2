//
//  Constant.swift
//  uptous
//
//  Created by Roshan Gita  on 9/11/16.
//  Copyright © 2016 UpToUs. All rights reserved.
//

import UIKit
//https://www.uptous.com/api/posts/announcement/
//https://www.uptous.com/api/comments/feed/
//https://www.uptous.com/api/signupsheets/thin/days/365
//https://www.uptous.com/api/signupsheets/opportunity/%7bopportunityId%7d
//https://www.uptous.com/api/attachment/days/30


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
let Members: String = ("\(BASE_URL)members")
let PhotoLibrary: String = ("\(BASE_URL)photoalbums")
let AlbumLibrary: String = ("\(BASE_URL)photothumbs/album/")
let TopMenuCommunity: String = ("\(BASE_URL)communities")
let FetchAllFiles: String = ("\(BASE_URL)attachment/days/3650")
let PostMessage: String = ("\(BASE_URL)messages/community/")
let PostImageMessage: String = ("\(BASE_URL)photoalbums/community/")
let EventAPI: String = ("\(BASE_URL)events/365")
let Profile: String = ("\(BASE_URL)profile")
let UpdateProfile: String = ("\(BASE_URL)profile/update")
let Invites: String = ("\(BASE_URL)invites")
let AcceptInvite: String = ("\(BASE_URL)invites/")
let TotalContacts: String = ("\(BASE_URL)members/total")
let ContactUpdateAPI:String = ("\(BASE_URL)members/check")
let SignUpAPI:String = "https://www.uptous.com/communitySignup/"
let FetchAlbumAPI:String = ("\(BASE_URL)photoalbums/community/")

var GoogleAPIKey = "AIzaSyAntqo4DuWKlv2Ah9ac4LTurSsXEYEGdwg"
var appDelegate = UIApplication.shared.delegate as! AppDelegate


class Constant: NSObject {

}
