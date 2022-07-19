//
//  VenueSearchViewModel.swift
//  VenueLocator
//
//  Created by Banerjee, Supratik on 18/07/22.
//

import UIKit
import Combine

/// Venue Search View Model
class VenueSearchViewModel: ObservableObject {

    /// Constants of VenueSearchViewModelConstants
    private struct VenueSearchViewModelConstants {
        static let iconDimension: Int = 120
        static let defaultMaxRadius: Double = 10000
    }
    
    // MARK: - Properties & Constants
    
    /// Model for Search Venue
    @Published private var searchVenueModel: VenueSearchModel?

    /// Default Max Radius of Search
    @Published var searchRadius: Double = VenueSearchViewModelConstants.defaultMaxRadius

    /// Property to tell view if there are no records
    var isEmptyVenue: Bool {
        return searchVenueModel?.results?.isEmpty ?? false
    }

    /// Initializer for search venue view model
    /// - Parameter searchVenueModel: VenueSearchModel
    init(searchVenueModel: VenueSearchModel? = nil) {
        self.searchVenueModel = searchVenueModel
    }

}

/// Extension of Venue Search View Model for Service
extension VenueSearchViewModel {

    /// This method request for venue search
    /// - Parameters:
    ///   - latitude: Latitude
    ///   - longitude: Longitude
    @MainActor
    final func venueSearchRequest(latitude: Double? = nil,
                                  longitude: Double? = nil) async throws {
        let venueSearchResponse = await VenueInfoService().searchVenue(radius: searchRadius, latitude: latitude, longitude: longitude)
        switch venueSearchResponse {
        case .success(let searchVenueModel):
            self.searchVenueModel = searchVenueModel
        case .failure(let carInfoError):
            throw carInfoError
        }
    }
}

/// Extension of Venue Search View Model for Service
extension VenueSearchViewModel {

    /// This method creates List View Card Model
    /// - Returns: List View Card Model
    final func listViewCardModel() -> [VenueDetailsListModel] {
        var venueDetailsCardList: [VenueDetailsListModel] = []
        if let venueSearchModel = searchVenueModel?.results {
            venueSearchModel.forEach() { result in
                if let cartegory =  result.categories.first {
                    venueDetailsCardList.append(VenueDetailsListModel(venueName: result.name ?? .emptyString,
                                                                      categoryName: cartegory.name ?? .emptyString,
                                                                      iconImageLink: generateIconLink(imagePrefix: cartegory.icon?.iconPrefix, imageSuffix: cartegory.icon?.iconSuffix),
                                                                      distance: result.distance ?? .zero,
                                                                      address: result.location?.formattedAddress ?? .emptyString))
                }
            }
        }
        return venueDetailsCardList
    }

    /// This method creates Map View Card Model
    /// - Returns: Map View Card Model
    final func mapViewCardModel() -> [VenueDetailsMapModel] {
        var venueDetailsCardList: [VenueDetailsMapModel] = []
        if let venueSearchModel = searchVenueModel?.results {
            venueSearchModel.forEach() { result in
                if let cartegory =  result.categories.first {
                    venueDetailsCardList.append(VenueDetailsMapModel(fsqId: result.fsqID ?? .emptyString,
                                                                     venueName: result.name ?? .emptyString,
                                                                     categoryName: cartegory.name ?? .emptyString,
                                                                     distance: result.distance ?? .zero,
                                                                     latitude: result.geocodes?.main?.latitude ?? .zero,
                                                                     longitude: result.geocodes?.main?.longitude ?? .zero,
                                                                     address: result.location?.formattedAddress ?? .emptyString))
                }
            }
        }
        return venueDetailsCardList
    }

    /// This function genetrates Icon String URL
    /// - Parameters:
    ///   - imagePrefix: Image Icon prefix string
    ///   - imageSuffix: Imahge Icon suffix string
    /// - Returns: Icon Url
    private func generateIconLink(imagePrefix: String?, imageSuffix: String?) -> String {
        if let imagePrefix = imagePrefix, let imageSuffix = imageSuffix {
            return "\(imagePrefix)\(VenueSearchViewModelConstants.iconDimension)\(imageSuffix)"
        }
        return .emptyString
    }
}
