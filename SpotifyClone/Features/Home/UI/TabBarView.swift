//
//  TabBarView.swift
//  SpotifyClone
//
//  Created by Edson Dario Toledo Gonzalez on 25/08/23.
//

import SwiftUI

struct TabBarView: View {
    
    @Environment(AuthStore.self) private var authStore
    @State private var homeRouter = Router()
    @State private var searchRouter = Router()
    
    var body: some View {
        @Bindable var authStore = authStore
        TabView {
            ForEach(Tab.allCases, id: \.rawValue) { tab in
                tab.view
                    .tabItem {
                        Image(systemName: tab.imageName)
                        Text(tab.name)
                    }
                    .environment(router(for: tab))
            }
        }
        .fullScreenCover(isPresented: $authStore.state.showAuth) {
            SignInView()
        }
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
        .environment(
            AuthStore(
                state: .init(),
                reducer: AuthReducer(),
                middlewares: [AuthMiddleware()]
            )
        )
}
