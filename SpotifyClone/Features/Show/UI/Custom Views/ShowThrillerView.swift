//
//  ShowThrillerView.swift
//  SpotifyClone
//
//  Created by Edson Dario Toledo Gonzalez on 25/12/23.
//

import SwiftUI

struct ShowThrillerView: View {
    
    var item: AnyShowItemUi
    
    var body: some View {
        HStack(spacing: 16.0) {
            AsyncImage(url: URL(string: item.image)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                Color.primaryGray.opacity(0.5)
            }
            .frame(width: 64.0, height: 64.0)
            .clipShape(RoundedRectangle(cornerRadius: 8.0))
            VStack(alignment: .leading, spacing: 8.0) {
                Text(item.name)
                    .font(.system(size: 17, weight: .medium))
                HStack {
                    thrillerTagView()
                    Text(item.durationTime)
                        .font(.system(size: 15.0, weight: .medium))
                        .foregroundStyle(.secondary)
                }
            }
            Spacer()
            Button("", systemImage: "ellipsis") {}
        }
        .padding()
        .background(.primaryGray)
        .clipShape(RoundedRectangle(cornerRadius: 8.0))
    }
    
    private func thrillerTagView() -> some View {
        Text("Thriller".uppercased())
            .font(.system(size: 12.0, weight: .medium))
            .foregroundStyle(.black)
            .padding(4.0)
            .background(Color.secondary)
            .clipShape(RoundedRectangle(cornerRadius: 4.0))
    }
}

#Preview {
    ShowThrillerView(item: ShowSectionUi.sampleData.items[0])
        .preferredColorScheme(.dark)
        .tint(.white)
}
