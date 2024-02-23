//
//  AlbumTrackView.swift
//  SpotifyClone
//
//  Created by Edson Dario Toledo Gonzalez on 30/10/23.
//

import SwiftUI

struct AlbumTrackView: View {
    
    @Environment(PlaybarManager.self) private var playbarManager
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
        .onTapGesture { playbarManager.play(playbarUi: item.asPlaybarUi()) }
    }
}

#Preview {
    AlbumTrackView(item: AlbumSectionUi.sampleData.items[0])
        .preferredColorScheme(.dark)
        .tint(.white)
        .environment(PlaybarManager())
}
