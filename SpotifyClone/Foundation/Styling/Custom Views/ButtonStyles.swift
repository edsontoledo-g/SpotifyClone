//
//  ButtonStyles.swift
//  SpotifyClone
//
//  Created by Edson Dario Toledo Gonzalez on 27/10/23.
//

import SwiftUI

struct PrimaryButtonStyle: ButtonStyle {
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 24.0, weight: .semibold))
    }
}

struct SecondaryButtonStyle: ButtonStyle {
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .imageScale(.large)
            .foregroundStyle(.secondary)
    }
}
