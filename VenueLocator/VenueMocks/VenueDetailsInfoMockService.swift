//
//  CarDetailsInfoMockService.swift
//  VenueLocator
//
//  Created by Banerjee, Supratik on 23/06/22.
//

import Foundation

/// This class is handler for Venue Detail Mock Services
final class VenueDetailsInfoMockService: VenueDetailsMockable, VenueDetailServiceable {

    // Here we are returning the json file instead of actual response from service.
    // Using this method for execution of test case
    func searchVenue(radius: Double, latitude: Double?, longitude: Double?) async -> Result<VenueSearchModel, VenueDetailsRequestErrors> {
        return .success(loadJSON(filename: "venueSearch", type: VenueSearchModel.self))
    }

    func getImage(for fsqId: String) async -> Result<[VenueImageModel], VenueDetailsRequestErrors> {
        return .success(loadJSON(filename: "imageGetResponse", type: [VenueImageModel].self))
    }
}
