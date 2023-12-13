//
//  ArtistStore.swift
//  SpotifyClone
//
//  Created by Edson Dario Toledo Gonzalez on 08/09/23.
//

import Foundation
import UnidirectionalFlow

typealias ArtistStore = Store<ArtistState, ArtistAction>

struct ArtistState: Equatable {
    var isLoading: Bool = false
    var artistUi: ArtistUi = ArtistUi()
}

enum ArtistAction: Equatable {
    case loadArtistDetail(accessToken: String, artistId: String)
    case setResults(artistUi: ArtistUi)
}

struct ArtistReducer: Reducer {
    
    func reduce(oldState: ArtistState, with action: ArtistAction) -> ArtistState {
        var state = oldState
        switch action {
        case .loadArtistDetail:
            state.isLoading = true
        case .setResults(let artistUi):
            state.artistUi = artistUi
            state.isLoading = false
        }
        return state
    }
}
