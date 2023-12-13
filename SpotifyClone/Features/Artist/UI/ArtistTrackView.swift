//
//  ArtistTrackView.swift
//  SpotifyClone
//
//  Created by Edson Dario Toledo Gonzalez on 22/10/23.
//

import SwiftUI

struct ArtistTrackView: View {
    
    var item: AnyArtistItemUi
    
    var body: some View {
        HStack {
            Text(item.itemNumber?.description ?? "")
                .font(.system(size: 15.0, weight: .regular))
            AsyncImage(url: URL(string: item.image)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                Color.primaryGray.opacity(0.5)
            }
            .frame(width: 44.0, height: 44.0)
            Text(item.name)
                .lineLimit(1)
            Spacer()
            Button("", systemImage: "ellipsis") {}
                .foregroundStyle(.secondary)
        }
    }
}

#Preview {
    ArtistTrackView(item: ArtistSectionUi.sampleData.items[0])
        .preferredColorScheme(.dark)
        .tint(.white)
}
