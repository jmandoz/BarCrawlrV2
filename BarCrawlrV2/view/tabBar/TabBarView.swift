//
//  TabBarView.swift
//  BarCrawlrV2
//
//  Created by Jason Mandozzi on 8/17/22.
//

import SwiftUI

struct TabBarView: View {
    var tabs: [TabBarItem]
    var body: some View {
        VStack {
            HStack {
                ForEach(tabs, id: \.self) { tab in
                    tabView(tab: tab)
                }
            }
        }
        .background(Color.blue)
    }
}

extension TabBarView {
    @ViewBuilder
    private func tabView(tab: TabBarItem) -> some View {
        VStack {
            Image(systemName: tab.iconName)
            Text(tab.title)
                .font(.caption)
        }
        .padding(.vertical)
        .frame(maxWidth: .infinity)
        .background(tab.color)
        .foregroundColor(Color.white)
    }
}

struct TabBarItem: Hashable {
    let title: String
    let iconName: String
    let color: Color
}

struct TabBarView_Preview: PreviewProvider {
    static let tabs: [TabBarItem] = [
            .init(title: "Home", iconName: "house", color: Color.blue),
            .init(title: "Home", iconName: "house", color: Color.blue),
            .init(title: "Home", iconName: "house", color: Color.blue)
    ]
    
    static var previews: some View {
        VStack {
            Spacer()
            TabBarView(tabs: tabs)
        }
    }
}
