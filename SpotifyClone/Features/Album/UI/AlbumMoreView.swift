//
//  AlbumMoreView.swift
//  SpotifyClone
//
//  Created by Edson Dario Toledo Gonzalez on 23/11/23.
//

import SwiftUI

struct AlbumMoreView: View {
    
    @Binding var showAlbumMoreView: Bool
    var albumUi: AlbumUi
    
    var body: some View {
        ScrollView {
            VStack(spacing: 56.0) {
                coverView()
                optionsView()
            }
            .frame(maxWidth: .infinity)
            .padding(.top, 96.0)
        }
        .background(.ultraThinMaterial)
        .safeAreaInset(edge: .bottom) {
            Button("Close", action: closeButtonPressed)
        }
        .toolbar(.hidden, for: .tabBar)
    }
    
    @MainActor private func coverView() -> some View {
        VStack(spacing: 16.0) {
            AsyncImage(url: URL(string: albumUi.image)) { image in
                VStack(spacing: .zero) {
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 150.0, height: 150.0)
                    HStack {
                        Image(.spotifyLogoWhite)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                        Image(systemName: "waveform")
                            .imageScale(.large)
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 24.0)
                    .padding(.vertical, 8.0)
                }
                .frame(width: 150.0)
                .background(Color(uiColor: image.averageColor))
            } placeholder: {
                Color.clear
                    .frame(width: 150.0, height: 175.0)
            }
            VStack(spacing: 8.0) {
                Text(albumUi.name)
                    .font(.system(size: 17.0, weight: .bold))
                Text(albumUi.asMainArtistName())
                    .font(.system(size: 13.0, weight: .medium))
                    .foregroundStyle(.secondary)
                
            }
        }
    }
    
    private func optionsView() -> some View {
        VStack(alignment: .leading, spacing: 32.0) {
            ForEach(OptionAction.allCases, id: \.rawValue) { optionAction in
                MenuButton(
                    systemImage: optionAction.imageName,
                    title: optionAction.name,
                    action: { optionActionPressed(optionAction) }
                )
            }
        }
    }
    
    private func optionActionPressed(_ optionAction: OptionAction) {
        switch optionAction {
        case .addToLibrary:
            addToLibraryButtonPressed()
        case .seeArtist:
            seeArtistButtonPressed()
        case .share:
            shareButtonPressed()
        case .addToPlaylist:
            addToPlaylistButtonPressed()
        case .addToQueue:
            addToQueueButtonPressed()
        case .startJam:
            startJamButtonPressed()
        case .goToRadio:
            goToRadioButtonPressed()
        }
    }
    
    private func closeButtonPressed() {
        withAnimation(.bouncy) {
            showAlbumMoreView = false
        }
    }
    
    private func addToLibraryButtonPressed() {}
    private func seeArtistButtonPressed() {}
    private func shareButtonPressed() {}
    private func addToPlaylistButtonPressed() {}
    private func addToQueueButtonPressed() {}
    private func startJamButtonPressed() {}
    private func goToRadioButtonPressed() {}
}

extension AlbumMoreView {
    
    enum OptionAction: String, CaseIterable {
        case addToLibrary
        case seeArtist
        case share
        case addToPlaylist
        case addToQueue
        case startJam
        case goToRadio
        
        var name: String {
            switch self {
            case .addToLibrary: "Add to your library"
            case .seeArtist: "See artist"
            case .share: "Share"
            case .addToPlaylist: "Add to playlist"
            case .addToQueue: "Add to queue"
            case .startJam: "Start Jam"
            case .goToRadio: "Go to radio"
            }
        }
        
        var imageName: String {
            switch self {
            case .addToLibrary: "plus.circle"
            case .seeArtist: "person.wave.2"
            case .share: "square.and.arrow.up"
            case .addToPlaylist: "plus.circle"
            case .addToQueue: "line.3.horizontal"
            case .startJam: "person.2.wave.2"
            case .goToRadio: "antenna.radiowaves.left.and.right"
            }
        }
    }
}

#Preview {
    AlbumMoreView(
        showAlbumMoreView: .constant(true),
        albumUi: AlbumUi()
    )
    .tint(.white)
    .preferredColorScheme(.dark)
}
