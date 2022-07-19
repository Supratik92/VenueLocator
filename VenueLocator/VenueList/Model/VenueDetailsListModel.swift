//
//  VenueDetailsListModel.swift
//  VenueLocator
//
//  Created by Banerjee, Supratik on 19/07/22.
//

import Foundation

/// VenueDetailsListModel for List view cards
struct VenueDetailsListModel {

    /// Property for name of venue
    let venueName: String

    /// Property for category name
    let categoryName: String

    /// Property for image url
    let iconImageLink: String

    /// Property for distance from current location
    let distance: Int

    /// Property for venue address
    let address: String

    /// Property for faviorite venue
    var isFavourite: Bool = false

    /// distance in string format
    var distanceInMiles: String {
        return "\(distance) \("venue.miles".localized())" 
    }
}
