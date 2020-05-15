//
//  SplashImage.swift
//  ImSplash
//
//  Created by Nguyen Vu Hao on 5/11/20.
//  Copyright © 2020 Nguyen Vu Hao. All rights reserved.
//

import ObjectMapper

struct SplashImage: Mappable {
    
    var id: String?
    var width: CGFloat = 0
    var heigh: CGFloat = 0
    var urlRaw: String?
    var urlFull: String?
    var urlSmall: String?
    var thumb: String?
    var linkDownload: String?
    var user: User?
    var liked = false
    var imageData: Data?
    var state = PhotoRecordState.new
    
    init?(map: Map) { }
    
    init(model: PhotoModel) {
        id = model.id
        imageData = model.imageData
        width = CGFloat(model.width)
        heigh = CGFloat(model.height)
    }
    
    mutating func mapping(map: Map) {
        id <- map["id"]
        urlFull <- map["urls.full"]
        urlSmall <- map["urls.small"]
        linkDownload <- map["links.download"]
        width <- map["width"]
        heigh <- map["height"]
        thumb <- map["urls.thumb"]
        user <- map["user"]
    }
    
    var ratio: CGFloat {
        get {
            width/heigh
        }
    }
    
    mutating func updateLike(with status: Bool) {
        liked = status
    }
    
    mutating func updateState(state: PhotoRecordState) {
        self.state = state
    }
}
