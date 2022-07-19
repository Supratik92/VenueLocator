//
//  VenueMapViewModel.swift
//  VenueLocator
//
//  Created by Banerjee, Supratik on 19/07/22.
//

import Foundation
import MapKit

class VenueMapViewModel: ObservableObject {

    // MARK: - Properties & Constants

    private struct VenueMapViewModelConstants {
        static let zoomLevel: Double = 0.002
        static let defaultLatitude: Double = 48.1351
        static let defaultLongitude: Double = 11.5820
        static let defaultSpan: Double = 5
    }

    /// FSQID to fetch image related information
    private var fsqId: String {
        return venueDetailsMapArray[currentIndex].fsqId
    }

    /// Venue related Map Details
    @Published private(set) var venueDetailsMapArray: [VenueDetailsMapModel] = []

    /// Taking lats and longs of user, and if not available setting default of Chicago
    @Published var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: VenueLocationManager.sharedInstance.userLocationCoordinates?.latitude ?? VenueMapViewModelConstants.defaultLatitude, longitude: VenueLocationManager.sharedInstance.userLocationCoordinates?.longitude ?? VenueMapViewModelConstants.defaultLongitude), span: MKCoordinateSpan(latitudeDelta: VenueMapViewModelConstants.defaultSpan, longitudeDelta: VenueMapViewModelConstants.defaultSpan))

    @Published var currentIndex = Int.zero

    /// Initilazer having dependency on Venue Detail Map Model Array
    /// - Parameter venueDetailsMapArray: Venue Detail Map Model Array
    init(venueDetailsMapArray: [VenueDetailsMapModel] = []) {
        self.venueDetailsMapArray = venueDetailsMapArray
        mapLocationDetails()
    }
}

/// Extension of VenueMapViewModel for service methods
extension VenueMapViewModel {

    /// This method searches for venue based on radius
    @MainActor
    final func venueSearchRequest() async throws {
        let venueSearchResponse = await VenueInfoService().getImage(for: fsqId)
        switch venueSearchResponse {
        case .success(let imageModel):
            setImageUrlForId(id: venueDetailsMapArray[currentIndex].fsqId, imageUrl: imageModel.first?.imageUrlString)
        case .failure(let imageError):
            throw imageError
        }
    }

}

/// Extension of VenueMapViewModel for operational methods
extension VenueMapViewModel {

    /// This method sets map location details
    private func mapLocationDetails() {
        if venueDetailsMapArray.count > .zero,
           let firstVenue = venueDetailsMapArray.first {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                self.setZoomLevel(pin: firstVenue)
            })
        }
    }

    /// This method sets zoom level
    /// - Parameter pin: map model
    final func setZoomLevel(pin: VenueDetailsMapModel) {
        region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: pin.latitude, longitude: pin.longitude), span: MKCoordinateSpan(latitudeDelta: VenueMapViewModelConstants.zoomLevel, longitudeDelta: VenueMapViewModelConstants.zoomLevel))
    }

    /// This method sets zoom level based on index
    /// - Parameters:
    ///   - index: index to set zoom level
    ///   - zoomLevel: basic zoom level
    final func setZoomLevel(index: Int, zoomLevel: Double = VenueMapViewModelConstants.zoomLevel) {
        if index < venueDetailsMapArray.count {
            let pin = venueDetailsMapArray[index]
            region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: pin.latitude, longitude: pin.longitude), span: MKCoordinateSpan(latitudeDelta: zoomLevel, longitudeDelta: zoomLevel))
        }
    }

    /// This method set url for focused venue view
    /// - Parameters:
    ///   - id: FSQID
    ///   - imageUrl: Image Url
    final func setImageUrlForId(id: String, imageUrl: String?) {
        for index in .zero..<venueDetailsMapArray.count where venueDetailsMapArray[index].fsqId == id {
            venueDetailsMapArray[index].imageUrl = imageUrl
        }
    }

    /// This method set up favourite
    /// - Parameter model: VenueDetailsMapModel
    final func updateFavourite(model: VenueDetailsMapModel) {
        for elements in .zero..<venueDetailsMapArray.count where venueDetailsMapArray[elements].venueName == model.venueName {
            venueDetailsMapArray[elements].isFavourite = !venueDetailsMapArray[elements].isFavourite
        }
    }
}
