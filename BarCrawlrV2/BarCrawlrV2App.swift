//
//  BarCrawlrV2App.swift
//  BarCrawlrV2
//
//  Created by Jason Mandozzi on 8/14/22.
//

import SwiftUI
import CoreLocation

@main
struct BarCrawlrV2App: App {
    @StateObject private var coreDataController = CoreDataController()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, coreDataController.container.viewContext)
        }
    }
}
