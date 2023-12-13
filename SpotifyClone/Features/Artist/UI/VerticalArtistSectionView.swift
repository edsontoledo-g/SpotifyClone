//
//  VerticalArtistSectionView.swift
//  SpotifyClone
//
//  Created by Edson Dario Toledo Gonzalez on 22/10/23.
//

import SwiftUI

struct VerticalArtistSectionView: View {
    
    var artistSectionUi: ArtistSectionUi
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(artistSectionUi.title)
                .font(.system(size: 17.0, weight: .bold))
            VStack(spacing: 16.0) {
                ForEach(artistSectionUi.items) { item in
                    switch artistSectionUi.type {
                    case .topTracks:
                        ArtistTrackView(item: itemUpdated(item))
                    case .topReleases:
                        ArtistReleaseView(item: item)
                    default:
                        EmptyView()
                    }
                }
            }
        }
    }
    
    private func itemUpdated(_ item: AnyArtistItemUi) -> AnyArtistItemUi {
        guard let index = artistSectionUi.items.firstIndex(of: item) else { return item }
        var item = item
        item.itemNumber = index + 1
        return item
    }
}

#Preview {
    VerticalArtistSectionView(artistSectionUi: ArtistSectionUi.sampleData)
        .preferredColorScheme(.dark)
}
