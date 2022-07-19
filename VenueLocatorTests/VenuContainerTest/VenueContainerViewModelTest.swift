//
//  VenueContainerViewModelTest.swift
//  VenueLocatorTests
//
//  Created by Banerjee, Supratik on 19/07/22.
//

import XCTest
@testable import VenueLocator

class VenueContainerViewModelTest: XCTestCase {

    var venueSearchMockService: VenueDetailsInfoMockService?
    var venueSearchModel: VenueSearchModel?
    var venueImageModelArray: [VenueImageModel]?

    override func setUpWithError() throws {
        venueSearchMockService = VenueDetailsInfoMockService()
    }

    override func tearDownWithError() throws {
        venueSearchMockService = nil
        venueSearchModel = nil
        venueImageModelArray = nil
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

    func setupVenueImageModel() async {
        let venueImageResponse = await venueSearchMockService?.getImage(for: "4be32fe621d5a593f56d1811")
        do {
            switch venueImageResponse {
            case .success(let venueImageModelArray):
                self.venueImageModelArray = venueImageModelArray
            case .failure:
                XCTFail("Received Error Response")
            case .none:
                XCTFail("Received Error Response")
            }
        }
    }

    func testEmptyModelResponse() async {
        await setupVenueSearchModel()
        let searchViewModel = VenueSearchViewModel(searchVenueModel: venueSearchModel)
        XCTAssertFalse(searchViewModel.isEmptyVenue)
    }

    func testListViewCardModelSetup() async {
        await setupVenueSearchModel()
        let searchViewModel = VenueSearchViewModel(searchVenueModel: venueSearchModel)
        let listModel = searchViewModel.listViewCardModel().first
        XCTAssert(listModel?.venueName == "Oatlands Plantation")
        XCTAssert(listModel?.categoryName == "Garden")
        XCTAssert(listModel?.iconImageLink == "https://ss3.4sqi.net/img/categories_v2/parks_outdoors/garden_120.png")
        XCTAssert(listModel?.distance == 5309)
        XCTAssert(listModel?.address == "20850 Oatlands Plantation Ln, Leesburg, VA 20175")
        XCTAssert(listModel?.distanceInMiles == "5309 \("venue.miles".localized())")
    }

    func testMapViewCardModelSetup() async {
        await setupVenueSearchModel()
        let searchViewModel = VenueSearchViewModel(searchVenueModel: venueSearchModel)
        let mapModel = searchViewModel.mapViewCardModel().first
        XCTAssert(mapModel?.venueName == "Oatlands Plantation")
        XCTAssert(mapModel?.categoryName == "Garden")
        XCTAssert(mapModel?.fsqId == "4be32fe621d5a593f56d1811")
        XCTAssert(mapModel?.distance == 5309)
        XCTAssert(mapModel?.latitude == 39.040916)
        XCTAssert(mapModel?.longitude == -77.617453)
        XCTAssertNil(mapModel?.imageUrl)
        XCTAssert(mapModel?.address == "20850 Oatlands Plantation Ln, Leesburg, VA 20175")
        XCTAssert(mapModel?.distanceInMiles == "5309 \("venue.miles".localized())")
    }

    func testCardImagedModelSetup() async {
        await setupVenueImageModel()
        let firstImageModel = venueImageModelArray?.first
        XCTAssert(firstImageModel?.prefix == "https://fastly.4sqi.net/img/general/")
        XCTAssert(firstImageModel?.suffix == "/27800740_x-4OG5BlJVV3XlvDvBO7I4E6jiOgZuKlTjTqNzmHbTs.jpg")
        XCTAssert(firstImageModel?.imageUrlString == "https://fastly.4sqi.net/img/general/original/27800740_x-4OG5BlJVV3XlvDvBO7I4E6jiOgZuKlTjTqNzmHbTs.jpg")
    }
}
