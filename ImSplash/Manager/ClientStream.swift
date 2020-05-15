//
//  ClientStream.swift
//  ImSplash
//
//  Created by Nguyen Vu Hao on 5/14/20.
//  Copyright © 2020 Nguyen Vu Hao. All rights reserved.
//

import UIKit

final class ClientStream {
    static fileprivate(set) var sharedInstance: ClientStream!
    var downLoadManager: DownloadManager!
    
    public static func initialize() {
        if sharedInstance != nil {
            assertionFailure("ClientStream sharedInstance should be nil at initialization")
        }

        sharedInstance = ClientStream()
    }
    
    init() {
        downLoadManager = DownloadManager()
    }
    
}

