//
//  SearchStore.swift
//  SpotifyClone
//
//  Created by Edson Dario Toledo Gonzalez on 25/11/23.
//

import Foundation
import UnidirectionalFlow

typealias SearchStore = Store<SearchState, SearchAction>

struct SearchState: Equatable {
    var isLoading: Bool = false
    var searchUi: SearchUi = SearchUi()
}

enum SearchAction: Equatable {
    case getRecentSearches
    case addRecentSearch(item: AnySpotifyItemUi)
    case deleteRecentSearch(item: AnySpotifyItemUi)
    case searchItems(accessToken: String, query: String)
    case setResults(searchUi: SearchUi)
}

class SearchReducer: Reducer {
    
    func reduce(oldState: SearchState, with action: SearchAction) -> SearchState {
        var state = oldState
        switch action {
        case .getRecentSearches:
            state.isLoading = true
        case .searchItems:
            state.isLoading = true
        case .setResults(let searchUi):
            state.searchUi = searchUi
            state.isLoading = false
        default:
            break
        }
        return state
    }
}
