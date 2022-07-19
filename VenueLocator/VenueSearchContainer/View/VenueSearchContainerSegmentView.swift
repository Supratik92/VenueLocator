//
//  VenueSearchContainerSegmentView.swift
//  VenueLocator
//
//  Created by Banerjee, Supratik on 18/07/22.
//

import SwiftUI

/// Enum to store Segment details of map or list view
enum VenueDetailsSegments: Int {
    /// Map view
    case mapView
    /// List View
    case listView

    /// Title of Segment
    var title: String {
        switch self {
        case .mapView:
            return "venue.map"
        case .listView:
            return "venue.list"
        }
    }
}

struct VenueSearchContainerSegmentView: View {

    // MARK: - Saved Segment Bar View
    private struct VenueSearchContainerSegmentViewConstants {
        static let segmentTextPadding: CGFloat = 6
        static let cardCornerRadius: CGFloat = 10
        static let imageFrame: CGFloat = 40
    }

    // MARK: - Properties

    /// Property to handle selected tab
    @Binding var selectedTab: VenueDetailsSegments


    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                buttonView(for: .listView, isSelected: .constant(selectedTab == .listView), action: {
                    selectedTab = .listView
                }).accessibilityIdentifier(VenueDetailsSegments.listView.title)

                buttonView(for: .mapView, isSelected: .constant(selectedTab == .mapView), action: {
                    selectedTab = .mapView
                }).accessibilityIdentifier(VenueDetailsSegments.mapView.title)
            }
        }.padding([.leading, .trailing], VenueDetailsConstants.LayoutConstants.defaultMargin)
            .cornerRadius(VenueSearchContainerSegmentViewConstants.cardCornerRadius)
    }
}

// MARK: - Supporting Views for Tote Segment
extension VenueSearchContainerSegmentView {

    /// This method creates button
    /// - Parameters:
    ///   - segment: Selected Segments
    ///   - isSelected: Is selected
    ///   - action: action of segment
    /// - Returns: some view
    private func buttonView(for segment: VenueDetailsSegments, isSelected: Binding<Bool>, action: @escaping () -> Void) -> some View {
        Button(action: { action() },
               label: {
            VStack(spacing: VenueDetailsConstants.LayoutConstants.defaultMargin) {
                HStack {
                    Image(systemName: segment == .mapView ? VenueDetailsConstants.ImageName.map : VenueDetailsConstants.ImageName.list)
                        .foregroundColor(.lightBlue)
                        .frame(width: VenueSearchContainerSegmentViewConstants.imageFrame, height: VenueSearchContainerSegmentViewConstants.imageFrame)

                    Text(segment.title.localized())
                        .foregroundColor(Color.gray)
                        .font(isSelected.wrappedValue == true ? .subheadline.bold() : .subheadline)
                }
                .padding(.top, VenueDetailsConstants.LayoutConstants.marginEight)
                .padding(.bottom, VenueDetailsConstants.LayoutConstants.marginFour)

                Capsule()
                    .fill(isSelected.wrappedValue == true ? Color.lightBlue : Color.clear)
                    .frame(height: VenueDetailsConstants.LayoutConstants.marginTwo)
            }
        })
    }
}

