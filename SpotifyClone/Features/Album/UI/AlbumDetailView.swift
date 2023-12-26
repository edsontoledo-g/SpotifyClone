//
//  AlbumDetailView.swift
//  SpotifyClone
//
//  Created by Edson Dario Toledo Gonzalez on 26/10/23.
//

import SwiftUI

struct AlbumDetailView: View {
    
    @Environment(Router.self) private var router
    @Environment(AuthStore.self) private var authStore
    @State private var albumStore = AlbumStore(
        state: .init(),
        reducer: AlbumReducer(),
        middlewares: [AlbumMiddleware()]
    )
    @State private var averageImageColor: UIColor = .clear
    @State private var showAlbumMoreView = false
    var albumId: String
    
    var body: some View {
        ScrollView {
            VStack {
                VStack {
                    headerView(albumUi: albumStore.albumUi)
                    statsView(albumUi: albumStore.albumUi)
                }
                .background {
                    LinearGradient(
                        colors: [Color(uiColor: averageImageColor).opacity(0.5),
                                 Color(uiColor: averageImageColor).opacity(0.01)],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                }
                ForEach(albumStore.albumUi.albumSectionsUi) { albumSectionUi in
                    switch albumSectionUi.type {
                    case .tracks:
                        VerticalAlbumSectionView(albumSectionUi: albumSectionUi)
                    }
                }
                infoView()
            }
        }
        .showOrHide(albumStore.albumUi.hasLoaded())
        .background(.primaryBackground)
        .overlay(alignment: .topLeading) {
            BackButton()
                .padding(.horizontal)
                .padding(.top, 56.0)
        }
        .overlay {
            if showAlbumMoreView {
                AlbumMoreView(
                    showAlbumMoreView: $showAlbumMoreView,
                    albumUi: albumStore.albumUi
                )
                .transition(.move(edge: .bottom))
            }
        }
        .overlay {
            if albumStore.isLoading {
                ProgressView()
            }
        }
        .toolbar(.hidden)
        .ignoresSafeArea(.all, edges: .top)
        .animation(.easeInOut, value: albumStore.albumUi)
        .onChange(of: authStore.showAuth, showAuthOnChangeHandler)
        .task { await loadAlbum() }
    }
    
    // TODO: Implement animation for header
    @MainActor private func headerView(albumUi: AlbumUi) -> some View {
        AsyncImage(url: URL(string: albumUi.image)) { image in
            image
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 250.0, height: 250.0)
                .shadow(radius: 16.0)
                .onAppear {
                    averageImageColor = image.averageColor
                }
        } placeholder: {
            Color.primaryGray.opacity(0.5)
                .frame(width: 250.0, height: 250.0)
        }
        .padding(.top, 56.0)
    }
    
    private func statsView(albumUi: AlbumUi) -> some View {
        VStack(alignment: .leading, spacing: 4.0) {
            Text(albumUi.name)
                .font(.system(size: 24.0, weight: .bold))
                .fixedSize(horizontal: false, vertical: true)
            HStack {
                AsyncImage(url: URL(string: albumUi.asMainArtistImage())) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    Color.primaryGray.opacity(0.5)
                }
                .frame(width: 28.0, height: 28.0)
                .clipShape(Circle())
                Text(albumUi.asMainArtistName())
            }
            .onTapGesture { artistStatsPressed(albumUi) }
            Text(albumUi.releaseDate)
                .font(.system(size: 15.0, weight: .regular))
                .foregroundStyle(.secondary)
            HStack(spacing: 16.0) {
                HStack {
                    ForEach(StatsAction.allCases, id: \.rawValue) { statsAction in
                        Button("", systemImage: statsAction.imageName) {
                            statsActionPressed(statsAction)
                        }
                    }
                    .buttonStyle(SecondaryButtonStyle())
                }
                Spacer()
                Button("", systemImage: "shuffle") {}
                    .buttonStyle(SecondaryButtonStyle())
                PlayButton(action: {})
            }
        }
        .padding(.horizontal)
    }
    
    private func infoView() -> some View {
        VStack(alignment: .leading, spacing: 16.0) {
            VStack(alignment: .leading) {
                Text(albumStore.albumUi.releaseDate)
                Text("\(albumStore.albumUi.getNumberOfTracks()) tracks - \(albumStore.albumUi.durationTime)")
            }
            .font(.system(size: 13.0, weight: .medium))
            ForEach(albumStore.albumUi.artists, id: \.id) { artist in
                HStack {
                    AsyncImage(url: URL(string: artist.asArtistImage())) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    } placeholder: {
                        Color.primaryGray.opacity(0.5)
                    }
                    .frame(width: 44.0, height: 44.0)
                    .clipShape(Circle())
                    Text(artist.name)
                        .font(.system(size: 15.0, weight: .medium))
                }
                .onTapGesture { artistInfoPressed(artist) }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
    }
    
    private func artistStatsPressed(_ albumUi: AlbumUi) {
        guard let artist = albumUi.asMainArtist() else { return }
        router.navigate(to: .artistDetail(id: artist.id))
    }
    
    private func artistInfoPressed(_ artist: Artist) {
        router.navigate(to: .artistDetail(id: artist.id))
    }
    
    private func loadAlbum() async {
        await authStore.send(.getOrFetchAccessToken)
        await albumStore.send(.loadAlbumDetail(accessToken: authStore.accessToken, albumId: albumId))
    }
    
    private func showAuthOnChangeHandler(oldValue: Bool, newValue: Bool) {
        guard oldValue == true else { return }
        Task {
            await loadAlbum()
        }
    }
    
    private func statsActionPressed(_ statsAction: StatsAction) {
        switch statsAction {
        case .addToLibrary:
            addToLibraryButtonPressed()
        case .download:
            downloadButtonPressed()
        case .more:
            moreButtonPressed()
        }
    }
    
    private func addToLibraryButtonPressed() {}
    private func downloadButtonPressed() {}
    
    private func moreButtonPressed() {
        withAnimation(.bouncy) {
            showAlbumMoreView = true
        }
    }
}

extension AlbumDetailView {
    
    enum StatsAction: String, CaseIterable {
        case addToLibrary
        case download
        case more
        
        var imageName: String {
            switch self {
            case .addToLibrary: "plus.circle"
            case .download: "arrow.down.circle"
            case .more: "ellipsis"
            }
        }
    }
    
    enum Contants {
        static let scaleMultiplier: CGFloat = 0.001
        static let maxScale = 1.5
    }
}

#Preview {
    AlbumDetailView(albumId: "2X6WyzpxY70eUn3lnewB7d")
        .preferredColorScheme(.dark)
        .tint(.white)
        .environment(Router())
        .environment(
            AuthStore(
                state: .init(),
                reducer: AuthReducer(),
                middlewares: [AuthMiddleware()]
            )
        )
}
