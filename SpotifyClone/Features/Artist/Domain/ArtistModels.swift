//
//  ArtistModels.swift
//  SpotifyClone
//
//  Created by Edson Dario Toledo Gonzalez on 26/08/23.
//

import Foundation

struct ArtistsResponse: Decodable {
    var items: [Artist]
}

struct Artist: Decodable, Hashable {
    var id: String
    var name: String
    var images: [Image]?
    var followers: Followers?
    var genres: [String]?
    
    struct Image: Decodable {
        var url: String
        var width: Int
        var height: Int
    }
    
    struct Followers: Decodable {
        var total: Int
    }
    
    static func == (lhs: Artist, rhs: Artist) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

struct SeveralArtistsResponse: Decodable {
    var artists: [Artist]
}

struct ArtistTopTracksResponse: Decodable {
    var tracks: [Track]
}

extension Artist {
    
    func asArtistImage() -> String {
        images?.first?.url ?? ""
    }
    
    func asAnySpotifyItemUi() -> AnySpotifyItemUi {
        AnySpotifyItemUi(
            id: id,
            name: name,
            image: images?.first?.url ?? "",
            type: .artist
        )
    }
    
    func asAnyArtistItemUi() -> AnyArtistItemUi {
        AnyArtistItemUi(
            id: id,
            name: name,
            image: images?.first?.url ?? "",
            type: .artist
        )
    }
    
    func asArtistUi(isFollowing: Bool, artistSectionsUi: [ArtistSectionUi] = []) -> ArtistUi {
        ArtistUi(
            id: id,
            name: name,
            image: images?.first?.url ?? "",
            followers: followers?.total ?? .zero,
            isFollowing: isFollowing,
            artistSectionsUi: artistSectionsUi
        )
    }
}

extension Array where Element == Artist {
    
    func asAnySpotifyItemsUi() -> [AnySpotifyItemUi] {
        map { $0.asAnySpotifyItemUi() }
    }
    
    func asAnyArtistItemsUi() -> [AnyArtistItemUi] {
        map { $0.asAnyArtistItemUi() }
    }
    
    func asUniqueArtists() -> [Artist] {
        var uniqueArtists: [Artist] = []
        forEach { artist in
            if !uniqueArtists.contains(where: { $0.id == artist.id }) {
                uniqueArtists.append(artist)
            }
        }
        return uniqueArtists
    }
    
    func asArtistNames() -> [String] {
        map { $0.name }
    }
}
