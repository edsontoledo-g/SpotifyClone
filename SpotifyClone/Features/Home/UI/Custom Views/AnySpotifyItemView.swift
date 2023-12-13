//
//  AnySpotifyItemView.swift
//  SpotifyClone
//
//  Created by Edson Dario Toledo Gonzalez on 29/08/23.
//

import SwiftUI

struct AnySpotifyItemView: View {
    
    @Environment(Router.self) private var router
    var item: AnySpotifyItemUi
    
    var body: some View {
        VStack {
            AsyncImage(url: URL(string: item.image)) { image in
                imageView(from: image)
            } placeholder: {
                placeholderView()
            }
            Text(item.name)
                .font(.system(size: 12.0, weight: .semibold))
                .lineLimit(1)
                .frame(maxWidth: .infinity)
        }
        .aspectRatio(1.0, contentMode: .fill)
        .onTapGesture(perform: itemPressed)
    }
    
    @ViewBuilder func imageView(from image: Image) -> some View {
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
    
    @ViewBuilder func placeholderView() -> some View {
        if item.type == .artist {
            Color.primaryGray.opacity(0.5)
                .clipShape(Circle())
        } else {
            Color.primaryGray.opacity(0.5)
                .clipShape(Rectangle())
        }
    }
    
    private func itemPressed() {
        switch item.type {
        case .artist:
            router.navigate(to: .artistDetail(id: item.id))
        case .track:
            router.navigate(to: .albumDetail(id: item.id))
        }
    }
}

#Preview {
    AnySpotifyItemView(item: HomeSectionUi.sampleData.items[0])
        .frame(width: 200.0, height: 200.0)
        .preferredColorScheme(.dark)
        .environment(Router())
}
