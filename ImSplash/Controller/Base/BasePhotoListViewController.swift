//
//  BasePhotoListViewController.swift
//  ImSplash
//
//  Created by Nguyen Vu Hao on 5/14/20.
//  Copyright © 2020 Nguyen Vu Hao. All rights reserved.
//

import UIKit
import WaterfallLayout

class BasePhotoListViewController: UIViewController {

    private let spacingCol:CGFloat = 8.0
    private let cellWidth = (UIScreen.main.bounds.width - 24)/2
    
    lazy var collectionView: UICollectionView = {
        let layout = WaterfallLayout()
        layout.delegate = self
        layout.sectionInset = UIEdgeInsets(top: 16, left: spacingCol, bottom: 16, right: spacingCol)
        layout.minimumLineSpacing = spacingCol
        layout.minimumInteritemSpacing = spacingCol
        let cv = UICollectionView(frame: self.view.bounds, collectionViewLayout: layout)
        cv.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        cv.dataSource = self
        cv.delegate = self
        cv.backgroundColor = .white
        cv.alwaysBounceVertical = true
        return cv
    }()
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self,
                                 action: #selector(self.reloadData),
                                 for: UIControl.Event.valueChanged)
        return refreshControl
    }()
    
    var presenter: BasePhotoListProtocol = BasePhotoListPresenter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.controller = self
        configLayout()
        presenter.getPhotos(with: 1)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(presenter.shouldHiddenNavigationbar(), animated: false)
    }
    
    func configLayout() {
        
    }
    
    @objc func reloadData() {
        presenter.getPhotos(with: 1)
    }
}

extension BasePhotoListViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return presenter.photos.isEmpty ? 0 : 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter.photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        presenter.cellForItemAt(collectionView: collectionView, indexPath: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        presenter.willDisplay(collectionView: collectionView, indexPath: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presenter.didSelectPhotoAt(indexPath: indexPath)
    }
}

extension BasePhotoListViewController: BasePhotoViewControllerProtocol {
    var contentView: UIView {
        view
    }
    
    func presentphotoDetail(vc: PhotoDetailViewController) {
        present(vc, animated: true, completion: nil)
    }
    
    func endRefeshing() {
        refreshControl.endRefreshing()
    }
}

extension BasePhotoListViewController: WaterfallLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, layout: WaterfallLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let photo = presenter.photos[indexPath.row]
        return CGSize(width: cellWidth, height: cellWidth / photo.ratio)
    }
    
    func collectionViewLayout(for section: Int) -> WaterfallLayout.Layout {
        return .waterfall(column: 2, distributionMethod: .balanced)
    }
}
