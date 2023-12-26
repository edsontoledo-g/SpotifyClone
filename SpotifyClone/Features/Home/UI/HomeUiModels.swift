//
//  HomeUiModels.swift
//  SpotifyClone
//
//  Created by Edson Dario Toledo Gonzalez on 28/08/23.
//

import Foundation

struct HomeUi: Equatable, Hashable {
    var profileUi: ProfileUi = ProfileUi()
    var homeSectionsUi: [HomeSectionUi] = []
}

struct AnySpotifyItemUi: Identifiable, Equatable, Hashable {
    var id: String
    var name: String
    var image: String
    var type: SpotifyItemType
}

struct HomeSectionUi: Identifiable, Equatable, Hashable {
    var id: Int
    var title: String?
    var relatedItem: AnySpotifyItemUi?
    var items: [AnySpotifyItemUi]
    var type: SectionType
    
    enum SectionType {
        case topTracks
        case recentlyPlayed
        case topArtists
        case relatedArtists
        case savedShows
        
        func isMusic() -> Bool {
            self != .savedShows
        }
        
        func isShow() -> Bool {
            self == .savedShows
        }
    }
}

extension HomeUi {
    
    func hasLoaded() -> Bool {
        !homeSectionsUi.isEmpty
    }
}

extension HomeSectionUi {
    
#if DEBUG
    static let sampleData = HomeSectionUi(
        id: 0,
        title: "Top Artists",
        relatedItem: AnySpotifyItemUi(
            id: "5ZS223C6JyBfXasXxrRqOk",
            name: "Jhené Aiko",
            image: "https://i.scdn.co/image/ab6761610000e5eb9f9eab124df9f1ff148ebfe5",
            type: .artist
        ),
        items: [
            AnySpotifyItemUi(
                id: "57LYzLEk2LcFghVwuWbcuS",
                name: "Summer Walker",
                image: "https://i.scdn.co/image/ab6761610000e5eb9ac284d0d6afcb53a65558b3",
                type: .artist
            ),
            AnySpotifyItemUi(
                id: "3RQQmkQEvNCY4prGKE6oc5",
                name: "Un Verano Sin Ti",
                image: "https://i.scdn.co/image/ab67616d0000b27349d694203245f241a1bcaa72",
                type: .track
            ),
            AnySpotifyItemUi(
                id: "1uNFoZAHBGtllmzznpCI3s",
                name: "Justin Bieber",
                image: "https://i.scdn.co/image/ab6761610000e5eb8ae7f2aaa9817a704a87ea36",
                type: .artist
            ),
        ],
        type: .recentlyPlayed
    )
#endif
}
