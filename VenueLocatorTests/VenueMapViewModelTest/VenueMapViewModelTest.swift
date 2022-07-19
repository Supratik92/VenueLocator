//
//  VenueMapViewModelTest.swift
//  VenueLocatorTests
//
//  Created by Banerjee, Supratik on 20/07/22.
//

import XCTest
@testable import VenueLocator

class VenueMapViewModelTest: XCTestCase {

    var venueSearchMockService: VenueDetailsInfoMockService?
    var venueSearchModel: VenueSearchModel?


    override func setUpWithError() throws {
        venueSearchMockService = VenueDetailsInfoMockService()
    }

    override func tearDownWithError() throws {
        venueSearchMockService = nil
    }

    func setupVenueSearchModel() async {
        let venueSearchResponse = await venueSearchMockService?.searchVenue(radius: 10000, latitude: nil, longitude: nil)
        do {
            switch venueSearchResponse {
            case .success(let venueSearchModel):
                self.venueSearchModel = venueSearchModel
            case .failure:
                XCTFail("Received Error Response")
            case .none:
                XCTFail("Received Error Response")
            }
        }
    }

    func testMapViewModelZoomLevelInt() async {
        await setupVenueSearchModel()
        let mapModelArray = VenueSearchViewModel(searchVenueModel: venueSearchModel).mapViewCardModel()
        let viewModel = VenueMapViewModel(venueDetailsMapArray: mapModelArray)
        viewModel.setZoomLevel(index: 1)
        XCTAssert(viewModel.region.span.latitudeDelta == 0.002)
        XCTAssert(viewModel.region.span.longitudeDelta == 0.002)
        XCTAssert(viewModel.region.center.latitude == 39.077667)
        XCTAssert(viewModel.region.center.longitude == -77.576494)
    }

    func testMapViewModelZoomLevel() async {
        await setupVenueSearchModel()
        let mapModelArray = VenueSearchViewModel(searchVenueModel: venueSearchModel).mapViewCardModel()
        let viewModel = VenueMapViewModel(venueDetailsMapArray: mapModelArray)
        viewModel.setZoomLevel(pin: viewModel.venueDetailsMapArray[.zero])
        XCTAssert(viewModel.region.span.latitudeDelta == 0.002)
        XCTAssert(viewModel.region.span.longitudeDelta == 0.002)
        XCTAssert(viewModel.region.center.latitude == 39.040916)
        XCTAssert(viewModel.region.center.longitude == -77.617453)
    }

}
