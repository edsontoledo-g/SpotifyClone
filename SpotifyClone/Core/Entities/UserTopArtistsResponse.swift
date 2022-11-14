//
//  UserTopArtistsResponse.swift
//  SpotifyClone
//
//  Created by Edson Dario Toledo Gonzalez on 11/11/22.
//

import Foundation

struct UserTopArtistsResponse: Decodable {
    var items: [Artist]
}
