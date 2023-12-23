//
//  SearchUiModels.swift
//  SpotifyClone
//
//  Created by Edson Dario Toledo Gonzalez on 25/11/23.
//

import Foundation

struct SearchUi: Equatable, Hashable {
    var recentSearches: [AnySpotifyItemUi] = []
    var suggestions: [AnySpotifyItemUi] = []
}

extension SearchUi {
    
    func hasSuggestions() -> Bool {
        !suggestions.isEmpty
    }
    
    func hasRecentSearches() -> Bool {
        !recentSearches.isEmpty
    }
    
    func hasRecentSearch(with id: String) -> Bool {
        recentSearches.contains { $0.id == id }
    }
}
