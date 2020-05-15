//
//  PhotoCollectionViewCell.swift
//  ImSplash
//
//  Created by Nguyen Vu Hao on 5/12/20.
//  Copyright © 2020 Nguyen Vu Hao. All rights reserved.
//

import UIKit
import SDWebImage

final class PhotoCollectionViewCell: UICollectionViewCell {
    private let cellWidth = (UIScreen.main.bounds.width - 24)/2
    
    let imgView: UIImageView = {
        let imgView = UIImageView()
        imgView.layer.cornerRadius = 5.0
        imgView.layer.masksToBounds = true
        imgView.contentMode = .scaleAspectFit
        return imgView
    }()

    let labelMask: UILabel = {
        let lbel = UILabel()
        lbel.font = UIFont.systemFont(ofSize: 30, weight: .medium)
        lbel.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        lbel.textAlignment = .center
        lbel.textColor = .white
        lbel.isHidden = true
        return lbel
    }()
    override init(frame: CGRect) {
        super.init(frame: .zero)
        configView()
    }
    
    override func prepareForReuse() {
        self.imgView.sd_cancelCurrentImageLoad()
        self.imgView.sd_setImage(with: nil, completed: nil)
        labelMask.isHidden = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configView() {
        contentView.addSubview(imgView)
        contentView.addSubview(labelMask)
    }
    
    func setPhoto(with photo: SplashImage, downloader: ImageDownloader? = nil) {
        imgView.frame = CGRect(x: 0, y: 0, width: cellWidth, height: cellWidth / photo.ratio)
        labelMask.frame = imgView.frame
        if let url = URL(string: photo.thumb ?? "") {
            imgView.sd_imageIndicator = SDWebImageActivityIndicator.gray
            imgView.sd_setImage(with: url, placeholderImage: nil)
        } else if let data = photo.imageData {
            imgView.image = UIImage(data: data)
        } else {
            labelMask.isHidden = false
            labelMask.text = "0%"
            if let downloader = downloader {
                downloader.progressShareBlock = { [weak self] _, process in
                    self?.labelMask.text = "\(process)%"
                }
                downloader.completeShareBlock = { [weak self] _, data in
                    if let data = data {
                        self?.imgView.image = UIImage(data: data)
                    }
                    self?.labelMask.isHidden = true
                }
            }
        }
    }
}
