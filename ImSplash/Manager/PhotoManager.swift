//
//  PhotoManager.swift
//  ImSplash
//
//  Created by Nguyen Vu Hao on 5/12/20.
//  Copyright © 2020 Nguyen Vu Hao. All rights reserved.
//

import ObjectMapper

typealias PhotosResponseBlock = ([SplashImage]?, WebAPI.Response?) -> ()

protocol PhotoWebAPIProtocol {
    func requestPhotos(page: Int, complete: PhotosResponseBlock?)
}

final class PhotoWebAPI: WebAPI {
    private enum URLPath: String {
        case requestPhotoList = "https://api.unsplash.com/photos"
    }
}

extension PhotoWebAPI: PhotoWebAPIProtocol {
    func requestPhotos(page: Int, complete: PhotosResponseBlock?) {
        guard let url = URL(string: URLPath.requestPhotoList.rawValue) else { return }
        urlQueryParameters.add(value: "\(page)", forKey: "page")
        urlQueryParameters.add(value: "L6PMVSiY1LK8d5ai2Y2GN4VBNy-eU1LkQxMM284PpN8", forKey: "client_id")
        makeRequest(toURL: url, withHttpMethod: .get, completion: { result in
            var photos: [SplashImage]?
            if let data = result.data {
                photos = data.getObjectList(key: nil)
            }
            complete?(photos, result.response)
        })
    }
}

final class PhotoManager {
    private let webAPI: PhotoWebAPIProtocol
    
    init(webAPI: PhotoWebAPIProtocol) {
        self.webAPI = webAPI
    }
    
    func requestPhotos(page: Int, complete: PhotosResponseBlock?) {
        self.webAPI.requestPhotos(page: page, complete: complete)
    }
}
