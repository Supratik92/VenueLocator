//
//  VenueListView.swift
//  VenueLocator
//
//  Created by Banerjee, Supratik on 18/07/22.
//

import SwiftUI
import SDWebImageSwiftUI

/// Venue List View
struct VenueListView: View {

    // MARK: - Properties & Constants
    struct VenueListViewConstants {
        static let imageHeight: CGFloat = 100
        static let imageWidth: CGFloat = 110
        static let marginTwelve: CGFloat = 12
        static let likeImageDimension: CGFloat = 20
        static let cornerRadius: CGFloat = 10
        static let colorOpacity: CGFloat = 0.5
        static let linearAnimationDelay: CGFloat = 0.5
    }

    /// Property to detect if venue is liked
    @State private var isVenueLiked = false

    /// View Model of VenueDetailsListViewModel
    @ObservedObject var viewModel: VenueDetailsListViewModel

    // MARK: - View
    var body: some View {
        scrollingListView
    }
}

/// Extension of Venue List View Supporting View Methods
extension VenueListView {

    /// List view of Venue
    private var scrollingListView: some View  {
        ZStack {
            ScrollView(showsIndicators: false) {
                ForEach(.zero..<viewModel.venueListDetailsInfoArray.count, id: \.self) { index in
                    venueDetailCardView(details: viewModel.venueListDetailsInfoArray[index])
                        .padding()
                }
            }
        }.background(
            LinearGradient(gradient: Gradient(colors: [Color.darkPurple.opacity(0.01), Color.white]),
                           startPoint: .top, endPoint: .bottom)
            .scaledToFill()
            .ignoresSafeArea()
        )
    }

    /// This method create list card view
    /// - Parameter details: VenueDetailsListModel
    /// - Returns: view
    private func venueDetailCardView(details: VenueDetailsListModel) -> some View {
        HStack(alignment: .top, spacing: VenueDetailsConstants.LayoutConstants.defaultMargin) {
            WebImage(url: URL(string: details.iconImageLink))
                .resizable()
                .placeholder(Image(systemName: "photo.fill"))
                .foregroundColor(.lightBlue)
                .scaledToFit()
                .frame(width: VenueListViewConstants.imageWidth, height: VenueListViewConstants.imageHeight)
            
            
            VStack(alignment: .leading, spacing: .zero) {
                HStack(alignment: .top, spacing: .zero) {
                    
                    let venueName = details.venueName
                    if !venueName.isEmpty {
                        Text(venueName)
                            .font(.helveticaFourteenBold)
                            .foregroundColor(.white)
                    }
                    
                    Spacer()
                    
                    Image(systemName: details.isFavourite ? VenueDetailsConstants.ImageName.thumbsUpChecked : VenueDetailsConstants.ImageName.thumbsUpUnchecked)
                        .resizable()
                        .foregroundColor(.white)
                        .frame(width: VenueListViewConstants.likeImageDimension, height: VenueListViewConstants.likeImageDimension)
                        .onTapGesture {
                            withAnimation(.linear(duration: VenueListViewConstants.linearAnimationDelay)) {
                                viewModel.updateFavourite(model: details)
                            }
                        }
                }
                
                let address = details.address
                if !address.isEmpty {
                    Text(address)
                        .font(.helveticaFourteen)
                        .foregroundColor(.white)
                        .padding(.bottom, VenueListViewConstants.marginTwelve)
                }
                
                HStack(alignment: .center, spacing: .zero) {
                    let category = details.categoryName
                    if !category.isEmpty {
                        Text("  \(category)  ")
                            .font(.helveticaFourteen)
                            .foregroundColor(.blue)
                            .background(Capsule().fill(Color.white))
                            .padding([.top, .bottom], VenueDetailsConstants.LayoutConstants.marginFour)
                            .padding(.trailing, VenueDetailsConstants.LayoutConstants.marginEight)

                    }
                    Spacer()
                    
                    let distance = details.distanceInMiles
                    if !distance.isEmpty {
                        Text("\(distance)")
                            .font(.helveticaTweleve)
                            .foregroundColor(.white)
                            .frame(alignment: .trailing)
                    }
                }.padding(.bottom, VenueDetailsConstants.LayoutConstants.defaultMargin)
            }.padding(.top, VenueDetailsConstants.LayoutConstants.defaultMargin)
            
            Spacer()
            
        }.frame(minHeight: VenueListViewConstants.imageHeight)
            .background(Color.blue)
            .cornerRadius(VenueListViewConstants.cornerRadius)
        
    }
}
