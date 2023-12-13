//
//  AnySpotifyItemRowView.swift
//  SpotifyClone
//
//  Created by Edson Dario Toledo Gonzalez on 28/11/23.
//

import SwiftUI

struct AnySpotifyItemRowView: View {
    
    @Environment(Router.self) private var router
    var item: AnySpotifyItemUi
    
    var body: some View {
        HStack(spacing: 8.0) {
            AsyncImage(url: URL(string: item.image)) { image in
                imageView(from: image)
            } placeholder: {
                placeholderView()
            }
            VStack(alignment: .leading) {
                Text(item.name)
                    .font(.system(size: 17.0, weight: .semibold))
                Text(item.type.name)
                    .font(.system(size: 15.0, weight: .medium))
                    .foregroundStyle(.secondary)
            }
            Spacer()
            Image(systemName: "chevron.right")
                .fontWeight(.semibold)
                .foregroundStyle(.secondary)
        }
        .onTapGesture(perform: itemPressed)
    }
    
    @ViewBuilder private func imageView(from image: Image) -> some View {
        if item.type == .artist {
            image
                .resizable()
                .aspectRatio(1.0, contentMode: .fit)
                .clipShape(Circle())
        } else {
            image
                .resizable()
                .aspectRatio(1.0, contentMode: .fit)
                .clipShape(Rectangle())
        }
    }
    
    @ViewBuilder private func placeholderView() -> some View {
        if item.type == .artist {
            Color.primaryGray.opacity(0.5)
                .aspectRatio(1.0, contentMode: .fit)
                .clipShape(Circle())
        } else {
            Color.primaryGray.opacity(0.5)
                .aspectRatio(1.0, contentMode: .fit)
                .clipShape(Rectangle())
        }
    }
    
    private func itemPressed() {
        switch item.type {
        case .track:
            router.navigate(to: .albumDetail(id: item.id))
        case .artist:
            router.navigate(to: .artistDetail(id: item.id))
        }
    }
}

#Preview {
    AnySpotifyItemRowView(item: HomeSectionUi.sampleData.items[0])
    .frame(height: 56.0)
    .preferredColorScheme(.dark)
    .tint(.white)
    .environment(Router())
}
