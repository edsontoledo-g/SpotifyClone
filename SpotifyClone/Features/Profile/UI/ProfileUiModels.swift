//
//  ProfileUiModels.swift
//  SpotifyClone
//
//  Created by Edson Dario Toledo Gonzalez on 03/12/23.
//

import Foundation

struct ProfileUi: Equatable, Hashable {
    var id: String = ""
    var name: String = ""
    var image: String = ""
    var followers: Int = .zero
}
