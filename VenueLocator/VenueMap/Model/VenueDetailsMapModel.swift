//
//  VenueDetailsMapModel.swift
//  VenueLocator
//
//  Created by Banerjee, Supratik on 19/07/22.
//

import MapKit

/// VenueDetailsListModel for List view cards
struct VenueDetailsMapModel: Identifiable {

    /// Unique Identifier for the model
    let id = UUID()

    /// Unique Identifer for Venue
    let fsqId: String

    /// Property for name of venue
    let venueName: String

    /// Property for category name
    let categoryName: String

    /// Property for distance from current location
    let distance: Int

    /// Property for venue latitude
    let latitude: Double

    /// Property for venue longitude
    let longitude: Double

    /// Property for venue address
    let address: String

    ///  Image url for venue
    var imageUrl: String?

    /// Property for faviorite venue
    var isFavourite: Bool = false

    /// distance in string format
    var distanceInMiles: String {
        return "\(distance) \("venue.miles".localized())"
    }

    /// Coordinates for Map
    var coordinates: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}
