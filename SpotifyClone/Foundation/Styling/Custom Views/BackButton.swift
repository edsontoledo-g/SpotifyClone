//
//  BackButton.swift
//  SpotifyClone
//
//  Created by Edson Dario Toledo Gonzalez on 28/10/23.
//

import SwiftUI

struct BackButton: View {
    
    @Environment(Router.self) private var router
    
    var body: some View {
        Button(action: { router.navigateBack() }) {
            Image(systemName: "chevron.left")
        }
        .fontWeight(.semibold)
        .frame(width: 36.0, height: 36.0)
        .background(.black.opacity(0.5))
        .clipShape(Circle())
    }
}

#Preview {
    BackButton()
        .background(.white)
        .preferredColorScheme(.dark)
        .tint(.white)
        .environment(Router())
}
