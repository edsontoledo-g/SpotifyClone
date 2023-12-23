//
//  ProfileModels.swift
//  SpotifyClone
//
//  Created by Edson Dario Toledo Gonzalez on 08/09/23.
//

import Foundation

struct Profile: Codable {
    var id: String
    var displayName: String
    var email: String
    var followers: Followers
    var images: [Image]
    
    struct Followers: Codable {
        var href: String?
        var total: Int
    }
    
    struct Image: Codable {
        var url: String
        var width: Int?
        var height: Int?
    }
    
    private enum CodingKeys: String, CodingKey {
        case id = "id"
        case displayName = "display_name"
        case email = "email"
        case followers = "followers"
        case images = "images"
    }
}

extension Profile {
    
    func asProfileUi() -> ProfileUi {
        ProfileUi(
            id: id,
            name: displayName,
            image: images.first?.url ?? "",
            followers: followers.total
        )
    }
}
