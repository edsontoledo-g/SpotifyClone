//
//  Modifiers.swift
//  SpotifyClone
//
//  Created by Edson Dario Toledo Gonzalez on 28/10/23.
//

import SwiftUI

struct ShowOrHideModifier: ViewModifier {
    
    let shouldShow: Bool
    
    func body(content: Content) -> some View {
        content
            .opacity(shouldShow ? 1.0 : 0.0)
    }
}

extension View {
    
    func showOrHide(_ shouldShow: Bool) -> some View {
        self.modifier(ShowOrHideModifier(shouldShow: shouldShow))
    }
}
