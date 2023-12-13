//
//  AlbumStore.swift
//  SpotifyClone
//
//  Created by Edson Dario Toledo Gonzalez on 26/10/23.
//

import Foundation
import UnidirectionalFlow

typealias AlbumStore = Store<AlbumState, AlbumAction>

struct AlbumState: Equatable {
    var isLoading: Bool = false
    var albumUi: AlbumUi = AlbumUi()
}

enum AlbumAction: Equatable {
    case loadAlbumDetail(accessToken: String, albumId: String)
    case setResults(albumUi: AlbumUi)
}

struct AlbumReducer: Reducer {
    
    func reduce(oldState: AlbumState, with action: AlbumAction) -> AlbumState {
        var state = oldState
        switch action {
        case .loadAlbumDetail:
            state.isLoading = true
        case .setResults(let albumUi):
            state.albumUi = albumUi
            state.isLoading = false
        }
        return state
    }
}
