//
//  HorizontalHomeSectionView.swift
//  SpotifyClone
//
//  Created by Edson Dario Toledo Gonzalez on 29/08/23.
//

import SwiftUI

struct HorizontalHomeSectionView: View {
    
    var homeSectionUi: HomeSectionUi
    
    var body: some View {
        VStack {
            headerView()
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 4.0) {
                    ForEach(homeSectionUi.items) { item in
                        AnySpotifyItemView(item: item)
                    }
                }
                .padding(.horizontal)
            }
        }
    }
    
    @ViewBuilder private func headerView() -> some View {
        if let relatedItem = homeSectionUi.relatedItem {
            HStack {
                CacheAsyncImage(url: URL(string: relatedItem.image)) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    Color.primaryGray.opacity(0.5)
                }
                .frame(width: 44.0, height: 44.0)
                .clipShape(Circle())
                VStack(alignment: .leading) {
                    Text(homeSectionUi.title ?? "")
                        .foregroundStyle(.secondary)
                        .font(.system(size: 12.0, weight: .medium))
                    Text(relatedItem.name)
                        .font(.system(size: 22.0, weight: .bold))
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal)
        } else {
            Text(homeSectionUi.title ?? "")
                .font(.system(size: 22.0, weight: .bold))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
        }
    }
}

#Preview {
    HorizontalHomeSectionView(homeSectionUi: HomeSectionUi.sampleData)
        .frame(height: 250.0)
        .preferredColorScheme(.dark)
}
