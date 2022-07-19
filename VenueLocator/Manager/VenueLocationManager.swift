//
//  VenueLocationManager.swift
//  VenueLocator
//
//  Created by Banerjee, Supratik on 25/06/22.
//

import Foundation
import CoreLocation
import Combine

/// This is a location manager class to update user location
class VenueLocationManager: NSObject, ObservableObject {

    /// Static instance of class
    static let sharedInstance = VenueLocationManager()

    /// CL Location manager instance
    private var locationManager = CLLocationManager()

    /// User location coordinates
    @Published private(set) var userLocationCoordinates: (latitude: Double, longitude: Double)?

    /// Property to notify if location is updated
    let updatedLocationPassthroughSubject = PassthroughSubject<Bool?, Never>()

    /// Private init of singleton class
    private override init() {
        super.init()
    }

    /// This method starts updating location
    func startUpdatingLocation() {
        locationManager.requestAlwaysAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }
}

extension VenueLocationManager: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locationCoordinates: CLLocationCoordinate2D = manager.location?.coordinate else {
            updatedLocationPassthroughSubject.send(nil)
            return
        }
        userLocationCoordinates = (locationCoordinates.latitude, locationCoordinates.longitude)
        updatedLocationPassthroughSubject.send(true)
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .restricted, .denied:
            updatedLocationPassthroughSubject.send(nil)
        case .authorizedAlways, .authorizedWhenInUse:
            manager.requestWhenInUseAuthorization()
        default:
            manager.requestWhenInUseAuthorization()
        }
    }
}
