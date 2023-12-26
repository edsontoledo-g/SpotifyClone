//
//  ShowModels.swift
//  SpotifyClone
//
//  Created by Edson Dario Toledo Gonzalez on 24/12/23.
//

import Foundation

struct UserSavedShowsResponse: Codable {
    var items: [ShowResponse]
}

struct ShowResponse: Codable {
    var show: Show
}

struct SeveralShowsResponse: Codable {
    var shows: [Show]
}

struct Show: Codable {
    var id: String
    var name: String
    var description: String
    var images: [Image]
    var episodes: EpisodeResponse?
    
    struct Image: Codable {
        var url: String
        var width: Int
        var height: Int
    }
}

struct EpisodeResponse: Codable {
    var items: [Episode]
}

struct Episode: Codable {
    var id: String
    var name: String
    var description: String
    var images: [Image]
    var releaseDate: String
    var durationMs: Int
    
    struct Image: Codable {
        var url: String
        var width: Int
        var height: Int
    }
    
    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case description
        case images
        case releaseDate = "release_date"
        case durationMs = "duration_ms"
    }
}

extension UserSavedShowsResponse {
    
    func asShows() -> [Show] {
        items.map { $0.show }
    }
}

extension Show {
    
    func asShowUi() -> ShowUi {
        ShowUi(
            id: id,
            name: name,
            image: images.first?.url ?? "",
            thriller: episodes?.asAnyShowItemsUi().first ?? AnyShowItemUi()
        )
    }
    
    func asAnySpotifyItemUi() -> AnySpotifyItemUi {
        AnySpotifyItemUi(
            id: id,
            name: name,
            image: images.first?.url ?? "",
            type: .show
        )
    }
}

extension EpisodeResponse {
    
    func asAnyShowItemsUi() -> [AnyShowItemUi] {
        Array(items.map { $0.asAnyShowItemUi() }[1...])
    }
}

extension Episode {
    
    func asAnyShowItemUi() -> AnyShowItemUi {
        AnyShowItemUi(
            id: id,
            name: name,
            image: images.first?.url ?? "",
            description: description,
            releaseDate: releaseDate,
            durationTime: durationMs.millisecondsToHoursMinutesAndSeconds()
        )
    }
}

extension Array where Element == Show {
    
    func asAnySpotifyItemsUi() -> [AnySpotifyItemUi] {
        map { $0.asAnySpotifyItemUi() }
    }
}
