//
//  PlayButton.swift
//  SpotifyClone
//
//  Created by Edson Dario Toledo Gonzalez on 27/10/23.
//

import SwiftUI

struct PlayButton: View {
    
    let action: () -> Void
    
    init(action: @escaping () -> Void) {
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            Image(systemName: "play.fill")
                .imageScale(.large)
        }
        .foregroundStyle(.black)
        .padding()
        .background(.spotifyGreen)
        .clipShape(Circle())
    }
}

#Preview {
    PlayButton(action: {})
        .preferredColorScheme(.dark)
}
