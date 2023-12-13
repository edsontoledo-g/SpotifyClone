//
//  VerticalAlbumSectionView.swift
//  SpotifyClone
//
//  Created by Edson Dario Toledo Gonzalez on 31/10/23.
//

import SwiftUI

struct VerticalAlbumSectionView: View {
    
    var albumSectionUi: AlbumSectionUi
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(albumSectionUi.title ?? "")
                .font(.system(size: 17.0, weight: .bold))
            VStack(spacing: 16.0) {
                ForEach(albumSectionUi.items) { item in
                    AlbumTrackView(item: item)
                }
            }
        }
        .padding(.horizontal)
    }
}

#Preview {
    VerticalAlbumSectionView(albumSectionUi: AlbumSectionUi.sampleData)
        .preferredColorScheme(.dark)
        .tint(.white)
}
