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

extension ProfileUi {
    
#if DEBUG
    static let sampleData = ProfileUi(
        id: UUID().uuidString,
        name: "Edson Dario Toledo Gonzalez",
        image: "https://i.scdn.co/image/ab67757000003b82942addd66816c3e1a4e1a801",
        followers: 0
    )
#endif
}
