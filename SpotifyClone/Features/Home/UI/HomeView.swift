//
//  HomeView.swift
//  SpotifyClone
//
//  Created by Edson Dario Toledo Gonzalez on 25/08/23.
//

import SwiftUI

struct HomeView: View {
    
    @Environment(AuthStore.self) private var authStore
    @Environment(Router.self) private var router
    @State private var homeStore = HomeStore(
        state: .init(),
        reducer: HomeReducer(),
        middlewares: [HomeMiddleware()]
    )
    @State private var selectedFilter: HeaderAction = .total
    
    var body: some View {
        @Bindable var router = router
        NavigationStack(path: $router.navigationPath) {
            ScrollView {
                VStack(spacing: 24.0) {
                    ForEach(homeStore.homeUi.homeSectionsUi) { homeSectionUi in
                        switch homeSectionUi.type {
                        case .topTracks:
                            TopTracksSectionView(homeSectionUi: homeSectionUi)
                        case .recentlyPlayed:
                            HorizontalHomeSectionView(homeSectionUi: homeSectionUi)
                                .frame(height: 150.0)
                        default:
                            HorizontalHomeSectionView(homeSectionUi: homeSectionUi)
                                .frame(height: 200.0)
                        }
                    }
                }
                .padding(.bottom)
            }
            .safeAreaInset(edge: .top) {
                headerView()
            }
            .showOrHide(homeStore.homeUi.hasLoaded())
            .background(.primaryBackground)
            .navigationDestination(
                for: Router.Destination.self,
                destination: navigationDestinationHandler
            )
            .toolbar(.hidden)
        }
        .overlay {
            if homeStore.isLoading {
                ProgressView()
            }
        }
        .animation(.easeInOut, value: homeStore.homeUi.homeSectionsUi)
        .onChange(of: authStore.showAuth, showAuthOnChangeHandler)
        .task { await loadHome() }
    }
    
    private func headerView() -> some View {
        HStack {
            AsyncImage(url: URL(string: homeStore.homeUi.profileUi.image)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .clipShape(Circle())
            } placeholder: {
                Color.primaryGray.opacity(0.5)
                    .clipShape(Circle())
            }
            .frame(width: 32.0, height: 32.0)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(HeaderAction.allCases, id: \.rawValue) { headerAction in
                        CapsuleButton(
                            name: headerAction.name,
                            isSelected: selectedFilter == headerAction,
                            style: headerAction.style
                        )
                    }
                }
                .padding(.trailing)
            }
        }
        .padding(.vertical)
        .padding(.leading)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.primaryBackground)
    }
    
    @ViewBuilder private func navigationDestinationHandler(destination: Router.Destination) -> some View {
        switch destination {
        case .artistDetail(let id):
            ArtistDetailView(artistId: id)
        case .albumDetail(let id):
            AlbumDetailView(albumId: id)
        }
    }
    
    private func loadHome() async {
        await authStore.send(.getOrFetchAccessToken)
        await homeStore.send(.loadHome(accessToken: authStore.accessToken))
    }
    
    private func showAuthOnChangeHandler(oldValue: Bool, newValue: Bool) {
        guard oldValue == true else { return }
        Task {
            await loadHome()
        }
    }
}

extension HomeView {
    
    enum HeaderAction: String, CaseIterable {
        case total
        case music
        case podcasts
        case yourYear
        
        var name: String {
            switch self {
            case .total: "Total"
            case .music: "Music"
            case .podcasts: "Podcasts"
            case .yourYear: "Your year in Spotify"
            }
        }
        
        var style: CapsuleButtonStyle {
            switch self {
            case .total: .plain
            case .music: .plain
            case .podcasts: .plain
            case .yourYear: .bordered(colors:  [.purple, .blue, .green, .red, .pink])
            }
        }
    }
}

#Preview {
    HomeView()
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
