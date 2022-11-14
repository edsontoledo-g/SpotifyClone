//
//  SelfConfiguringPreferencesCell.swift
//  SpotifyClone
//
//  Created by Edson Dario Toledo Gonzalez on 10/11/22.
//

import Foundation

protocol SelfConfiguringPreferencesCell {
    static var reuseIdentifier: String { get set }
    func configure(for user: UserProfile, title: String?)
}
