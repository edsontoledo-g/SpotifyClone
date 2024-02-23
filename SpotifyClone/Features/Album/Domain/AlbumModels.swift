//
//  AlbumModels.swift
//  SpotifyClone
//
//  Created by Edson Dario Toledo Gonzalez on 26/08/23.
//

import Foundation

struct AlbumResponse: Codable {
    var items: [Album]
}

struct AlbumTracksResponse: Codable {
    var items: [Track]
}

struct Album: Codable {
    var id: String
    var name: String
    var images: [Image]
    var releaseDate: String?
    var artists: [Artist]?
    var tracks: AlbumTracksResponse?
    
    var durationTime: Int? {
        tracks?.items.reduce(0, { $0 + ($1.durationMs) })
    }
    
    struct Image: Codable {
        var url: String
        var width: Int
        var height: Int
    }
    
    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case images
        case releaseDate = "release_date"
        case artists
        case tracks
    }
}

extension Album {
    
    func asAnySpotifyItemUi() -> AnySpotifyItemUi {
        AnySpotifyItemUi(
            id: id,
            name: name,
            image: images.first?.url ?? "",
            type: .track
        )
    }
    
    func asAnyArtistItemUi() -> AnyArtistItemUi {
        AnyArtistItemUi(
            id: id,
            name: name,
            image: images.first?.url ?? "",
            type: .track,
            releaseDate: releaseDate,
            artists: artists ?? []
        )
    }
    
    func asAlbumUi() -> AlbumUi {
        AlbumUi(
            id: id,
            name: name,
            image: images.first?.url ?? "",
            releaseDate: releaseDate ?? "",
            durationTime: (durationTime ?? .zero).millisecondsToHoursMinutesAndSeconds(),
            artists: artists ?? []
        )
    }
}

extension Array where Element == Album {
    
    func asAnySpotifyItemUi() -> [AnySpotifyItemUi] {
        map { $0.asAnySpotifyItemUi() }
    }
    
    func asUniqueAlbums() -> [Album] {
        var uniqueAlbums: [Album] = []
        forEach { album in
            if !uniqueAlbums.contains(where: { $0.id == album.id }) {
                uniqueAlbums.append(album)
            }
        }
        return uniqueAlbums
    }
    
    func asAnyArtistItemUi() -> [AnyArtistItemUi] {
        map { $0.asAnyArtistItemUi() }
    }
}
