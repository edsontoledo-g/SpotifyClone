//
//  ArtistDetailView.swift
//  SpotifyClone
//
//  Created by Edson Dario Toledo Gonzalez on 07/09/23.
//

import SwiftUI

struct ArtistDetailView: View {
    
    @Environment(AuthStore.self) private var authStore
    @State private var artistStore = ArtistStore(
        state: .init(),
        reducer: ArtistReducer(),
        middlewares: [ArtistMiddleware()]
    )
    @State private var averageImageColor: UIColor = .clear
    @State private var showArtistMoreView = false
    var artistId: String
    
    var body: some View {
        ScrollView {
            VStack(spacing: .zero) {
                headerView(artistUi: artistStore.artistUi)
                statsView(artistUi: artistStore.artistUi)
                VStack(spacing: 24.0) {
                    ForEach(artistStore.artistUi.artistSectionsUi) { artistSectionUi in
                        switch artistSectionUi.type {
                        case .topTracks, .topReleases:
                            VerticalArtistSectionView(artistSectionUi: artistSectionUi)
                        case .relatedArtists:
                            HorizontalArtistSectionView(artistSectionUi: artistSectionUi)
                                .frame(height: 200.0)
                        default:
                            EmptyView()
                        }
                    }
                }
                .padding()
            }
        }
        .showOrHide(artistStore.artistUi.hasLoaded())
        .background(.primaryBackground)
        .overlay(alignment: .topLeading) {
            BackButton()
                .padding(.horizontal)
                .padding(.top, 56.0)
        }
        .overlay {
            if showArtistMoreView {
                ArtistMoreView(
                    showArtistMoreView: $showArtistMoreView,
                    artistUi: artistStore.artistUi
                )
                .transition(.move(edge: .bottom))
            }
        }
        .overlay {
            if artistStore.isLoading {
                ProgressView()
            }
        }
        .toolbar(.hidden)
        .ignoresSafeArea(.all, edges: .top)
        .animation(.easeInOut, value: artistStore.artistUi)
        .onChange(of: authStore.showAuth, showAuthOnChangeHandler)
        .task { await loadArtist() }
    }
    
    // TODO: Implement animation for header
    @MainActor private func headerView(artistUi: ArtistUi) -> some View {
        GeometryReader { proxy in
            AsyncImage(url: URL(string: artistStore.artistUi.image)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: proxy.size.width, height: proxy.size.height)
                    .clipped()
                    .overlay {
                        LinearGradient(
                            colors: [.clear, .black.opacity(0.5)],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                        .overlay(alignment: .bottomLeading) {
                            Text(artistUi.name)
                                .font(.system(size: 56.0, weight: .heavy))
                                .padding(.horizontal)
                        }
                    }
                    .onAppear {
                        averageImageColor = image.averageColor
                    }
            } placeholder: {
                Color.primaryGray.opacity(0.5)
                    .frame(maxWidth: .infinity)
            }
        }
        .frame(height: 375.0)
    }
    
    private func statsView(artistUi: ArtistUi) -> some View {
        VStack(alignment: .leading, spacing: 4.0) {
            Text("\(artistUi.followers) followers")
                .font(.system(size: 15.0, weight: .regular))
                .foregroundStyle(.secondary)
            HStack(spacing: 16.0) {
                Button(artistUi.isFollowing ? "Following" : "Follow") {}
                    .font(.system(size: 15.0, weight: .semibold))
                    .padding(.horizontal)
                    .padding(.vertical, 8.0)
                    .overlay(Capsule().stroke(.primary, lineWidth: 1.0))
                Button("", systemImage: "ellipsis", action: moreButtonPressed)
                .buttonStyle(SecondaryButtonStyle())
                Spacer()
                Button("", systemImage: "shuffle") {}
                    .buttonStyle(SecondaryButtonStyle())
                PlayButton(action: {})
            }
        }
        .padding()
        .background {
            LinearGradient(
                colors: [Color(uiColor: averageImageColor).opacity(0.5),
                         Color(uiColor: averageImageColor).opacity(0.01)],
                startPoint: .top,
                endPoint: .bottom
            )
        }
    }
    
    private func loadArtist() async {
        await authStore.send(.getOrFetchAccessToken)
        await artistStore.send(.loadArtistDetail(accessToken: authStore.accessToken, artistId: artistId))
    }
    
    private func showAuthOnChangeHandler(oldValue: Bool, newValue: Bool) {
        guard oldValue == true else { return }
        Task {
            await loadArtist()
        }
    }
    
    private func moreButtonPressed() {
        withAnimation(.bouncy) {
            showArtistMoreView = true
        }
    }
}

#Preview {
    ArtistDetailView(artistId: "57LYzLEk2LcFghVwuWbcuS")
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
