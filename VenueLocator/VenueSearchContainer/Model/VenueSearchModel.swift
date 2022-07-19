//
//  VenueSearchModel.swift
//  VenueLocator
//
//  Created by Banerjee, Supratik on 18/07/22.
//

import Foundation

// MARK: - Welcome
struct VenueSearchModel: Codable {
    let results: [Results]?
    let context: Context?
}

// MARK: - Context
struct Context: Codable {
    let geoBounds: GeoBounds?

    enum CodingKeys: String, CodingKey {
        case geoBounds = "geo_bounds"
    }
}

// MARK: - GeoBounds
struct GeoBounds: Codable {
    let circle: Circle?
}

// MARK: - Circle
struct Circle: Codable {
    let center: Center?
    let radius: Int?
}

// MARK: - Center
struct Center: Codable {
    let latitude, longitude: Double?
}

// MARK: - Result
struct Results: Codable {
    let fsqID, link, name, timezone: String?
    let categories: [Category]
    let chains: [Chain]?
    let distance: Int?
    let geocodes: Geocodes?
    let location: Location?
    let relatedPlaces: RelatedPlaces?

    enum CodingKeys: String, CodingKey {
        case fsqID = "fsq_id"
        case categories, chains, distance, geocodes, link, location, name
        case relatedPlaces = "related_places"
        case timezone
    }
}

// MARK: - Category
struct Category: Codable {
    let id: Int?
    let name: String?
    let icon: Icon?
}

// MARK: - Icon
struct Icon: Codable {

    let iconPrefix, iconSuffix: String?
    enum CodingKeys: String, CodingKey {
        case iconPrefix = "prefix"
        case iconSuffix = "suffix"
    }
}

// MARK: - Chain
struct Chain: Codable {
    let id, name: String
}

// MARK: - Geocodes
struct Geocodes: Codable {
    let main, roof: Center?
}

// MARK: - Location
struct Location: Codable {
    let address, censusBlock, country, dma, locality, region, formattedAddress, postcode: String?
    let crossStreet, addressExtended: String?

    enum CodingKeys: String, CodingKey {
        case address, country, dma, locality, postcode, region
        case censusBlock = "census_block"
        case formattedAddress = "formatted_address"
        case crossStreet = "cross_street"
        case addressExtended = "address_extended"
    }
}

// MARK: - RelatedPlaces
struct RelatedPlaces: Codable {
    let parent: Parent?
}

// MARK: - Parent
struct Parent: Codable {
    let fsqID, name: String

    enum CodingKeys: String, CodingKey {
        case fsqID = "fsq_id"
        case name
    }
}
