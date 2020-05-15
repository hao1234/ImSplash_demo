//
//  PhotoOperations.swift
//  ImSplash
//
//  Created by Nguyen Vu Hao on 5/14/20.
//  Copyright © 2020 Nguyen Vu Hao. All rights reserved.
//

import UIKit

enum PhotoRecordState {
  case new, downloaded, failed
}

class PendingOperations {
  lazy var downloadsInProgress: [String: Operation] = [:]
  lazy var downloadQueue: OperationQueue = {
    var queue = OperationQueue()
    queue.name = "Download queue"
    queue.maxConcurrentOperationCount = 1
    return queue
  }()
}

typealias ProgressDownloadBlock = (SplashImage, Int) -> ()
typealias CompleteDownloadBlock = (SplashImage, Data?) -> ()

class ImageDownloader: NSObject, URLSessionDelegate, URLSessionDownloadDelegate {
    var photo: SplashImage
    private var progressBlock: ProgressDownloadBlock?
    private var completeBlock: CompleteDownloadBlock?
    
    var progressShareBlock: ProgressDownloadBlock?
    var completeShareBlock: CompleteDownloadBlock?
    
    private let byteFormatter: ByteCountFormatter = {
        let formatter = ByteCountFormatter()
        formatter.allowedUnits = [.useKB, .useMB]
        return formatter
    }()
    
    init(_ photo: SplashImage, progressBlock: ProgressDownloadBlock?, completeBlock: CompleteDownloadBlock?) {
        self.photo = photo
        self.progressBlock = progressBlock
        self.completeBlock = completeBlock
        super.init()
        startDownload()
    }
    
    private func startDownload() {
        guard let urlString = photo.urlFull,
            let url = URL(string: urlString) else {
                return
        }
        
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config, delegate: self, delegateQueue: nil)
        session.downloadTask(with: url).resume()
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        DispatchQueue.main.async {
            self.progressBlock?(self.photo, Int(Double(totalBytesWritten)/Double(totalBytesExpectedToWrite) * 100))
            self.progressShareBlock?(self.photo, Int(Double(totalBytesWritten)/Double(totalBytesExpectedToWrite) * 100))
        }
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        if let data = try? Data(contentsOf: location) {
            DispatchQueue.main.async {
                self.completeBlock?(self.photo, data)
                self.completeShareBlock?(self.photo, data)
            }
        } else {
            DispatchQueue.main.async {
                self.completeBlock?(self.photo, nil)
                self.completeShareBlock?(self.photo, nil)
            }
        }
    }
}
