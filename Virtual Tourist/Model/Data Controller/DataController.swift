//
//  DataController.swift
//  Virtual Tourist
//
//  Created by Mohamed Abdelkhalek Salah on 5/8/20.
//  Copyright © 2020 Mohamed Abdelkhalek Salah. All rights reserved.
//

import Foundation
import CoreData

class DataController {
    
    let persistantContainer: NSPersistentContainer!
    
    var viewContext: NSManagedObjectContext {
        return persistantContainer.viewContext
    }
    
    let backgroundContext: NSManagedObjectContext!
    
    init(modelName: String) {
        persistantContainer = NSPersistentContainer(name: modelName)
        backgroundContext = persistantContainer.newBackgroundContext()
    }
    
    func configureContext() {
        viewContext.automaticallyMergesChangesFromParent = true
        backgroundContext.automaticallyMergesChangesFromParent = true
        
        backgroundContext.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
        viewContext.mergePolicy = NSMergePolicy.mergeByPropertyStoreTrump
    }
    
    func load(completion: (() -> ())? = nil ) {
        persistantContainer.loadPersistentStores { (storesDescription, error) in
            guard error == nil else {
                fatalError("coud't load")
            }
            self.configureContext()
            completion?()
        }
    }
    static let shared = DataController(modelName: "ImagesDataController")
}
