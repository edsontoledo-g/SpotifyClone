//
//  AlbumUiModels.swift
//  SpotifyClone
//
//  Created by Edson Dario Toledo Gonzalez on 26/10/23.
//

import Foundation

struct AlbumUi: Equatable {
    var id: String = ""
    var name: String = ""
    var image: String = ""
    var releaseDate: String = ""
    var durationTime: String = ""
    var artists: [Artist] = []
    var albumSectionsUi: [AlbumSectionUi] = []
}

struct AlbumSectionUi: Identifiable, Equatable, Hashable {
    var id: Int
    var title: String?
    var items: [AnyAlbumItemUi]
    var type: SectionType
    
    enum SectionType {
        case tracks
    }
}

struct AnyAlbumItemUi: Identifiable, Equatable, Hashable {
    var id: String
    var name: String
    var image: String?
    var artists: [Artist]
}

extension AlbumUi {
    
    func asMainArtist() -> Artist? {
        artists.first
    }
    
    func asMainArtistName() -> String {
        asMainArtist()?.name ?? ""
    }
    
    func asMainArtistImage() -> String {
        asMainArtist()?.images?.first?.url ?? ""
    }
        
    func hasLoaded() -> Bool {
        !albumSectionsUi.isEmpty
    }
    
    func getNumberOfTracks() -> Int {
        albumSectionsUi.reduce(0) { partialResult, albumSectionUi in
            guard albumSectionUi.type == .tracks else { return partialResult }
            return partialResult + albumSectionUi.items.count
        }
    }
    
    func getDurationTimeFormatted() -> String {
        let durationTime = Int(durationTime) ?? .zero
        let hours = durationTime / 3600
        let minutes = (durationTime % 3600) / 60
        let seconds = (durationTime % 3600) % 60
        if hours == .zero {
            return "\(minutes) min \(seconds) sec"
        } else {
            return "\(hours) h \(minutes) min"
        }
    }
}

extension AlbumSectionUi {
    
    #if DEBUG
    static let sampleData = AlbumSectionUi(
        id: 0,
        items: [
            AnyAlbumItemUi(
                id: "0EZqBZknFKby6dk41hfi2o",
                name: "FANTASMA | AVC",
                artists: [
                    Artist(id: "0GM7qgcRCORpGnfcN2tCiB", name: "Tainy"),
                    Artist(id: "6nVcHLIgY5pE2YCl8ubca1", name: "Jhayco")
                ]
            ),
            AnyAlbumItemUi(
                id: "46YjJXVXWHlQ21odKktg5e",
                name: "MOJABY GHOST",
                artists: [
                    Artist(id: "0GM7qgcRCORpGnfcN2tCiB", name: "Tainy"),
                    Artist(id: "4q3ewBCX7sLwd24euuV69X", name: "Bad Bunny")
                ]
            ),
            AnyAlbumItemUi(
                id: "15U5RHzuLMPNFThQqfKL0U",
                name: "COLMILLO",
                artists: [
                    Artist(id: "0GM7qgcRCORpGnfcN2tCiB", name: "Tainy"),
                    Artist(id: "1vyhD5VmyZ7KMfW5gqLgo5", name: "J Balvin"),
                    Artist(id: "3qsKSpcV3ncke3hw52JSMB", name: "Young Miko"),
                    Artist(id: "4IMAo2UQchVFyPH24PAjUs", name: "Jowell y Randy")
                ]
            )
        ],
        type: .tracks
    )
    #endif
}
