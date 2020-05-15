//
//  PhotoDownloadedViewController.swift
//  ImSplash
//
//  Created by Nguyen Vu Hao on 5/14/20.
//  Copyright © 2020 Nguyen Vu Hao. All rights reserved.
//

import UIKit
import WaterfallLayout

final class PhotoDownloadedViewController: BasePhotoListViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(false, animated: false)
        title = "Downloaded"
    }
    
    override func configLayout() {
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.top.bottom.leading.trailing.equalToSuperview()
        }
        collectionView.addSubview(refreshControl)
    }
}
