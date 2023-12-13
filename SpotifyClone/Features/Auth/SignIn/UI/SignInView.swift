//
//  SignInView.swift
//  SpotifyClone
//
//  Created by Edson Dario Toledo Gonzalez on 24/08/23.
//

import SwiftUI

struct SignInView: View {
    
    @Environment(AuthStore.self) var authStore
    @State private var showAuth = false
    
    var body: some View {
        ZStack {
            Image(.signInBg)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .clipped()
            
            VStack {
                Image(.spotifyLogoWhite)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 96.0, height: 96.0)
                
                Text("Millions of songs.\nFree on Spotify.")
                    .foregroundStyle(.white)
                    .font(.largeTitle.bold())
                    .multilineTextAlignment(.center)
            }
        }
        .overlay(alignment: .bottom) {
            Button(action: signInPressed) {
                Text("Sign in")
                    .fontWeight(.semibold)
                    .foregroundStyle(.black)
                    .frame(maxWidth: .infinity)
                    .frame(height: 44.0)
                    .background(.spotifyGreen)
                    .clipShape(Capsule())
            }
            .padding(.bottom, 88.0)
            .padding(.horizontal)
        }
        .ignoresSafeArea()
        .sheet(isPresented: $showAuth) {
            AuthView()
                .overlay(alignment: .topTrailing) {
                    Button(action: closeButtonPressed) {
                        Image(systemName: "xmark")
                            .foregroundStyle(.black)
                            .fontWeight(.medium)
                            .frame(width: 44.0, height: 44.0)
                            .background(.white)
                            .clipShape(Circle())
                            .shadow(radius: 8.0)
                    }
                    .padding()
                }
        }
        .onChange(of: authStore.showAuth) { _, shouldShowAuth in
            showAuth = shouldShowAuth
        }
    }
    
    private func signInPressed() {
        showAuth = true
    }
    
    private func closeButtonPressed() {
        showAuth = false
    }
}

#Preview {
    SignInView()
        .preferredColorScheme(.dark)
        .environment(
            AuthStore(
                state: .init(),
                reducer: AuthReducer(),
                middlewares: [AuthMiddleware()]
            )
        )
}
