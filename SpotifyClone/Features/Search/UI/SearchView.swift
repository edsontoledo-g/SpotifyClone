//
//  SearchView.swift
//  SpotifyClone
//
//  Created by Edson Dario Toledo Gonzalez on 25/11/23.
//

import SwiftUI
import SwiftData

struct SearchView: View {
    
    @Environment(AuthStore.self) private var authStore
    @Environment(Router.self) private var router
    @State private var searchStore = SearchStore(
        state: .init(),
        reducer: SearchReducer(),
        middlewares: [SearchMiddleware()]
    )
    @State private var isSearchBarFocused = false
    @State private var query = ""
    @State private var showMenu = false
    
    var body: some View {
        @Bindable var router = router
        ZStack {
            NavigationStack(path: $router.navigationPath) {
                ScrollView {
                    VStack {
                        contentView()
                    }
                    .padding()
                }
                .safeAreaInset(edge: .top) {
                    headerView()
                }
                .background(.primaryBackground)
                .navigationDestination(
                    for: Router.Destination.self,
                    destination: navigationDestinationHandler
                )
                .toolbar(.hidden)
                .toolbar(showMenu ? .hidden : .visible, for: .tabBar)
            }
            SlideMenuView(
                showMenu: $showMenu,
                profileUi: searchStore.searchUi.profileUi
            )
        }
        .onChange(of: query, queryOnChangeHandler)
        .onChange(of: authStore.showAuth, showAuthOnChangeHandler)
        .task { await loadSearch() }
    }
    
    @ViewBuilder private func headerView() -> some View {
        VStack {
            if !isSearchBarFocused {
                HStack {
                    AsyncImage(url: URL(string: searchStore.searchUi.profileUi.image)) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .clipShape(Circle())
                    } placeholder: {
                        Color.primaryGray.opacity(0.5)
                            .clipShape(Circle())
                    }
                    .frame(width: 32.0, height: 32.0)
                    .onTapGesture(perform: profilePressed)
                    Text("Search")
                        .font(.system(size: 24.0, weight: .bold))
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            SearchBarView(isFocused: $isSearchBarFocused, query: $query)
                .onTapGesture(perform: searchBarPressed)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(.thickMaterial)
    }
    
    @ViewBuilder private func contentView() -> some View {
        if isSearchBarFocused {
            suggestionsView()
        } else {
            recentSearchesView()
        }
    }
    
    @ViewBuilder private func suggestionsView() -> some View {
        if !query.isEmpty {
            ForEach(searchStore.searchUi.suggestions) { item in
                AnySpotifyItemRowView(item: item, itemPressedCompletion: itemPressed)
                    .frame(height: 56.0)
            }
        } else {
            ContentUnavailableView(label: {
                Label("No Suggestions", systemImage: "list.bullet.rectangle.portrait")
            }, description: {
                Text("Start typing something to show you results")
            })
        }
    }
    
    @ViewBuilder private func recentSearchesView() -> some View {
        if searchStore.searchUi.hasRecentSearches() {
            ForEach(searchStore.searchUi.recentSearches) { item in
                AnySpotifyItemRowView(
                    item: item,
                    isDeletable: true,
                    itemDeletedCompletion: deleteItemPressed
                )
                .frame(height: 56.0)
            }
        } else {
            ContentUnavailableView(label: {
                Label("No Recent Searches", systemImage: "list.bullet.rectangle.portrait")
            }, description: {
                Text("Start exploring your favorite artists and tracks")
            })
        }
    }
    
    @ViewBuilder private func navigationDestinationHandler(destination: Router.Destination) -> some View {
        switch destination {
        case .artistDetail(let id):
            ArtistDetailView(artistId: id)
        case .albumDetail(let id):
            AlbumDetailView(albumId: id)
        case .showDetail(let id):
            ShowDetailView(showId: id)
        }
    }
    
    private func searchBarPressed() {
        withAnimation(.easeInOut) {
            isSearchBarFocused = true
        }
    }
    
    private func profilePressed() {
        withAnimation(.bouncy) {
            showMenu = true
        }
    }
    
    private func itemPressed(_ item: AnySpotifyItemUi) {
        Task {
            await searchStore.send(.addRecentSearch(item: item))
        }
    }
    
    private func deleteItemPressed(_ item: AnySpotifyItemUi) {
        Task {
            await searchStore.send(.deleteRecentSearch(item: item))
        }
    }
    
    private func loadSearch() async {
        await authStore.send(.getOrFetchAccessToken)
        await searchStore.send(.loadSearch(accessToken: authStore.accessToken))
    }
    
    private func queryOnChangeHandler() {
        Task {
            await searchStore.send(
                .searchItems(
                    accessToken: authStore.accessToken,
                    query: query
                )
            )
        }
    }
    
    private func showAuthOnChangeHandler(oldValue: Bool, newValue: Bool) {
        guard oldValue == true else { return }
        Task {
            await loadSearch()
        }
    }
}

#Preview {
    SearchView()
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
