//
//  HomeHeaderView.swift
//  ImSplash
//
//  Created by Nguyen Vu Hao on 5/14/20.
//  Copyright © 2020 Nguyen Vu Hao. All rights reserved.
//

import UIKit

typealias HeaderInfoDownloadBlock = () -> ()
class HomeHeaderView: UIView {
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 24, weight: .heavy)
        label.text = "Unsplash"
        return label
    }()
    
    private var subTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.text = "Beautiful, free photos."
        return label
    }()
    
    private var downloadButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "ic_download"), for: .normal)
        button.addTarget(self, action: #selector(downloadDidTap), for: .touchUpInside)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configView()
    }
    var didTapDownload: HeaderInfoDownloadBlock?
    private func configView() {
        addSubview(titleLabel)
        addSubview(subTitleLabel)
        addSubview(downloadButton)
        
        titleLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview().inset(10)
        }
        
        subTitleLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(12)
            $0.leading.equalTo(titleLabel)
        }
        
        downloadButton.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.top).offset(5)
            $0.trailing.equalToSuperview().inset(15)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func downloadDidTap() {
        self.didTapDownload?()
    }
}
