//
//  BasePhotoListPresenter.swift
//  ImSplash
//
//  Created by Nguyen Vu Hao on 5/14/20.
//  Copyright © 2020 Nguyen Vu Hao. All rights reserved.
//

import UIKit

protocol BasePhotoListProtocol {
    var controller: BasePhotoViewControllerProtocol? {get set}
    var photos: [SplashImage] {get set}
    
    func cellForItemAt(collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell
    func willDisplay(collectionView: UICollectionView, indexPath: IndexPath)
    func didSelectPhotoAt(indexPath: IndexPath)
    func getPhotos(with page: Int)
    func shouldHiddenNavigationbar() -> Bool
}

protocol BasePhotoViewControllerProtocol {
    var presenter: BasePhotoListProtocol { get }
    var collectionView: UICollectionView {get set}
    var contentView: UIView {get}
    
    func presentphotoDetail(vc: PhotoDetailViewController)
    func endRefeshing()
}


class BasePhotoListPresenter: BasePhotoListProtocol {
    var controller: BasePhotoViewControllerProtocol?
    var photos: [SplashImage] = []
    private lazy var photoManager = PhotoManager(webAPI: PhotoWebAPI())
    private var isWaitingResponse = false
    
    func shouldHiddenNavigationbar() -> Bool {
        return true
    }
    
    func getPhotos(with page: Int) {
        guard let controller = controller else {
            return
        }
        isWaitingResponse = true
        LoadingOverlay.shared.showOverlay(view: controller.contentView)
        photoManager.requestPhotos(page: page, complete: { photos, response in
            if let photos = photos {
                self.photos = page == 1
                    ? photos
                    : self.photos + photos
                self.controller?.collectionView.reloadData()
                self.controller?.endRefeshing()
                LoadingOverlay.shared.hideOverlayView()
            }
            self.isWaitingResponse = false
        })
    }
    
    func cellForItemAt(collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell",
                                                            for: indexPath) as? PhotoCollectionViewCell else {
            fatalError()
        }

        cell.layer.shouldRasterize = true
        cell.layer.rasterizationScale = UIScreen.main.scale
        guard indexPath.row < photos.count else { return cell }
        let photo = photos[indexPath.row]
        cell.setPhoto(with: photo)
        return cell
    }
    
    func willDisplay(collectionView: UICollectionView, indexPath: IndexPath) {
        guard indexPath.row == photos.count - 1, isWaitingResponse == false else { return }
        getPhotos(with: photos.count/10 + 1)
    }
    
    func didSelectPhotoAt(indexPath: IndexPath) {
        guard indexPath.row < photos.count else { return }
        let photo = photos[indexPath.row]
        let vc = PhotoDetailViewController(photo: photo)
        controller?.presentphotoDetail(vc: vc)
    }
}
