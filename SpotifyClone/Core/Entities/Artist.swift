//
//  Artist.swift
//  SpotifyClone
//
//  Created by Edson Dario Toledo Gonzalez on 11/11/22.
//

import Foundation

struct Artist: Decodable, AnySpotifyContent {
    var type: String = "artist"
    var uuid = UUID().uuidString
    
    var id: String
    var images: [Image]?
    var name: String
    var genres: [String]?
    
    enum CodingKeys: String, CodingKey {
        case id
        case images
        case name
        case genres
    }
    
    struct Image: Decodable {
        var url: String
    }
}
