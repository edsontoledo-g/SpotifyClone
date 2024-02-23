//
//  PlaybarView.swift
//  SpotifyClone
//
//  Created by Edson Dario Toledo Gonzalez on 21/02/24.
//

import SwiftUI

struct PlaybarView: View {
    
    @Environment(PlaybarManager.self) private var playbarManager
    @State private var averageImageColor: UIColor = .clear
    
    var body: some View {
        HStack {
            HStack(spacing: 16.0) {
                AsyncImage(url: URL(string: playbarManager.playbarUi.image)) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .onChange(of: image) {
                            averageImageColor = image.averageColor
                        }
                        .onAppear {
                            averageImageColor = image.averageColor
                        }
                } placeholder: {
                    Color.primaryGray.opacity(0.5)
                        .aspectRatio(1.0, contentMode: .fit)
                }
                .clipShape(RoundedRectangle(cornerRadius: 8.0, style: .continuous))
                VStack(alignment: .leading) {
                    Text(playbarManager.playbarUi.name)
                        .font(.system(size: 15.0, weight: .semibold))
                    Text(playbarManager.playbarUi.asArtistNames().joined(separator: ", "))
                        .font(.system(size: 13.0, weight: .medium))
                        .foregroundStyle(.secondary)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            Button("", systemImage: playbarManager.status == .play ? "pause.fill" : "play.fill" , action: playbarHandler)
        }
        .padding(8.0)
        .frame(maxWidth: .infinity)
        .frame(height: 56.0)
        .background(backgroundView())
        .clipShape(RoundedRectangle(cornerRadius: 8.0, style: .continuous))
    }
    
    @ViewBuilder
    private func backgroundView() -> some View {
        if averageImageColor == .clear {
            Color.primaryGray
        } else {
            Color(uiColor: averageImageColor)
                .overlay(Color.black.opacity(0.5))
        }
    }
    
    private func playbarHandler() {
        switch playbarManager.status {
        case .play:
            playbarManager.pause()
        default:
            playbarManager.play()
        }
    }
}

#Preview {
    PlaybarView()
        .preferredColorScheme(.dark)
        .tint(.white)
        .environment(PlaybarManager(playbarUi: .sampleData))
}
