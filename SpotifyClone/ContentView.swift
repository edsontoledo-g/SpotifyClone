//
//  ContentView.swift
//  SpotifyClone
//
//  Created by Edson Dario Toledo Gonzalez on 22/08/23.
//

import SwiftUI

struct ContentView: View {
    
    var body: some View {
        TabBarView()
            .preferredColorScheme(.dark)
            .tint(.white)
    }
}

#Preview {
    ContentView()
}
