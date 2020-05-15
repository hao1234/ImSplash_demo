//
//  PhotoListDownloadedPresenter.swift
//  ImSplash
//
//  Created by Nguyen Vu Hao on 5/14/20.
//  Copyright © 2020 Nguyen Vu Hao. All rights reserved.
//

import UIKit

final class PhotoListDownloadedPresenter: BasePhotoListPresenter {
    override func getPhotos(with page: Int) {
        getPhotosDownloaded()
    }
    
    override func shouldHiddenNavigationbar() -> Bool {
        return false
    }
    
    private func getPhotosDownloaded() {
        guard let controller = controller else {
            return
        }
        if photos.isEmpty {
            LoadingOverlay.shared.showOverlay(view: controller.contentView)
        }
        
        DispatchQueue.global(qos: .background).async {
            if let photos = DataManager.sharedInstance.getPhotoDownloaded() {
                DispatchQueue.main.async {
                    self.photos = photos
                    self.controller?.collectionView.reloadData()
                    self.controller?.endRefeshing()
                    LoadingOverlay.shared.hideOverlayView()
                }
            }
        }
    }
    
    override func cellForItemAt(collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell",
                                                            for: indexPath) as? PhotoCollectionViewCell else {
                                                                fatalError()
        }
        
        cell.layer.shouldRasterize = true
        cell.layer.rasterizationScale = UIScreen.main.scale
        guard indexPath.row < photos.count else { return cell }
        let photo = photos[indexPath.row]
        cell.setPhoto(with: photo,
                      downloader: ClientStream.sharedInstance.downLoadManager.downloaderWithId(with: photo.id ?? ""))
        return cell
    }
    
    override func willDisplay(collectionView: UICollectionView, indexPath: IndexPath) {}
}
