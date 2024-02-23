//
//  ArtistMoreView.swift
//  SpotifyClone
//
//  Created by Edson Dario Toledo Gonzalez on 23/10/23.
//

import SwiftUI

struct ArtistMoreView: View {
    
    @Environment(PlaybarManager.self) private var playbarManager
    @Binding var showArtistMoreView: Bool
    var artistUi: ArtistUi
    
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
        .onAppear {
            playbarManager.hidePlaybar()
        }
        .onDisappear {
            playbarManager.showPlaybar()
        }
    }
    
    @MainActor private func coverView() -> some View {
        VStack(spacing: 16.0) {
            AsyncImage(url: URL(string: artistUi.image)) { image in
                VStack {
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 125.0, height: 125.0)
                        .clipShape(Circle())
                    HStack {
                        Image(.spotifyLogoWhite)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                        Image(systemName: "waveform")
                            .imageScale(.large)
                    }
                    .frame(height: 24.0)
                }
                .padding()
                .background(Color(uiColor: image.averageColor))
            } placeholder: {
                Color.clear
            }
            Text(artistUi.name)
                .font(.system(size: 17.0, weight: .bold))
        }
    }
    
    
    private func optionsView() -> some View {
        VStack(alignment: .leading, spacing: 32.0) {
            ForEach(OptionAction.allCases, id: \.rawValue) { optionAction in
                MenuButton(
                    systemImage: optionAction.getImageName(artistUi: artistUi),
                    title: optionAction.getName(artistUi: artistUi),
                    action: { optionActionPressed(optionAction) }
                )
            }
        }
    }
    
    private func optionActionPressed(_ optionAction: OptionAction) {
        switch optionAction {
        case .follow:
            followButtonPressed()
        case .block:
            blockButtonPressed()
        case .share:
            shareButtonPressed()
        case .goToRadio:
            goToRadioButtonPressed()
        case .report:
            reportButtonPressed()
        }
    }
    
    private func closeButtonPressed() {
        withAnimation(.bouncy) {
            showArtistMoreView = false
        }
    }
    
    private func followButtonPressed() {}
    private func blockButtonPressed() {}
    private func shareButtonPressed() {}
    private func goToRadioButtonPressed() {}
    private func reportButtonPressed() {}
}

extension ArtistMoreView {
    
    enum OptionAction: String, CaseIterable {
        case follow
        case block
        case share
        case goToRadio
        case report
        
        func getName(artistUi: ArtistUi) -> String {
            switch self {
            case .follow: artistUi.isFollowing ? "Stop following" : "Follow"
            case .block: "Do not reproduce this artist"
            case .share: "Share"
            case .goToRadio: "Go to radio"
            case .report: "Report"
            }
        }
        
        func getImageName(artistUi: ArtistUi) -> String {
            switch self {
            case .follow: artistUi.isFollowing ? "xmark" : "person.crop.circle.badge.plus"
            case .block: "speaker.slash.circle"
            case .share: "square.and.arrow.up"
            case .goToRadio: "antenna.radiowaves.left.and.right"
            case .report: "exclamationmark.octagon"
            }
        }
    }
}

#Preview {
    ArtistMoreView(
        showArtistMoreView: .constant(true),
        artistUi: ArtistUi()
    )
    .preferredColorScheme(.dark)
    .tint(.primary)
    .environment(PlaybarManager(playbarUi: .sampleData))
}
