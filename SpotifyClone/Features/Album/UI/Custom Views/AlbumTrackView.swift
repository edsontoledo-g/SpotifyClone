//
//  AlbumTrackView.swift
//  SpotifyClone
//
//  Created by Edson Dario Toledo Gonzalez on 30/10/23.
//

import SwiftUI

struct AlbumTrackView: View {
    
    var item: AnyAlbumItemUi
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(item.name)
                Text(item.artists.asArtistNames().joined(separator: ", "))
                    .foregroundStyle(.secondary)
                    .font(.system(size: 15.0, weight: .regular))
            }
            Spacer()
            Button("", systemImage: "ellipsis", action: {})
                .buttonStyle(SecondaryButtonStyle())
        }
    }
}

#Preview {
    AlbumTrackView(item: AlbumSectionUi.sampleData.items[0])
        .preferredColorScheme(.dark)
        .tint(.white)
}
