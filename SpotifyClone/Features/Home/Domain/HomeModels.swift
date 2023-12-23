//
//  HomeModels.swift
//  SpotifyClone
//
//  Created by Edson Dario Toledo Gonzalez on 26/08/23.
//

import Foundation

typealias AlbumsAndArtists = (albums: [Album], artists: [Artist])

enum SpotifyItemType: String {
    case track = "tracks"
    case artist = "artists"
    case unknown
    
    var name: String {
        switch self {
        case .track: "Track"
        case .artist: "Artist"
        default: ""
        }
    }
}

struct RecentlyPlayedTracksResponse: Codable {
    var items: [RecentlyPlayedTracks]
}

struct RecentlyPlayedTracks: Codable {
    var track: Track
}

struct TrackResponse: Codable {
    var items: [Track]
}

struct Track: Codable {
    var id: String
    var name: String
    var album: Album?
    var artists: [Artist]
    var durationMs: Int
    
    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case album
        case artists
        case durationMs = "duration_ms"
    }
}

extension Track {
    
    func asAnyArtistItemUi() -> AnyArtistItemUi {
        AnyArtistItemUi(
            id: id,
            name: name,
            image: album?.images.first?.url ?? "",
            type: .artist
        )
    }
    
    func asAnyAlbumItemUi() -> AnyAlbumItemUi {
        AnyAlbumItemUi(
            id: id,
            name: name,
            artists: artists
        )
    }
    
}

extension Array where Element == Track {
    
    func asAlbums() -> [Album] {
        compactMap { $0.album }
    }
    
    func asMainArtists() -> [Artist] {
        compactMap { $0.artists.first }
    }
    
    func asAnyArtistItemsUi() -> [AnyArtistItemUi] {
        map { $0.asAnyArtistItemUi() }
    }
    
    func asAnyAlbumItemsUi() -> [AnyAlbumItemUi] {
        map { $0.asAnyAlbumItemUi() }
    }
}
