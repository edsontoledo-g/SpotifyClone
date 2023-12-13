//
//  SearchBarView.swift
//  SpotifyClone
//
//  Created by Edson Dario Toledo Gonzalez on 27/11/23.
//

import SwiftUI

struct SearchBarView: View {
    
    @Binding var isFocused: Bool
    @Binding var query: String
    
    var body: some View {
        HStack {
            HStack {
                Image(systemName: "magnifyingglass")
                    .imageScale(isFocused ? .medium : .large)
                    .foregroundStyle(isFocused ? .white : .black)
                TextField(isFocused ? "What do you want to listen?" : "", text: $query)
                    .tint(.spotifyGreen)
                    .overlay(alignment: .leading) {
                        Text("What do you want to listen?")
                            .foregroundStyle(isFocused ? Color.secondary : .black)
                            .showOrHide(!isFocused)
                    }
            }
            .frame(height: isFocused ? 36.0 : 44.0)
            .padding(.horizontal)
            .background(isFocused ? .primaryGray : .white)
            .clipShape(RoundedRectangle(cornerRadius: 8.0))
            if isFocused {
                Button("Cancel", action: cancelButtonPressed)
            }
        }
        .onChange(of: query, queryOnChangeHandler)
    }
    
    private func cancelButtonPressed() {
        withAnimation(.easeInOut) {
            isFocused = false
            query = ""
        }
    }
    
    private func queryOnChangeHandler(oldValue: String, newValue: String) {
        guard !isFocused, oldValue.isEmpty else { return }
        isFocused = true
    }
}

#Preview {
    SearchBarView(isFocused: .constant(true), query: .constant(""))
        .preferredColorScheme(.dark)
        .tint(.spotifyGreen)
}
