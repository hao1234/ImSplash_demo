//
//  DownloadManager.swift
//  ImSplash
//
//  Created by Nguyen Vu Hao on 5/14/20.
//  Copyright © 2020 Nguyen Vu Hao. All rights reserved.
//

import UIKit

class DownloadManager {
    var photos: [SplashImage] = []
    var downloadsInProgress: [String: ImageDownloader] = [:]
    
    func getListPhotoDownloaded() -> [SplashImage] {
        guard let dataList = DataManager.sharedInstance.getPhotoDownloaded() else {
            return []
        }
        
        let recheckDataList: [SplashImage] = dataList.map {
            var newModel = $0
            newModel.updateState(state: .downloaded)
            return newModel
        }
        photos = recheckDataList
        return recheckDataList
    }
    
    func addPhotoToDownload(photo: SplashImage) {
        guard downloadsInProgress[photo.id ?? ""] == nil else {
          return
        }
        DataManager.sharedInstance.savePhoto(with: photo, image: nil)
        let downloader = ImageDownloader(photo, progressBlock: { _, _ in
            //print(process)
        }, completeBlock: { [weak self] photo, data in
            self?.downloadsInProgress.removeValue(forKey: photo.id ?? "")
            DataManager.sharedInstance.savePhoto(with: photo, image: data)
        })
        downloadsInProgress[photo.id ?? ""] = downloader
    }
    
    func downloaderWithId(with idPhoto: String) -> ImageDownloader? {
        return downloadsInProgress[idPhoto]
    }
}
