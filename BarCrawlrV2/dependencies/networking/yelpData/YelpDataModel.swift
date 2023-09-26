//
//  YelpDataModel.swift
//  BarCrawlrV2
//
//  Created by Jason Mandozzi on 9/21/23.
//

import Foundation

struct TopLevelJSON: Codable {
    let businesses: [Bar]
}

struct Bar: Codable {
    let name: String
    let imageURL: String?
    let isOpen: Bool?
    let phone: String?
    let rating: Float
    let coordinates: Coordinates
    let address: Location
    let reviewCount: Int
    let url: String
    
    private enum CodingKeys: String, CodingKey {
        case name
        case imageURL = "image_url"
        case isOpen = "is_closed"
        case phone = "display_phone"
        case rating
        case coordinates
        case address = "location"
        case reviewCount = "review_count"
        case url
    }
    
    func convertToViewObject() -> BarViewObject? {
        guard let lat = self.coordinates.latitude, let long = self.coordinates.longitude else { return nil }
        return .init(name: self.name,
                     address: self.address.physicalAddress ?? "",
                     location: .init(latitude: lat, longitude: long),
                     rating: self.rating)
    }
}

struct Coordinates: Codable {
    let longitude: Double?
    let latitude: Double?
}

struct Location: Codable {
    let physicalAddress: String?
    let city: String
    let state: String
    let zipCode: String?

    private enum CodingKeys: String, CodingKey{
        case physicalAddress = "address1"
        case city
        case state
        case zipCode = "zip_code"
    }
}
