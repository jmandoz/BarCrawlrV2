//
//  CoreDataController.swift
//  BarCrawlrV2
//
//  Created by Jason Mandozzi on 10/9/22.
//

import Foundation
import CoreData

class CoreDataController: ObservableObject {
    let container = NSPersistentContainer(name: "User")
    
    init() {
        container.loadPersistentStores { description, error in
            if let error = error {
                //TODO: - Log Error
                print("Core Data failed to load: \(error.localizedDescription), \(description)")
            }
        }
    }
}
