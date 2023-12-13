//
//  SearchUiModels.swift
//  SpotifyClone
//
//  Created by Edson Dario Toledo Gonzalez on 25/11/23.
//

import Foundation

struct SearchUi: Equatable, Hashable {
    var suggestions: [String] = []
    var items: [AnySpotifyItemUi] = []
}

extension SearchUi {
    
    func hasLoaded() -> Bool {
        !items.isEmpty
    }
}
