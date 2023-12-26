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
    var filteredHomeUi = HomeUi()
}

enum HomeAction: Equatable {
    case loadHome(accessToken: String)
    case removeFilter
    case filterMusic
    case filterShows
    case setResults(homeUi: HomeUi, filteredHomeUi: HomeUi)
}

struct HomeReducer: Reducer {
    
    func reduce(oldState: HomeState, with action: HomeAction) -> HomeState {
        var state = oldState
        switch action {
        case .loadHome:
            state.isLoading = true
        case .setResults(let homeUi, let filteredHomeUi):
            state.homeUi = homeUi
            state.filteredHomeUi = filteredHomeUi
            state.isLoading = false
        default:
            break
        }
        return state
    }
}
