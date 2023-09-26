//
//  HomeView.swift
//  BarCrawlrV2
//
//  Created by Jason Mandozzi on 8/14/22.
//

import SwiftUI
import CoreData
import MapKit

struct HomeView: View {
    @Environment(\.managedObjectContext) var coreDataMOC
    
    @StateObject var viewModel: HomeViewModel = .init()
    
    @State var presentProfilePage: Bool = false
    
    var body: some View {
        ZStack {
            MapView(region: $viewModel.locationClient.region,
                    span: $viewModel.locationClient.span,
                    bars: $viewModel.localBars)
            GeometryReader { proxy in
                VStack {
                    headerView()
                        .frame(height: proxy.size.height / 8)
                    Spacer()
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(viewModel.localBars) { bar in
                                makeBarCell(bar: bar,
                                            height: proxy.size.height / 7,
                                            width: proxy.size.width / 1.5)
                            }
                        }
                        .padding(.horizontal, 8)
                    }
                    TabBarView(tabs: [.init(title: "List", iconName: "square", color: Color.blue),
                                      .init(title: "Home", iconName: "house", color: Color.blue),
                                      .init(title: "Profile", iconName: "archivebox", color: Color.blue)])
                }
            }
        }
        .ignoresSafeArea(edges: .top)
        .onAppear {
            Task {
                await viewModel.fetchLocalBars()
            }
        }
    }
    
    func makeBarCell(bar: BarViewObject, height: CGFloat, width: CGFloat) -> some View {
        RoundedRectangle(cornerRadius: 8)
            .frame(width: width, height: height)
            .foregroundColor(.white)
            .overlay {
                HStack {
                    VStack(alignment: .leading) {
                        Group {
                            Text(bar.name)
                                .font(.title2)
                            Spacer()
                            if let address = bar.address {
                                Text(address)
                                    .font(.subheadline)
                            }
                            Text("\(bar.rating)")
                                .font(.caption)
                        }
                        .frame(alignment: .leading)
                    }
                    Spacer()
                }
                .padding(5)
            }
    }
    
    @ViewBuilder
    func headerView() -> some View {
        HStack(alignment: .bottom) {
            VStack(alignment: .leading, spacing: 5) {
                Spacer()
                (Text("Hello, ")
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .font(.subheadline) +
                 Text("Jason"))
                Text("3 Bars in your area")
                    .fontWeight(.light)
                    .foregroundColor(.white)
            }
            Spacer()
            Image(systemName: "gear")
                .font(.title2)
                .foregroundColor(Color.white)
                .onTapGesture {
                    
                }
        }
        .padding()
        .background(Color.blue)
    }
    
    @ViewBuilder
    func MapView(region: Binding<MKCoordinateRegion>, span: Binding<MKCoordinateSpan>, bars: Binding<[BarViewObject]>) -> some View {
        Map(coordinateRegion: region, annotationItems: bars) { item in
            MapAnnotation(coordinate: item.wrappedValue.location) {
                MapAnnotationView(bar: item.wrappedValue) {
                    print("did tap annotation")
                }
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView()
        }
    }
}
