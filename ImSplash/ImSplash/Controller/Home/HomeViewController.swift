//
//  HomeViewController.swift
//  ImSplash
//
//  Created by Nguyen Vu Hao on 5/15/20.
//  Copyright © 2020 Nguyen Vu Hao. All rights reserved.
//

import UIKit

class HomeViewController: BasePhotoListViewController {
    private lazy var header: HomeHeaderView = {
        let header = HomeHeaderView()
        header.didTapDownload = {
            let vc = PhotoDownloadedViewController()
            vc.presenter = PhotoListDownloadedPresenter()
            self.navigationController?.pushViewController(vc, animated: true)
        }
        return header
    }()
    
    override func configLayout() {
        view.addSubview(header)
        view.addSubview(collectionView)
        
        header.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            if #available(iOS 11.0, *) {
                let window = UIApplication.shared.windows[0]
                let topPadding = window.safeAreaInsets.top
                make.top.equalToSuperview().inset(topPadding)
            } else {
                make.top.equalToSuperview()
            }
            make.height.equalTo(75)
        }
        
        collectionView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(header.snp.bottom)
            if #available(iOS 11.0, *) {
                let window = UIApplication.shared.windows[0]
                let bottomPadding = window.safeAreaInsets.bottom
                make.bottom.equalToSuperview().inset(bottomPadding)
            } else {
                make.bottom.equalToSuperview()
            }
        }
        collectionView.addSubview(refreshControl)
    }
}
