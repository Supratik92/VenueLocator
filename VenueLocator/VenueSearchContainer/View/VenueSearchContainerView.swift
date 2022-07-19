//
//  VenueSearchContainerView.swift
//  VenueLocator
//
//  Created by Banerjee, Supratik on 18/07/22.
//

import SwiftUI

/// VenueSearchContainerView as a base view
struct VenueSearchContainerView: View {

    private struct VenueSearchContainerViewConstants {
        static let defaultMaxRadius: Double = 100000
        static let opacityBackgroundColor: CGFloat = 0.8
        static let cornerRadiusSlider: CGFloat = 0.5
    }
    // MARK: - Properties & Variable

    @StateObject private var venueDetailsContainerViewModel = VenueSearchViewModel()

    /// Property to progress indicator the data
    @State private var isLoading = false

    /// Property to save default selected tab
    @State private var defaultSelectedTab: VenueDetailsSegments = .listView

    /// Property to show Network Error
    @State private var showError: Bool = false

    /// Property to show error description
    @State private var errorDescription: String = .emptyString

    @State private var segmentOffset = CGFloat.zero

    var body: some View {
        VStack(alignment: .center, spacing: .zero) {

            // Tab View
            VenueSearchContainerSegmentView(selectedTab: $defaultSelectedTab)

            sliderView
                .padding([.top, .leading, .trailing], VenueDetailsConstants.LayoutConstants.defaultMargin)

            ZStack {
                GeometryReader { geometry in
                    if venueDetailsContainerViewModel.isEmptyVenue {
                        noVenueFoundView
                    } else {
                        HStack(spacing: .zero) {
                            if defaultSelectedTab == .mapView {
                                VenueMapView(viewModel: VenueMapViewModel(venueDetailsMapArray: venueDetailsContainerViewModel.mapViewCardModel()), isLoading: $isLoading)
                                    .frame(width: geometry.frame(in: .global).width)
                                    .redacted(reason: isLoading ? .placeholder : [])
                            } else {
                                VenueListView(viewModel: VenueDetailsListViewModel(venueListDetailsInfoArray: venueDetailsContainerViewModel.listViewCardModel()))
                                    .frame(width: geometry.frame(in: .global).width)
                                    .redacted(reason: isLoading ? .placeholder : [])
                            }
                        }
                        .offset(x: segmentOffset)
                    }
                }
                if isLoading {
                    ProgressView("venue.loading".localized())
                }
            }

        }.animation(.default, value: true)
            .background(Color.clear)
            .onAppear {
                VenueLocationManager.sharedInstance.startUpdatingLocation()
            }
            .alert(isPresented: $showError) {
                Alert(title: Text("venue.errorText".localized()),
                      message: Text(errorDescription),
                      dismissButton: .default(Text("venue.okay".localized())))
            }
            .onReceive(VenueLocationManager.sharedInstance.updatedLocationPassthroughSubject) { isLocationUpdated in
                if let isLocationUpdated = isLocationUpdated, isLocationUpdated {
                    loadVenueSearchResults(coordinates: VenueLocationManager.sharedInstance.userLocationCoordinates)
                } else {
                    loadVenueSearchResults()
                }
            }
    }
}

/// Extension of VenueSearchContainerView for supporting views
extension VenueSearchContainerView {

    /// Slider view
    private var sliderView: some View {
        VStack(alignment: .leading) {
            Slider(value: $venueDetailsContainerViewModel.searchRadius, in: .zero...VenueSearchContainerViewConstants.defaultMaxRadius)
            HStack {
                Text("\("venue.searchRadius".localized()) \(Int(venueDetailsContainerViewModel.searchRadius))")
                    .font(.helveticaFourteenBold)
                    .foregroundColor(.darkerGray)

                Spacer()

                Button("venue.apply") {
                    loadVenueSearchResults(coordinates: VenueLocationManager.sharedInstance.userLocationCoordinates)
                }
                .padding()
                .background(Color.buttonBlue.opacity(VenueSearchContainerViewConstants.opacityBackgroundColor))
                .clipShape(Capsule())
            }
        }.padding()
            .background(Color.iceBlue)
            .cornerRadius(VenueSearchContainerViewConstants.cornerRadiusSlider)
    }

    /// No venue found View
    private var noVenueFoundView: some View {
        VStack(alignment: .center, spacing: VenueDetailsConstants.LayoutConstants.defaultMargin) {

            venueTextView(text: "venue.noRecordsFound", font: .helveticaSixteen)

            venueTextView(text: "venue.increaseRadius", font: .helveticaFourteen)
                .multilineTextAlignment(.center)

        }.padding(.top, VenueDetailsConstants.LayoutConstants.marginSixtyFour)
            .padding([.leading, .trailing], VenueDetailsConstants.LayoutConstants.marginTwentyFour)
    }

    /// This method creates a text view for Venue Details
    /// - Parameters:
    ///   - text: The text
    ///   - font: font of text
    /// - Returns: View
    @ViewBuilder private func venueTextView(text: String?, font: Font) -> some View {
        if let text = text, !text.isEmpty {
            Text(text.localized())
                .foregroundColor(.darkerGray)
                .font(font)
                .frame(alignment: .center)
                .fixedSize(horizontal: false, vertical: true)
        }
    }

}

/// Extension of VenueSearchContainerView for operational methods
extension VenueSearchContainerView {
    /// This method initiate search request
    /// - Parameter coordinates: Coordinates of user
    private func loadVenueSearchResults(coordinates: (latitude: Double, longitude: Double)? = nil) {
        Task.init {
            do {
                isLoading = true
                try await venueDetailsContainerViewModel.venueSearchRequest(latitude: coordinates?.latitude, longitude: coordinates?.longitude)
                isLoading = false
            } catch {
                showError = true
            }
        }
    }
}
