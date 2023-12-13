//
//  ArtistReleaseView.swift
//  SpotifyClone
//
//  Created by Edson Dario Toledo Gonzalez on 31/10/23.
//

import SwiftUI

struct ArtistReleaseView: View {
    
    @Environment(Router.self) private var router
    var item: AnyArtistItemUi
    
    var body: some View {
        HStack(spacing: 16.0) {
            AsyncImage(url: URL(string: item.image)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                Color.primaryGray.opacity(0.5)
            }
            .frame(width: 88.0, height: 88.0)
            VStack(alignment: .leading, spacing: 4.0) {
                Text(item.name)
                    .font(.system(size: 17.0, weight: .bold))
                Text(item.releaseDate ?? "")
                    .font(.system(size: 15.0, weight: .regular))
                    .foregroundStyle(.secondary)
            }
            Spacer()
        }
        .onTapGesture(perform: itemPressed)
    }
    
    private func itemPressed() {
        router.navigate(to: .albumDetail(id: item.id))
    }
}

#Preview {
    ArtistReleaseView(item: ArtistSectionUi.sampleData.items[0])
        .preferredColorScheme(.dark)
        .tint(.white)
        .environment(Router())
}
