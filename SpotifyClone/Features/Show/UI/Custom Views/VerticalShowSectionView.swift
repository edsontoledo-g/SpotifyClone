//
//  VerticalShowSectionView.swift
//  SpotifyClone
//
//  Created by Edson Dario Toledo Gonzalez on 24/12/23.
//

import SwiftUI

struct VerticalShowSectionView: View {
    
    var showSectionUi: ShowSectionUi
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(showSectionUi.title ?? "")
                .font(.system(size: 17.0, weight: .bold))
                .padding(.horizontal)
            VStack(spacing: 16.0) {
                ForEach(showSectionUi.items) { item in
                    ShowEpisodeView(item: item)
                        .padding(.horizontal)
                    Color.primaryGray
                        .frame(height: 1.0)
                        .padding(.leading)
                }
            }
        }
    }
}

#Preview {
    VerticalShowSectionView(showSectionUi: ShowSectionUi.sampleData)
        .preferredColorScheme(.dark)
        .tint(.white)
}
