//
//  LocationClient.swift
//  BarCrawlrV2
//
//  Created by Jason Mandozzi on 9/21/23.
//

import Foundation
import CoreLocation
import MapKit

class LocationClient: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var locationManager: CLLocationManager?
    @Published var authStatus: CLAuthorizationStatus = .notDetermined
    @Published var region = MKCoordinateRegion()
    @Published var span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    
    override init() {
        super.init()
        setUpLocationServices()
    }
    
    public func setUpLocationServices() {
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        switch authStatus {
        case .notDetermined, .restricted:
            locationManager?.requestWhenInUseAuthorization()
            activateLocationServices()
        case .denied:
            break
        case .authorizedAlways, .authorizedWhenInUse, .authorized:
            activateLocationServices()
        @unknown default:
            fatalError()
        }
    }
    
    public func activateLocationServices() {
        guard let manager = locationManager else { return }
        if manager.authorizationStatus == .authorizedAlways || manager.authorizationStatus == .authorizedWhenInUse {
            guard let userLocation = manager.location?.coordinate else { return }
            manager.desiredAccuracy = kCLLocationAccuracyBest
            manager.startUpdatingLocation()
            let lat = userLocation.latitude
            let long = userLocation.longitude
            region = MKCoordinateRegion(center: .init(latitude: lat,
                                                      longitude: long),
                                        span: span)
        } else {
            manager.requestWhenInUseAuthorization()
        }
    }
    
    
    public func getCurrentLocationCoordinates() -> CLLocation {
        guard let manager = locationManager, let location = manager.location else  { return .init() }
        return .init(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        self.authStatus = manager.authorizationStatus
        if authStatus == .authorizedAlways, authStatus == .authorizedWhenInUse {
            activateLocationServices()
        }
    }
}

