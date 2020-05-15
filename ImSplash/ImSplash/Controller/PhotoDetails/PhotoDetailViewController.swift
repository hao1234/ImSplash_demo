//
//  PhotoDetailViewController.swift
//  ImSplash
//
//  Created by Nguyen Vu Hao on 5/14/20.
//  Copyright © 2020 Nguyen Vu Hao. All rights reserved.
//

import UIKit
import SDWebImage

final class PhotoDetailViewController: UIViewController {
    
    private var closeButton: UIButton = {
        let button = UIButton()
        button.setTitle("Close", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(closeDidTap), for: .touchUpInside)
        return button
    }()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = self.photo.ratio > 1
            ? self.photo.ratio
            : 1/self.photo.ratio
        scrollView.delegate = self
        scrollView.alwaysBounceVertical = false
        scrollView.alwaysBounceHorizontal = false
        scrollView.showsVerticalScrollIndicator = true
        scrollView.flashScrollIndicators()
        let doubleTapGest = UITapGestureRecognizer(target: self,
                                                   action: #selector(handleDoubleTapScrollView(recognizer:)))
        doubleTapGest.numberOfTapsRequired = 2
        scrollView.addGestureRecognizer(doubleTapGest)
        return scrollView
    }()
    
    private lazy var imgView: UIImageView = {
        let imgView = UIImageView()
        imgView.contentMode = .scaleAspectFit
        if self.photo.urlFull?.isEmpty ?? true,
            let data = self.photo.imageData {
            imgView.image = UIImage(data: data)
            return imgView
        }
        imgView.sd_imageIndicator = SDWebImageActivityIndicator.gray
        imgView.sd_setImage(with: URL(string: self.photo.urlFull ?? ""),
                            completed: nil)
        return imgView
    }()
    
    private lazy var bottomView = BottomInfoPhotoView(frame: self.view.bounds,
                                                      photo: photo)
    private let photo: SplashImage

    init(photo: SplashImage) {
        self.photo = photo
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configView()
    }
    
    private func configView() {
        view.addSubview(scrollView)
        view.addSubview(closeButton)
        view.addSubview(bottomView)
        scrollView.addSubview(imgView)
        
        closeButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            if #available(iOS 11.0, *) {
                let window = UIApplication.shared.windows[0]
                let topPadding = window.safeAreaInsets.top
                make.top.equalToSuperview().inset(topPadding)
            } else {
                make.top.equalToSuperview()
            }
            make.size.equalTo(CGSize(width: 50, height: 30))
        }
        
        bottomView.snp.makeConstraints {
            $0.height.equalTo(45)
            $0.leading.trailing.equalToSuperview()
            if #available(iOS 11.0, *) {
                let window = UIApplication.shared.windows[0]
                let bottomPadding = window.safeAreaInsets.bottom
                $0.bottom.equalToSuperview().inset(bottomPadding)
            } else {
                $0.bottom.equalToSuperview()
            }
        }
        
        scrollView.snp.makeConstraints {
            $0.top.bottom.leading.trailing.equalToSuperview()
        }
        
        imgView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(view)
        }
    }
    
    @objc private func closeDidTap() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func handleDoubleTapScrollView(recognizer: UITapGestureRecognizer) {
        if scrollView.zoomScale == 1 {
            scrollView.setZoomScale(3, animated: true)
        } else {
            scrollView.setZoomScale(1, animated: true)
            scrollView.contentSize = imgView.frame.size
        }
    }
}

extension PhotoDetailViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imgView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        bottomView.alpha = scrollView.zoomScale == 1 ? 1 : 0
        closeButton.alpha = scrollView.zoomScale == 1 ? 1 : 0
    }
}
