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
    
    var body: some View {
        @Bindable var router = router
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
        }
        .onChange(of: query, queryOnChangeHandler)
        .onChange(of: authStore.showAuth, showAuthOnChangeHandler)
        .task { await loadSearch() }
    }
    
    @ViewBuilder private func headerView() -> some View {
        VStack {
            if !isSearchBarFocused {
                HStack {
                    Text("Search")
                        .font(.system(size: 24.0, weight: .bold))
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            SearchBarView(isFocused: $isSearchBarFocused, query: $query)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(.thickMaterial)
        .onTapGesture(perform: searchBarPressed)
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
        }
    }
    
    private func searchBarPressed() {
        withAnimation(.easeInOut) {
            isSearchBarFocused = true
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
        await searchStore.send(.getRecentSearches)
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
