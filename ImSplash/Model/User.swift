//
//  User.swift
//  ImSplash
//
//  Created by Nguyen Vu Hao on 5/14/20.
//  Copyright © 2020 Nguyen Vu Hao. All rights reserved.
//

import ObjectMapper

class User: Mappable {
    var id: String?
    var username: String?
    var twitterName: String?
    var instagram: String?
    var profileImage: String?
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        username <- map["username"]
        twitterName <- map["twitter_username"]
        instagram <- map["instagram_username"]
        profileImage <- map["profile_image.medium"]
    }
}
