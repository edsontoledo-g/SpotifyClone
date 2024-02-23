//
//  SpotifyCloneApp.swift
//  SpotifyClone
//
//  Created by Edson Dario Toledo Gonzalez on 22/08/23.
//

import SwiftUI

@main
struct SpotifyCloneApp: App {
    
    @State private var playbarManager = PlaybarManager()
    @State private var authStore = AuthStore(
        state: .init(),
        reducer: AuthReducer(),
        middlewares: [AuthMiddleware()]
    )
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(playbarManager)
                .environment(authStore)
        }
    }
}
