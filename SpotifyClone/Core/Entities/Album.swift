//
//  Album.swift
//  SpotifyClone
//
//  Created by Edson Dario Toledo Gonzalez on 11/11/22.
//

import Foundation

struct Album: Decodable, AnySpotifyContent {
    var type: String = "album"
    var uuid = UUID().uuidString
    
    var id: String
    var album_type: String
    var total_tracks: Int
    var images: [Image]
    var name: String
    var artists: [Artist]
    
    enum CodingKeys: String, CodingKey {
        case id
        case album_type
        case total_tracks
        case images
        case name
        case artists
    }
    
    struct Image: Decodable {
        var url: String
    }
}
