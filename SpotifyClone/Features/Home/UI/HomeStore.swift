//
//  HomeStore.swift
//  SpotifyClone
//
//  Created by Edson Dario Toledo Gonzalez on 25/08/23.
//

import Foundation
import UnidirectionalFlow

typealias HomeStore = Store<HomeState, HomeAction>

struct HomeState: Equatable {
    var isLoading: Bool = true
    var homeUi: HomeUi = HomeUi()
}

enum HomeAction: Equatable {
    case loadHome(accessToken: String)
    case setResults(homeUi: HomeUi)
}

struct HomeReducer: Reducer {
    
    func reduce(oldState: HomeState, with action: HomeAction) -> HomeState {
        var state = oldState
        switch action {
        case .loadHome:
            state.isLoading = true
        case .setResults(let homeUi):
            state.homeUi = homeUi
            state.isLoading = false
        }
        return state
    }
}
