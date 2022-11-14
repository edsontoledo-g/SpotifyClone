//
//  PreferencesListRow.swift
//  SpotifyClone
//
//  Created by Edson Dario Toledo Gonzalez on 10/11/22.
//

import Foundation

struct PreferencesListRow {
    enum PreferencesListRowType {
        case userProfile
        case settings
        case signOut
    }
    
    var type: PreferencesListRowType
    var title: String?
}

extension PreferencesListRow {
    static let preferencesSections: [PreferencesListRow] = [
        PreferencesListRow(type: .userProfile),
        PreferencesListRow(type: .settings, title: "Account"),
        PreferencesListRow(type: .settings, title: "Data saving"),
        PreferencesListRow(type: .settings, title: "Languages"),
        PreferencesListRow(type: .settings, title: "Playback"),
        PreferencesListRow(type: .settings, title: "Explicit content"),
        PreferencesListRow(type: .settings, title: "Devices"),
        PreferencesListRow(type: .settings, title: "Car"),
        PreferencesListRow(type: .settings, title: "Privacy and social"),
        PreferencesListRow(type: .settings, title: "Audio quality"),
        PreferencesListRow(type: .settings, title: "Video quality"),
        PreferencesListRow(type: .settings, title: "Storage"),
        PreferencesListRow(type: .settings, title: "Notifications"),
        PreferencesListRow(type: .settings, title: "Local files"),
        PreferencesListRow(type: .settings, title: "About"),
        PreferencesListRow(type: .signOut)
    ]
}
