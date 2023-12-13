//
//  CapsuleButton.swift
//  SpotifyClone
//
//  Created by Edson Dario Toledo Gonzalez on 03/12/23.
//

import SwiftUI

enum CapsuleButtonStyle {
    case plain
    case bordered(colors: [Color])
}

struct CapsuleButton: View {
    
    var name: String
    var isSelected: Bool
    var style: CapsuleButtonStyle
    
    var body: some View {
        Text(name)
            .font(.system(size: 13.0, weight: .semibold))
            .foregroundStyle(isSelected ? .black : .white)
            .padding(.vertical, 8.0)
            .padding(.horizontal)
            .background(isSelected ? .spotifyGreen : .primaryGray)
            .clipShape(Capsule())
            .overlay(
                Capsule()
                    .stroke(gradientView(), lineWidth: 2.0)
            )
            .padding(1.0)
    }
    
    private func gradientView() -> LinearGradient {
        var gradientColors: [Color] = []
        switch style {
        case .bordered(let colors):
            gradientColors = colors
        default:
            break
        }
        return LinearGradient(
            colors: gradientColors,
            startPoint: .top,
            endPoint: .bottom
        )
    }
}

#Preview {
    CapsuleButton(
        name: "Music",
        isSelected: true,
        style: .bordered(colors:  [.purple, .blue, .green, .red, .pink])
    )
    .preferredColorScheme(.dark)
    .tint(.white)
}
