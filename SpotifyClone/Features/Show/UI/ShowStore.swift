//
//  ShowStore.swift
//  SpotifyClone
//
//  Created by Edson Dario Toledo Gonzalez on 24/12/23.
//

import Foundation
import UnidirectionalFlow

typealias ShowStore = Store<ShowState, ShowAction>

struct ShowState: Equatable {
    var isLoading: Bool = false
    var showUi: ShowUi = ShowUi()
}

enum ShowAction: Equatable {
    case loadShowDetail(accessToken: String, showId: String)
    case setResults(showUi: ShowUi)
}

struct ShowReducer: Reducer {
    
    func reduce(oldState: ShowState, with action: ShowAction) -> ShowState {
        var state = oldState
        switch action {
        case .loadShowDetail:
            state.isLoading = true
        case .setResults(let showUi):
            state.showUi = showUi
            state.isLoading = false
        }
        return state
    }
}
