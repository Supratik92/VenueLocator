//
//  VenueDetailsListViewModel.swift
//  VenueLocator
//
//  Created by Banerjee, Supratik on 26/06/22.
//

import Foundation

class VenueDetailsListViewModel: ObservableObject {

    /// This Property provides venue list details model array
    @Published private(set) var venueListDetailsInfoArray: [VenueDetailsListModel] = []

    /// Initializer of VenueDetailsListViewModel
    /// - Parameter venueListDetailsInfoArray: VenueDetailsListModel
    init(venueListDetailsInfoArray: [VenueDetailsListModel] = []) {
        self.venueListDetailsInfoArray = venueListDetailsInfoArray
    }
}

extension VenueDetailsListViewModel {
    final func updateFavourite(model: VenueDetailsListModel) {
        for elements in .zero..<venueListDetailsInfoArray.count where venueListDetailsInfoArray[elements].venueName == model.venueName {
            venueListDetailsInfoArray[elements].isFavourite = !venueListDetailsInfoArray[elements].isFavourite
        }
    }
}
