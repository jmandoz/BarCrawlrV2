//
//  BarCrawlrV2App.swift
//  BarCrawlrV2
//
//  Created by Jason Mandozzi on 8/14/22.
//

import SwiftUI

@main
struct BarCrawlrV2App: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
