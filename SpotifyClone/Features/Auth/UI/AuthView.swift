//
//  AuthView.swift
//  SpotifyClone
//
//  Created by Edson Dario Toledo Gonzalez on 25/08/23.
//

import SwiftUI

struct AuthView: View {
    
    @Environment(AuthStore.self) var authStore
    @State private var url = APIConstants.signInUrl
    
    var body: some View {
        WebView(url: $url)
            .ignoresSafeArea()
            .onChange(of: url, urlOnChangeHandler)
    }
    
    private func urlOnChangeHandler() {
        Task {
            await authStore.send(.retreiveCode(url: url))
        }
    }
}

#Preview {
    AuthView()
        .preferredColorScheme(.dark)
        .tint(.white)
        .environment(
            AuthStore(
                state: .init(),
                reducer: AuthReducer(),
                middlewares: [AuthMiddleware()]
            )
        )
}
