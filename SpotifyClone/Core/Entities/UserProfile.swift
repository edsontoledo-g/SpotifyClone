//
//  UserProfile.swift
//  SpotifyClone
//
//  Created by Edson Dario Toledo Gonzalez on 10/11/22.
//

import Foundation

struct UserProfile: Decodable {
    var country: String
    var display_name: String
    var images: [Image]
    
    struct Image: Decodable {
        var url: String
    }
}
