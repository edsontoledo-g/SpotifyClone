//
//  TopTracksSectionView.swift
//  SpotifyClone
//
//  Created by Edson Dario Toledo Gonzalez on 29/08/23.
//

import SwiftUI

struct TopTracksSectionView: View {
    
    @Environment(Router.self) private var router
    var homeSectionUi: HomeSectionUi
    
    private let columns = [
        GridItem(.adaptive(minimum: 150.0, maximum: 200.0), spacing: 8.0),
        GridItem(.adaptive(minimum: 150.0, maximum: 200.0), spacing: 8.0),
    ]
    
    var body: some View {
        LazyVGrid(columns: columns) {
            ForEach(homeSectionUi.items) { item in
                userTopItemView(item: item)
                    .frame(height: 56.0)
                    .onTapGesture { itemPressed(item) }
            }
        }
        .padding(.horizontal)
    }
    
    private func userTopItemView(item: AnySpotifyItemUi) -> some View {
        HStack(spacing: .zero) {
            CacheAsyncImage(url: URL(string: item.image)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                Color.primaryGray.opacity(0.5)
            }
            .frame(width: 56.0)
            Text(item.name)
                .font(.system(size: 12.0, weight: .bold))
                .padding(8.0)
            Spacer()
        }
        .background(.primaryGray)
        .clipShape(RoundedRectangle(cornerRadius: 4.0, style: .continuous))
    }
    
    private func itemPressed(_ item: AnySpotifyItemUi) {
        switch item.type {
        case .artist:
            router.navigate(to: .artistDetail(id: item.id))
        case .track:
            router.navigate(to: .albumDetail(id: item.id))
        default:
            break
        }
    }
}

#Preview {
    TopTracksSectionView(homeSectionUi: HomeSectionUi.sampleData)
        .preferredColorScheme(.dark)
        .previewLayout(.sizeThatFits)
        .environment(Router())
}
