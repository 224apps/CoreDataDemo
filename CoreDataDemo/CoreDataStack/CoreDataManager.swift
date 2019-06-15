//
//  CoreDataManager.swift
//  CoreDataDemo
//
//  Created by A. Diallo on 6/15/19.
//  Copyright © 2019 Abdoulaye Diallo. All rights reserved.
//

import Foundation
import  CoreData


struct CoreDataManager {

    static let shared = CoreDataManager()
    
    let persistentContainer : NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CoreDataDemo")
        container.loadPersistentStores { (storeDesc, error) in
            if let err = error {
                print("Can't load the persistent store: \(err)")
            }
        }
        return container
    }()
    
}
