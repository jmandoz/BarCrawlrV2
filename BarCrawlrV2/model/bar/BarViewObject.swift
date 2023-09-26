//
//  BarViewObject.swift
//  BarCrawlrV2
//
//  Created by Jason Mandozzi on 9/21/23.
//

import Foundation
import MapKit

struct BarViewObject: Identifiable, Equatable {
    let id = UUID().uuidString
    let name: String
    let address: String?
    let location: CLLocationCoordinate2D
    let isSelected: Bool = false
    let rating: Float
    
    static func == (lhs: BarViewObject, rhs: BarViewObject) -> Bool {
        lhs.id == rhs.id
    }
}
