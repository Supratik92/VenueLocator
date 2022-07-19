//
//  VenueDetailsRequestErrors.swift
//  VenueLocator
//
//  Created by Banerjee, Supratik on 18/07/22.
//

import Foundation

/// Venue Details
enum VenueDetailsRequestErrors: Error {
    /// Decode Error
    case decode
    /// Invalid URL Error
    case invalidURL
    /// No repsone received
    case noResponse
    /// Un authorized
    case unauthorized
    /// Unexpected Status code error
    case unexpectedStatusCode
    /// Unknown error
    case unknown

    var customMessage: String {
        switch self {
        case .decode:
            return "Response Decoding error"
        case .unauthorized:
            return "Session unauthorized or expired"
        default:
            return "Unknown error"
        }
    }
}
