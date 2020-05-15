//
//  BottomInfoPhotoView.swift
//  ImSplash
//
//  Created by Nguyen Vu Hao on 5/14/20.
//  Copyright © 2020 Nguyen Vu Hao. All rights reserved.
//

import UIKit

typealias BottomInfoDownloadBlock = () -> ()
class BottomInfoPhotoView: UIView {
    private lazy var userNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.text = self.photo?.user?.username
        return label
    }()
    
    private lazy var subTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.text = self.photo?.user?.twitterName ?? self.photo?.user?.instagram
        return label
    }()
    
    private var downloadButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "ic_download"), for: .normal)
        button.addTarget(self, action: #selector(downloadDidTap), for: .touchUpInside)
        return button
    }()
    
    private var likeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "ic_like"), for: .normal)
        button.addTarget(self, action: #selector(likeDidTap), for: .touchUpInside)
        return button
    }()
    
    private lazy var imgView: UIImageView = {
        let imgView = UIImageView()
        imgView.layer.cornerRadius = 20
        imgView.layer.masksToBounds = true
        imgView.contentMode = .scaleAspectFit
        imgView.sd_setImage(with: URL(string: self.photo?.user?.profileImage ?? ""), completed: nil)
        return imgView
    }()
    
    private var photo: SplashImage?
    var didTapDownload: BottomInfoDownloadBlock?
    
    init(frame: CGRect, photo: SplashImage?) {
        self.photo = photo
        super.init(frame: frame)
        configView()
    }
    
    private func configView() {
        addSubview(imgView)
        addSubview(userNameLabel)
        addSubview(likeButton)
        addSubview(subTitleLabel)
        addSubview(downloadButton)
        
        imgView.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 40, height: 40))
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(16)
        }
        
        userNameLabel.snp.makeConstraints {
            $0.top.equalTo(imgView).offset(1)
            $0.leading.equalTo(imgView.snp.trailing).offset(8)
        }
        
        subTitleLabel.snp.makeConstraints {
            $0.top.equalTo(userNameLabel.snp.bottom).offset(2)
            $0.leading.equalTo(userNameLabel)
        }
        
        likeButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(15)
        }
        
        downloadButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalTo(likeButton.snp.leading).offset(-20)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc private func likeDidTap() {
        let liked: Bool = photo?.liked ?? false
        photo?.updateLike(with: !liked)
        photo?.liked == true
            ? likeButton.setImage(UIImage(named: "ic_liked"), for: .normal)
            : likeButton.setImage(UIImage(named: "ic_like"), for: .normal)
    }
    
    @objc private func downloadDidTap() {
        guard let photo = photo else { return }
        downloadButton.isEnabled = false
        ClientStream.sharedInstance.downLoadManager.addPhotoToDownload(photo: photo)
    }
}
