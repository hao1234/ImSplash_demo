//
//  PhotoModel.swift
//  ImSplash
//
//  Created by Nguyen Vu Hao on 5/14/20.
//  Copyright © 2020 Nguyen Vu Hao. All rights reserved.
//

import UIKit
import CoreData

class PhotoModel: NSManagedObject {
    @NSManaged public var id: String?
    @NSManaged public var width:Double
    @NSManaged public var height:Double
    @NSManaged public var imageData: Data?
    @NSManaged public var dateCreated: Date?
    
    func setData(photo: SplashImage, imageData: Data?) {
        self.id = photo.id
        self.width = Double(photo.width)
        self.height = Double(photo.heigh)
        self.imageData = imageData
        self.dateCreated = Date()
    }
}

extension PhotoModel {
    @nonobjc class func fetchRequest() -> NSFetchRequest<PhotoModel> {
        return NSFetchRequest<PhotoModel>(entityName: "PhotoModel")
    }
}
