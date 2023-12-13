//
//  HorizontalArtistSectionView.swift
//  SpotifyClone
//
//  Created by Edson Dario Toledo Gonzalez on 31/10/23.
//

import SwiftUI

struct HorizontalArtistSectionView: View {
    
    var artistSectionUi: ArtistSectionUi
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(artistSectionUi.title)
                .font(.system(size: 17.0, weight: .bold))
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(artistSectionUi.items) { item in
                        switch artistSectionUi.type {
                        case .relatedArtists:
                            AnySpotifyItemView(item: item.asAnySpotifyItemUi())
                        default:
                            EmptyView()
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    HorizontalArtistSectionView(artistSectionUi: ArtistSectionUi.sampleData)
        .preferredColorScheme(.dark)
        .tint(.white)
}
