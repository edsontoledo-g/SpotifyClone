//
//  SlideMenuView.swift
//  SpotifyClone
//
//  Created by Edson Dario Toledo Gonzalez on 23/12/23.
//

import SwiftUI

struct SlideMenuView: View {
    
    @Binding var showMenu: Bool
    var profileUi: ProfileUi
    
    var body: some View {
        ZStack(alignment: .leading) {
            if showMenu {
                backgroundView()
                contentView()
            }
        }
    }
    
    private func contentView() -> some View {
        VStack(alignment: .leading, spacing: 32.0) {
            HStack(spacing: 8.0) {
                AsyncImage(url: URL(string: profileUi.image)) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .clipShape(Circle())
                } placeholder: {
                    Color.primaryGray.opacity(0.5)
                        .clipShape(Circle())
                }
                .frame(width: 56.0, height: 56.0)
                VStack(alignment: .leading, spacing: 8.0) {
                    Text(profileUi.name)
                        .font(.system(size: 22.0, weight: .bold))
                    Text("See profile")
                        .font(.system(size: 12.0, weight: .medium))
                        .foregroundStyle(.secondary)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            ForEach(MenuAction.allCases, id: \.rawValue) { menuAction in
                MenuButton(
                    systemImage: menuAction.imageName,
                    title: menuAction.name,
                    action: { menuActionPressed(menuAction) }
                )
            }
            Spacer()
        }
        .padding()
        .frame(maxWidth: 275.0)
        .background(.primaryGray)
        .transition(.move(edge: .leading))
    }
    
    private func backgroundView() -> some View {
        Color.black.opacity(0.75)
            .onTapGesture {
                withAnimation(.bouncy) {
                    showMenu = false
                }
            }
    }
    
    private func menuActionPressed(_ menuAction: MenuAction) {
        switch menuAction {
        case .news:
            newsButtonButtonPressed()
        case .playHistory:
            playHistoryButtonPressed()
        case .settingsAndPrivacy:
            settingsAndPrivacyButtonPressed()
        }
    }
    
    private func newsButtonButtonPressed() {}
    private func playHistoryButtonPressed() {}
    private func settingsAndPrivacyButtonPressed() {}
}

extension SlideMenuView {
    
    enum MenuAction: String, CaseIterable {
        case news
        case playHistory
        case settingsAndPrivacy
        
        var name: String {
            switch self {
            case .news: "News"
            case .playHistory: "Play history"
            case .settingsAndPrivacy: "Settings and privacy"
            }
        }
        
        var imageName: String {
            switch self {
            case .news:
                "bolt"
            case .playHistory:
                "clock.arrow.circlepath"
            case .settingsAndPrivacy:
                "gear"
            }
        }
    }
}

#Preview {
    SlideMenuView(showMenu: .constant(true), profileUi: ProfileUi.sampleData)
        .preferredColorScheme(.dark)
        .tint(.white)
}
