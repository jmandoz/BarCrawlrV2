//
//  HomeViewModel.swift
//  BarCrawlrV2
//
//  Created by Jason Mandozzi on 9/21/23.
//

import Foundation
import CoreLocation

class HomeViewModel: ObservableObject {
    @Published var locationClient: LocationClient = .init()
    @Published var selectedBar: BarViewObject?
    @Published var localBars: [BarViewObject] = []
    
    @MainActor
    func fetchLocalBars() async {
        let location = locationClient.getCurrentLocationCoordinates()
        NetworkController.shared.fetchBars(location: .init(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)) { [weak self] bars in
            guard let strongSelf = self else { return }
            let mappedBars = bars.compactMap({ $0.convertToViewObject() })
            strongSelf.localBars = mappedBars
        }
    }
}
