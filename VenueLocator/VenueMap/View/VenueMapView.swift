//
//  VenueMapView.swift
//  VenueLocator
//
//  Created by Banerjee, Supratik on 18/07/22.
//

import SwiftUI
import MapKit
import SDWebImageSwiftUI

/// Venue Carouse Map View
struct VenueMapView: View {

    // MARK: - Constants 
    private struct VenueMapViewConstants {
        static let annotationDimension: CGFloat = 30
        static let carouselViewHeight: CGFloat = 300
        static let animationDuration: Double = 0.5
        static let cornerRadius: CGFloat = 10
        static let marginTwelve: CGFloat = 12
        static let likeImageDimension: CGFloat = 20
        static let colorOpacity: CGFloat = 0.5
        static let linearAnimationDelay: CGFloat = 0.5
        static let imageHeight: CGFloat = 160
        static let carouselBottomPadding: CGFloat = 40
        static let indicatorSpacing: CGFloat = 2
        static let indicatorWidth: CGFloat = 30
        static let indicatorHeight: CGFloat = 5
    }

    /// View Model instance of Map view
    @ObservedObject var viewModel: VenueMapViewModel

    /// Property to provide loading indicator
    @Binding var isLoading: Bool

    /// Body of Map view
    var body: some View {
        ZStack(alignment: .bottom) {
            // creating maps here
            Map(coordinateRegion: $viewModel.region, interactionModes: .all, showsUserLocation: false, userTrackingMode: .constant(.follow), annotationItems: viewModel.venueDetailsMapArray) { pin in
                MapAnnotation(coordinate: pin.coordinates) {
                    Button(action: {
                        withAnimation {
                            viewModel.setZoomLevel(pin: pin)
                        }

                    }, label: {
                        Image(systemName: VenueDetailsConstants.ImageName.pin)
                            .resizable()
                            .frame(width: VenueMapViewConstants.annotationDimension,
                                   height: VenueMapViewConstants.annotationDimension)
                            .foregroundColor(.red)
                    })
                }
            }.onChange(of: viewModel.currentIndex) { newValue in
                withAnimation(.easeIn(duration: VenueMapViewConstants.animationDuration)) {
                    viewModel.setZoomLevel(index: newValue)
                }
            }
            mapCarouselView
                .padding(.bottom, VenueMapViewConstants.carouselBottomPadding)
        }.animation(.default, value: true)
    }
}

/// Extension of VenueMapView for supporting views
extension VenueMapView {

    /// Map Carousel View
    private var mapCarouselView: some View {
        VStack {
            TabView(selection: $viewModel.currentIndex) {
                ForEach((.zero..<viewModel.venueDetailsMapArray.count), id: \.self) { index in
                    venueDetailCardView(details: viewModel.venueDetailsMapArray[index])
                        .padding()
                }
            }.tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .frame(height: VenueMapViewConstants.carouselViewHeight)

            HStack(spacing: VenueMapViewConstants.indicatorSpacing) {
                ForEach((.zero..<viewModel.venueDetailsMapArray.count), id: \.self) { index in
                    Rectangle()
                        .fill(index == viewModel.currentIndex ? .blue : .blue.opacity(VenueMapViewConstants.colorOpacity))
                        .frame(width: VenueMapViewConstants.indicatorWidth, height: VenueMapViewConstants.indicatorHeight)
                }
            }
        }

    }

    /// This method create card view for carousel
    /// - Parameter details: VenueDetailsMapModel
    /// - Returns: view
    private func venueDetailCardView(details: VenueDetailsMapModel) -> some View {
        VStack(alignment: .center) {
            if let imageUrl = details.imageUrl {
                WebImage(url: URL(string: imageUrl))
                    .resizable()
                    .placeholder(Image(systemName: "photo.fill"))
                    .foregroundColor(.lightBlue)
                    .frame(height: VenueMapViewConstants.imageHeight)

            } else {
                Rectangle()
                    .foregroundColor(.white)
                    .frame(height: VenueMapViewConstants.imageHeight)
                    .redacted(reason: details.imageUrl == nil ? .placeholder : [])
            }

            Spacer()

            VStack(alignment: .leading, spacing: .zero) {
                HStack(alignment: .top, spacing: .zero) {

                    let venueName = details.venueName
                    if !venueName.isEmpty {
                        Text(venueName)
                            .font(.helveticaFourteenBold)
                            .foregroundColor(.darkerGray)
                    }

                    Spacer()

                    Image(systemName: details.isFavourite ? VenueDetailsConstants.ImageName.thumbsUpChecked : VenueDetailsConstants.ImageName.thumbsUpUnchecked)
                        .resizable()
                        .foregroundColor(.iceBlue)
                        .frame(width: VenueMapViewConstants.likeImageDimension, height: VenueMapViewConstants.likeImageDimension)
                        .onTapGesture {
                            withAnimation(.linear(duration: VenueMapViewConstants.linearAnimationDelay)) {
                                viewModel.updateFavourite(model: details)
                            }
                        }
                }

                let address = details.address
                if !address.isEmpty {
                    Text(address)
                        .font(.helveticaFourteen)
                        .foregroundColor(.darkerGray)
                        .padding(.bottom, VenueMapViewConstants.marginTwelve)
                }

                HStack(alignment: .center, spacing: .zero) {
                    let license = details.categoryName
                    if  !license.isEmpty {
                        Text(license)
                            .font(.helveticaFourteen)
                            .foregroundColor(.offGreen)
                            .padding([.top, .bottom], VenueDetailsConstants.LayoutConstants.marginFour)
                            .padding([.leading, .trailing], VenueDetailsConstants.LayoutConstants.marginEight)
                            .overlay(Rectangle()
                                .foregroundColor(.blue.opacity(VenueMapViewConstants.colorOpacity))
                                .cornerRadius(VenueMapViewConstants.cornerRadius))

                    }
                    Spacer()

                    let distance = details.distanceInMiles
                    if !distance.isEmpty {
                        Text("\(distance)")
                            .font(.helveticaTweleve)
                            .foregroundColor(.darkerGray)
                            .frame(alignment: .trailing)
                    }
                }
            }.padding()
        }.frame(height: VenueMapViewConstants.carouselViewHeight)
            .background(Color.white)
            .cornerRadius(VenueMapViewConstants.cornerRadius)
            .onReceive(viewModel.$currentIndex) { _ in
                setImage()
            }

    }
}

/// Extension VenueMapView for view setup
extension VenueMapView {

    /// This method setups image for card  by calling service
    private func setImage() {
        Task.init {
            do {
                try await viewModel.venueSearchRequest()
            } catch { }
        }
    }
}
