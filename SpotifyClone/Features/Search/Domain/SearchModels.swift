//
//  SearchModels.swift
//  SpotifyClone
//
//  Created by Edson Dario Toledo Gonzalez on 25/11/23.
//

import Foundation

enum SearchItemType: String, CaseIterable {
    case artist
    case album
}

struct SearchItemsResponse: Decodable {
    var albums: AlbumResponse
    var artists: ArtistsResponse
}


