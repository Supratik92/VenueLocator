//
//  CarsInfoEndpoint.swift
//  CarDetails
//
//  Created by Banerjee, Supratik on 22/06/22.
//

import Foundation

enum VenueInfoEndpoint {

    /// Search Venue Service
    case searchVenue(radius: Double, latitude: Double, longitude: Double)

    /// Search Image Service
    case imageForVenue(fsqId: String)

    private struct Keys {
        static let searchRadius = "radius"
        static let latitudeLongitude = "ll"
        static let acceptHeader = "Accept"
        static let authorizationHeader = "Authorization"
    }

    private struct Values {
        static let applicationJson = "application/json"
    }
}

extension VenueInfoEndpoint: VenueLocatorEndPoints {
    var path: String {
        switch self {
        case .searchVenue(let radius, let latitude, let longitude):
            return "search?\(Keys.searchRadius)\(String.equals)\(Int(radius))&\(Keys.latitudeLongitude)\(String.equals)\(latitude)\(String.comma)\(longitude)"
        case .imageForVenue(fsqId: let id):
            return "\(id)/photos"
        }
    }

    var method: VenueDetailsHTTPMethod {
        switch self {
        case .searchVenue:
            return .get
        case .imageForVenue:
            return .get
        }
    }

    var header: [String: String]? {
        switch self {
        default:
            return [Keys.acceptHeader: Values.applicationJson,
                    Keys.authorizationHeader: authToken]
        }
    }

    var body: [String: String]? {
        return nil
    }
}
