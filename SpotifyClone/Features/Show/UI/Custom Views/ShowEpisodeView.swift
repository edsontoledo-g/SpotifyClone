//
//  ShowEpisodeView.swift
//  SpotifyClone
//
//  Created by Edson Dario Toledo Gonzalez on 25/12/23.
//

import SwiftUI

struct ShowEpisodeView: View {
    
    var item: AnyShowItemUi
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8.0) {
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
                Text(item.name)
                    .font(.system(size: 17, weight: .medium))
            }
            Text(item.description)
                .lineLimit(2)
                .font(.system(size: 15.0, weight: .regular))
                .foregroundStyle(.secondary)
            Text(item.releaseDate)
                .font(.system(size: 15.0, weight: .medium))
            HStack {
                ForEach(OptionAction.allCases, id: \.rawValue) { optionAction in
                    Button("", systemImage: optionAction.imageName) {
                        optionActionPressed(optionAction)
                    }
                }
                .buttonStyle(SecondaryButtonStyle())
                Spacer()
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
    
    private func optionActionPressed(_ optionAction: OptionAction) {
        switch optionAction {
        case .addToLibrary:
            addToLibraryButtonPressed()
        case .download:
            downloadButtonPressed()
        case .share:
            shareButtonPressed()
        case .more:
            moreButtonPressed()
        }
    }
    
    private func addToLibraryButtonPressed() {}
    private func downloadButtonPressed() {}
    private func shareButtonPressed() {}
    private func moreButtonPressed() {}
}

extension ShowEpisodeView {
    
    enum OptionAction: String, CaseIterable {
        case addToLibrary
        case download
        case share
        case more
        
        var imageName: String {
            switch self {
            case .addToLibrary:
                "plus.circle"
            case .download:
                "arrow.down.circle"
            case .share:
                "square.and.arrow.up"
            case .more:
                "ellipsis"
            }
        }
    }
}

#Preview {
    ShowEpisodeView(item: ShowSectionUi.sampleData.items[1])
        .preferredColorScheme(.dark)
        .tint(.white)
}
