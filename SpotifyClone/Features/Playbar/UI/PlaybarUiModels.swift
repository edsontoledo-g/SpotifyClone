//
//  PlaybarModels.swift
//  SpotifyClone
//
//  Created by Edson Dario Toledo Gonzalez on 21/02/24.
//

import Foundation

struct PlaybarUi: Hashable {
    var id: String = ""
    var name: String = ""
    var image: String = ""
    var artists: [Artist] = []
    var previewUrl: String = ""
}

extension PlaybarUi {
    
    func asArtistNames() -> [String] {
        artists.map { $0.name }
    }
    
    #if DEBUG
    static let sampleData = PlaybarUi(
        id: "15U5RHzuLMPNFThQqfKL0U",
        name: "COLMILLO",
        image: "https://i.scdn.co/image/ab67616d0000b273f885fb64a381318a1c9c14e4",
        artists: [
            Artist(id: "0GM7qgcRCORpGnfcN2tCiB", name: "Tainy"),
            Artist(id: "1vyhD5VmyZ7KMfW5gqLgo5", name: "J Balvin"),
            Artist(id: "3qsKSpcV3ncke3hw52JSMB", name: "Young Miko"),
            Artist(id: "4IMAo2UQchVFyPH24PAjUs", name: "Jowell y Randy")
        ],
        previewUrl: "https://p.scdn.co/mp3-preview/3552faaf1d3fc51bb3a5741d85213e05123eb7f2?cid=843e77ce6b1942d6856b0cb3c002e448"
    )
    #endif
}
