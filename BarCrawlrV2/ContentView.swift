//
//  ContentView.swift
//  BarCrawlrV2
//
//  Created by Jason Mandozzi on 8/14/22.
//

import SwiftUI
import CoreData

struct ContentView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("Home", image: "home")
                        .frame(width: 20, height: 20)
                }
            UserProfileView()
                .tabItem {
                    Label("Profile", image: "user")
                        .frame(width: 20, height: 20)
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
