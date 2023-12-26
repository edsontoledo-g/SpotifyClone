//
//  ShowDetailView.swift
//  SpotifyClone
//
//  Created by Edson Dario Toledo Gonzalez on 24/12/23.
//

import SwiftUI

struct ShowDetailView: View {
    
    @Environment(Router.self) private var router
    @Environment(AuthStore.self) private var authStore
    @State private var showStore = ShowStore(
        state: .init(),
        reducer: ShowReducer(),
        middlewares: [ShowMiddleware()]
    )
    @State private var averageImageColor: UIColor = .clear
    var showId: String
    
    var body: some View {
        ScrollView {
            VStack {
                VStack {
                    headerView(showUi: showStore.showUi)
                    statsView()
                }
                .padding(.horizontal)
                .background {
                    LinearGradient(
                        colors: [Color(uiColor: averageImageColor).opacity(0.5),
                                 Color(uiColor: averageImageColor).opacity(0.01)],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                }
                ShowThrillerView(item: showStore.showUi.thriller)
                    .padding()
                ForEach(showStore.showUi.showSectionsUi) { showSectionUi in
                    switch showSectionUi.type {
                    case .episodes:
                        VerticalShowSectionView(showSectionUi: showSectionUi)
                    }
                }
            }
        }
        .showOrHide(showStore.showUi.hasLoaded())
        .background(.primaryBackground)
        .overlay(alignment: .topLeading) {
            BackButton()
                .padding(.horizontal)
                .padding(.top, 56.0)
        }
        .overlay {
            if showStore.isLoading {
                ProgressView()
            }
        }
        .toolbar(.hidden)
        .ignoresSafeArea()
        .task { await loadShow() }
    }
    
    @MainActor private func headerView(showUi: ShowUi) -> some View {
        HStack(spacing: 16.0) {
            AsyncImage(url: URL(string: showUi.image)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .onAppear {
                        averageImageColor = image.averageColor
                    }
            } placeholder: {
                Color.primaryGray.opacity(0.5)
            }
            .frame(width: 100.0, height: 100.0)
            .clipShape(RoundedRectangle(cornerRadius: 8.0))
            .shadow(radius: 16.0)
            Text(showUi.name)
                .font(.system(size: 28.0, weight: .bold))
        }
        .padding(.top, 112.0)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private func statsView() -> some View {
        HStack {
            Button("Follow") {}
                .font(.system(size: 15.0, weight: .semibold))
                .padding(.horizontal)
                .padding(.vertical, 8.0)
                .overlay(Capsule().stroke(.primary, lineWidth: 1.0))
                ForEach(StatsAction.allCases, id: \.rawValue) { statsAction in
                Button("", systemImage: statsAction.imageName) {
                    statsActionPressed(statsAction)
                }
            }
            .buttonStyle(SecondaryButtonStyle())
            Spacer()
        }
        .padding(.bottom)
    }
    
    private func loadShow() async {
        await authStore.send(.getOrFetchAccessToken)
        await showStore.send(.loadShowDetail(accessToken: authStore.accessToken, showId: showId))
    }
    
    private func statsActionPressed(_ statsAction: StatsAction) {
        switch statsAction {
        case .activateNotifications:
            activateNotificationsButtonPressed()
        case .settings:
            settingsButtonPressed()
        case .more:
            moreButtonPressed()
        }
    }
    
    private func activateNotificationsButtonPressed() {}
    private func settingsButtonPressed() {}
    private func moreButtonPressed() {}
}

extension ShowDetailView {
    
    enum StatsAction: String, CaseIterable {
        case activateNotifications
        case settings
        case more
        
        var imageName: String {
            switch self {
            case .activateNotifications: "bell"
            case .settings: "gear"
            case .more: "ellipsis"
            }
        }
    }
}

#Preview {
    ShowDetailView(showId: "0s6Wc5qf8SIvCtKZNC6N7s")
        .preferredColorScheme(.dark)
        .tint(.white)
        .environment(Router())
        .environment(AuthStore(
            state: .init(),
            reducer: AuthReducer(),
            middlewares: [AuthMiddleware()]
        ))
}
