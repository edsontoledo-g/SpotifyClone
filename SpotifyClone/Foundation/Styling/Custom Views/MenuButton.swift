//
//  MenuButton.swift
//  SpotifyClone
//
//  Created by Edson Dario Toledo Gonzalez on 27/10/23.
//

import SwiftUI

struct MenuButton: View {
    
    var systemImage: String
    var title: String
    var action: () -> Void
    
    init(systemImage: String, title: String, action: @escaping () -> Void) {
        self.systemImage = systemImage
        self.title = title
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: systemImage)
                    .foregroundStyle(.secondary)
                Text(title)
                    .font(.system(size: 15.0, weight: .medium))
            }
        }
    }
}

#Preview {
    MenuButton(systemImage: "square.and.arrow.up", title: "Share", action: {})
        .preferredColorScheme(.dark)
        .tint(.white)
}
