//
//  VerticalCarouselHomeSectionView.swift
//  SpotifyClone
//
//  Created by Edson Dario Toledo Gonzalez on 29/12/23.
//

import SwiftUI

struct VerticalCarouselHomeSectionView: View {
    
    var homeSectionUi: HomeSectionUi
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack {
                ForEach(homeSectionUi.items) { item in
                    AnySpotifyCardView(item: item)
                        .containerRelativeFrame(.vertical)
                }
            }
        }
        .scrollTargetBehavior(.paging)
    }
}

#Preview {
    VerticalCarouselHomeSectionView(homeSectionUi: HomeSectionUi.sampleData)
        .preferredColorScheme(.dark)
        .tint(.white)
}
