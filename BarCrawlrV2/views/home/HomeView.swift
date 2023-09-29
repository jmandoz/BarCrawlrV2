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
        GeometryReader { proxy in
            ZStack {
                MapView(region: $viewModel.locationClient.region,
                        span: $viewModel.locationClient.span,
                        bars: $viewModel.localBars)
                barItemCarousel(width: proxy.size.width)
            }
            .onAppear {
                Task {
                    if !viewModel.firstLoad {
                        await viewModel.fetchLocalBars()
                        viewModel.firstLoad = true
                    }
                }
            }
        }
    }
    
    func barItemCarousel(width: CGFloat) -> some View {
        VStack {
            Spacer()
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(viewModel.localBars) { bar in
                        makeBarCell(bar: bar,
                                    height: 150,
                                    width: width / 1.5)
                    }
                }
                .padding(.leading, 12)
            }
        }
        .padding(.bottom, 12)
    }
    
    func makeBarCell(bar: BarViewObject, height: CGFloat, width: CGFloat) -> some View {
        RoundedRectangle(cornerRadius: 8)
            .frame(width: width, height: height)
            .foregroundColor(.white)
            .overlay {
                ZStack {
                    if let image = bar.imageURL, let imageURL = URL(string: image) {
                        AsyncImage(url: imageURL)
                            .frame(width: width, height: height)
                            .scaledToFill()
                            .clipped()
                            .opacity(0.5)
                            .clipped()
                            .cornerRadius(8)
                    }
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
                        .padding(8)
                        Spacer()
                    }
                }
            }
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
