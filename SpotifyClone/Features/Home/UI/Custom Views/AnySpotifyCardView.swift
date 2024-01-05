//
//  AnySpotifyCardView.swift
//  SpotifyClone
//
//  Created by Edson Dario Toledo Gonzalez on 26/12/23.
//

import SwiftUI

struct AnySpotifyCardView: View {
    
    var item: AnySpotifyItemUi
    
    var body: some View {
        VStack {
            CacheAsyncImage(url: URL(string: item.image)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                Color.secondary.opacity(0.1)
            }
            .aspectRatio(1.0, contentMode: .fit)
            .clipShape(RoundedRectangle(cornerRadius: 8.0))
            VStack(alignment: .leading, spacing: 16.0) {
                Text(item.name)
                    .font(.system(size: 20.0, weight: .bold))
                Text(item.description)
                    .lineLimit(3)
                    .font(.system(size: 15.0, weight: .regular))
                    .foregroundStyle(.secondary)
                HStack (spacing: 16.0){
                    HStack {
                        Button("", systemImage: "plus.circle") {}
                        Button("", systemImage: "ellipsis") {}
                    }
                    .buttonStyle(SecondaryButtonStyle())
                    Spacer()
                    Text(item.caption)
                        .foregroundStyle(.secondary)
                        .font(.system(size: 12.0, weight: .medium))
                    Button(action: {}) {
                        Image(systemName: "play.fill")
                    }
                    .foregroundStyle(.black)
                    .padding(8.0)
                    .background(.white)
                    .clipShape(Circle())
                }
            }
        }
        .padding(.horizontal, 32.0)
        .padding(.vertical)
        .background(.primaryGray)
        .clipShape(RoundedRectangle(cornerRadius: 16.0))
    }
}

#Preview {
    AnySpotifyCardView(item: HomeSectionUi.sampleData.items[0])
        .preferredColorScheme(.dark)
        .tint(.white)
}
