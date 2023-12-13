//
//  SearchView.swift
//  SpotifyClone
//
//  Created by Edson Dario Toledo Gonzalez on 25/11/23.
//

import SwiftUI

struct SearchView: View {
    
    @Environment(AuthStore.self) private var authStore
    @State private var searchStore = SearchStore(
        state: .init(),
        reducer: SearchReducer(),
        middlewares: [SearchMiddleware()]
    )
    @Environment(Router.self) private var router
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
            ForEach(searchStore.searchUi.items) { item in
                AnySpotifyItemRowView(item: item)
                    .frame(height: 56.0)
            }
        } else {
            EmptyView()
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
    
    private func loadSearch() async {
        await authStore.send(.getOrFetchAccessToken)
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
