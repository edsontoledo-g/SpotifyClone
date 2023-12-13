//
//  ArtistUiModels.swift
//  SpotifyClone
//
//  Created by Edson Dario Toledo Gonzalez on 07/09/23.
//

import Foundation

struct ArtistUi: Equatable {
    var id: String = ""
    var name: String = ""
    var image: String = ""
    var followers: Int = 0
    var isFollowing: Bool = false
    var artistSectionsUi: [ArtistSectionUi] = []
}

struct ArtistSectionUi: Identifiable, Equatable, Hashable {
    var id: Int
    var title: String
    var items: [AnyArtistItemUi]
    var type: SectionType
    
    enum SectionType {
        case topTracks
        case topReleases
        case playlists
        case about
        case relatedArtists
    }
}

struct AnyArtistItemUi: Identifiable, Equatable, Hashable {
    var id: String
    var name: String
    var image: String
    var type: SpotifyItemType
    var itemNumber: Int?
    var releaseDate: String?
}

extension ArtistUi {
    
    func hasLoaded() -> Bool {
        !artistSectionsUi.isEmpty
    }
}

extension AnyArtistItemUi {
    
    func asAnySpotifyItemUi() -> AnySpotifyItemUi {
        AnySpotifyItemUi(
            id: id,
            name: name,
            image: image,
            type: type
        )
    }
}

extension ArtistSectionUi {
    
    #if DEBUG
    static let sampleData = ArtistSectionUi(
        id: 0,
        title: "Top",
        items: [
            AnyArtistItemUi(
                id: "14SaZBTjxlorHJQxXh01Hu",
                name: "Girls Need Love (with Drake) - Remix",
                image: "https://i.scdn.co/image/ab67616d0000b273fb023e6073e38a52082cc7b6",
                type: .track,
                itemNumber: 1,
                releaseDate: "2018-10-19"
            ),
            AnyArtistItemUi(
                id: "2xyx0o4xNOLLjBSbOOdcbA",
                name: "Playing Games (with Bryson Tiller) - Extended Version",
                image: "https://i.scdn.co/image/ab67616d0000b273b5ed9187ac7f8aa281a547e3",
                type: .track,
                itemNumber: 2,
                releaseDate: "2019-10-04"
            ),
            AnyArtistItemUi(
                id: "3LfHBTYZBTqmz43tvVXJBd",
                name: "Deep",
                image: "https://i.scdn.co/image/ab67616d0000b273fb023e6073e38a52082cc7b6",
                type: .track,
                itemNumber: 3,
                releaseDate: "2018-10-19"
            )
        ],
        type: .topTracks
    )
    #endif
}
