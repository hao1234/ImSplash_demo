//
//  DataManager.swift
//  ImSplash
//
//  Created by Nguyen Vu Hao on 5/14/20.
//  Copyright © 2020 Nguyen Vu Hao. All rights reserved.
//

import UIKit
import CoreData

class DataManager: NSObject {
    private static var instance: DataManager? = nil
    class var sharedInstance: DataManager {
        struct Static {
            static var onceToken: Int = 0
            static var instance: DataManager? = nil
        }
        
        _ = DataManager.doOnce
        return instance!
    }
    
    private static var doOnce: () = {
        instance = DataManager()
    }()
    
    var managedObjectContext: NSManagedObjectContext
    override init() {
        // This resource is the same name as your xcdatamodeld contained in your project.
        guard let modelURL = Bundle.main.url(forResource: "Model", withExtension:"momd") else {
            fatalError("Error loading model from bundle")
        }
        // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
        guard let mom = NSManagedObjectModel(contentsOf: modelURL) else {
            fatalError("Error initializing mom from: \(modelURL)")
        }
        let psc = NSPersistentStoreCoordinator(managedObjectModel: mom)
        self.managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        self.managedObjectContext.persistentStoreCoordinator = psc
        
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let docURL = urls[urls.endIndex-1]
        let storeURL = docURL.appendingPathComponent("Model.sqlite")
        /* The directory the application uses to store the Core Data store file.
         This code uses a file named "DataModel.sqlite" in the application's documents directory.
         */
        do {
            try psc.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: storeURL, options: [NSMigratePersistentStoresAutomaticallyOption: true,NSInferMappingModelAutomaticallyOption: true])
        } catch {
            fatalError("Error migrating store: \(error)")
        }
    }
    
    func saveData() {
        managedObjectContext.performAndWait({() -> Void in
            do {
                try self.managedObjectContext.save()
            } catch {
                fatalError("Failure to save context: \(error)")
            }
        })
    }
    
    func savePhoto(with photo: SplashImage?, image: Data?) {
        guard let photo = photo else {
            return
        }
        let request: NSFetchRequest<PhotoModel> = PhotoModel.fetchRequest()
        request.predicate = NSPredicate(format: "id = %@", photo.id ?? "")
        do {
            let fetchedDeal = try managedObjectContext.fetch(request as! NSFetchRequest<NSFetchRequestResult>) as! [PhotoModel]
            if fetchedDeal.count != 0 {
                let entity = fetchedDeal[0]
                entity.setData(photo: photo, imageData: image)
                self.saveData()
            } else {
                if let entity = NSEntityDescription.insertNewObject(forEntityName: "PhotoModel",
                                                                    into: managedObjectContext) as? PhotoModel {
                    entity.setData(photo: photo, imageData: image)
                    self.saveData()
                }
            }
        } catch {
            fatalError("Failed to fetch user: \(error)")
        }
    }
    
    func getPhotoDownloaded() -> [SplashImage]? {
        let request: NSFetchRequest<PhotoModel> = PhotoModel.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "dateCreated", ascending: false)
        request.sortDescriptors = [sortDescriptor]
        do {
            guard let fetchedData = try managedObjectContext.fetch(request as! NSFetchRequest<NSFetchRequestResult>) as? [PhotoModel],
            fetchedData.count != 0 else {
                return nil
            }
            
            let photos: [SplashImage] = fetchedData.map {
                SplashImage(model: $0)
            }
            return photos
        } catch {
            return nil
        }
    }
}
