//
//  Track.swift
//  SpotifyClone
//
//  Created by Edson Dario Toledo Gonzalez on 11/11/22.
//

import Foundation

struct Track: Decodable {
    var id: String
    var album: Album
    var artists: [Artist]
    var name: String
}
