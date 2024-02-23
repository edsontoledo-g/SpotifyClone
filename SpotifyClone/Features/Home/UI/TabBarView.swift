//
//  TabBarView.swift
//  SpotifyClone
//
//  Created by Edson Dario Toledo Gonzalez on 25/08/23.
//

import SwiftUI

struct TabBarView: View {
    
    @Environment(AuthStore.self) private var authStore
    @Environment(PlaybarManager.self) private var playbarManager
    @State private var homeRouter = Router()
    @State private var searchRouter = Router()
    
    var body: some View {
        @Bindable var authStore = authStore
        TabView {
            ForEach(Tab.allCases, id: \.rawValue) { tab in
                tab.view
                    .padding(.bottom, playbarManager.isVisible() ? 56.0 : 0.0)
                    .tabItem {
                        Image(systemName: tab.imageName)
                        Text(tab.name)
                    }
                    .overlay(alignment: .bottom) {
                        if playbarManager.isVisible() {
                            PlaybarView()
                                .padding(.bottom, 1.0)
                                .transition(.push(from: .bottom))
                        }
                    }
                    .environment(router(for: tab))
            }
        }
        .fullScreenCover(isPresented: $authStore.state.showAuth) {
            SignInView()
        }
        .animation(.bouncy, value: playbarManager.state)
    }
    
    private func router(for tab: Tab) -> Router {
        switch tab {
        case .home:
            homeRouter
        case .search:
            searchRouter
        }
    }
}

extension TabBarView {
    
    enum Tab: String, CaseIterable {
        case home = "Home"
        case search = "Search"
        
        var name: String { rawValue }
        
        var imageName: String {
            switch self {
            case .home: "house"
            case .search: "magnifyingglass"
            }
        }
        
        @ViewBuilder var view: some View {
            switch self {
            case .home: 
                HomeView()
            case .search:
                SearchView()
            }
        }
    }
}

#Preview {
    TabBarView()
        .preferredColorScheme(.dark)
        .tint(.white)
        .environment(Router())
        .environment(PlaybarManager(playbarUi: .sampleData))
        .environment(
            AuthStore(
                state: .init(),
                reducer: AuthReducer(),
                middlewares: [AuthMiddleware()]
            )
        )
}

extension EnumeratedSequence {
    
    func toArray() -> Array<Element> {
        Array(self)
    }
}
