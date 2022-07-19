//
//  CarDetailsEndPoints.swift
//  VenueLocator
//
//  Created by Banerjee, Supratik on 22/06/22.
//

import Foundation

/// Protocol to store end points related informations
protocol VenueLocatorEndPoints {
    
    /// Base URL of api's
    var baseURL: String { get }

    /// Relative path to append on base url
    var path: String { get }

    /// Http method like get ot post
    var method: VenueDetailsHTTPMethod { get }

    /// Header for an api request
    var header: [String: String]? { get }

    /// Body of the api request
    var body: [String: String]? { get }
}

extension VenueLocatorEndPoints {

    var baseURL: String {
        return "https://api.foursquare.com/v3/places/"
    }

    /// Authorization Token on Application
    var authToken: String {
        return "fsq3qwkovfexw93tVZctcIlfMoYEDDx2m49rrGgp8LoT7mM="
    }
}
