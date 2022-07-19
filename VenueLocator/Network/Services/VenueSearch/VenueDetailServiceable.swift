//
//  VenueDetailServiceable.swift
//  VenueLocator
//
//  Created by Banerjee, Supratik on 22/06/22.
//

import Foundation

protocol VenueDetailServiceable {

    /// This method initiate search service request of venues
    /// - Parameters:
    ///   - radius: Radius of searching areas
    ///   - latitude: Latitude of the nearby area
    ///   - longitude: Longitude of the nearby area
    /// - Returns: Result type of model and error
    func searchVenue(radius: Double, latitude: Double?, longitude: Double?) async -> Result<VenueSearchModel, VenueDetailsRequestErrors>

    /// This method initiate Image request service
    /// - Parameters:
    ///   - fsqId: Id
    /// - Returns: Result type of model and error
    func getImage(for fsqId: String) async -> Result<[VenueImageModel], VenueDetailsRequestErrors>
}

struct VenueInfoService: VenueDetailsHTTPClient, VenueDetailServiceable {

    private struct VenueInfoServiceConstant {
        static let defaultLatitude: Double = 41.8781
        static let defaultLongitude: Double = -87.6298
    }

    func searchVenue(radius: Double, latitude: Double?, longitude: Double?) async -> Result<VenueSearchModel, VenueDetailsRequestErrors> {
        return await sendRequest(endpoint: VenueInfoEndpoint.searchVenue(radius: radius, latitude: latitude ?? VenueInfoServiceConstant.defaultLatitude, longitude: longitude ?? VenueInfoServiceConstant.defaultLongitude), responseModel: VenueSearchModel.self)
    }

    func getImage(for fsqId: String) async -> Result<[VenueImageModel], VenueDetailsRequestErrors> {
        return await sendRequest(endpoint: VenueInfoEndpoint.imageForVenue(fsqId: fsqId), responseModel: [VenueImageModel].self)
    }

}
