//
//  VenueImageModel.swift
//  VenueLocator
//
//  Created by Banerjee, Supratik on 19/07/22.
//

import Foundation

// MARK: - VenueImageModel
struct VenueImageModel: Codable {

    private static let urlOriginalKey = "original"

    /// Image Prefix
    let prefix: String?

    /// Image suffix
    let suffix: String?

    /// Image url final string
    var imageUrlString: String {
        if let prefix = prefix, let suffix = suffix {
            return "\(prefix)\(VenueImageModel.urlOriginalKey)\(suffix)"
        }
        return .emptyString
    }
}
