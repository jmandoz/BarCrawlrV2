//
//  NetworkController.swift
//  BarCrawlrV2
//
//  Created by Jason Mandozzi on 9/21/23.
//

import Foundation
import Combine
import CoreLocation

class NetworkController {
    private let apiKey = "gAa_9Vm0dDzqXeQSal7BbLzryWdwCt-vyW-t7fi2LDRrLb5sFgzUESHDVdZNDUV-mPAoJJxwvHJaC-sD-kATeUIi2h_mBrGA9g9dBOeN9W1IBVhlmNzoTKOcqCQyXXYx"
    
    let baseURL = URL(string: "https://api.yelp.com/v3/businesses/search")
    
    static let shared = NetworkController()
    
    var cancellable = Set<AnyCancellable>()
    
    func fetchBars(location: CLLocationCoordinate2D, completion: @escaping (([Bar]) -> Void)) {
        if let url = baseURL {
            var components = URLComponents(url: url, resolvingAgainstBaseURL: true)
            let barSearchQuery = URLQueryItem(name: "term", value: "Bar")
            let latitude = URLQueryItem(name: "latitude", value: "\(location.latitude)")
            let longitude = URLQueryItem(name: "longitude", value: "\(location.longitude)")
            components?.queryItems = [barSearchQuery, latitude, longitude]
            guard let finalURL = components?.url else { return }
            var urlRequest = URLRequest(url: finalURL)
            urlRequest.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
            urlRequest.addValue("application/json", forHTTPHeaderField: "accept")
            let _ = URLSession.shared.dataTaskPublisher(for: urlRequest)
                .tryMap { element -> Data in
                    guard let response = element.response as? HTTPURLResponse,
                          (200...299).contains(response.statusCode) else {
                        throw URLError(.badServerResponse)
                    }
                    return element.data
                }
                .decode(type: TopLevelJSON.self, decoder: JSONDecoder())
                .receive(on: DispatchQueue.main)
                .eraseToAnyPublisher()
                .sink { completion in
                    switch completion {
                    case .finished:
                        print("Complete")
                        break
                    case .failure(let error):
                        print("error: \(error.localizedDescription)")
                    }
                } receiveValue: { data in
                    completion(data.businesses)
                }
                .store(in: &cancellable)
        }
    }
}

protocol NetworkClient {
    func fetchBars(location: CLLocationCoordinate2D, completion: @escaping (([Bar]) -> Void))
}
