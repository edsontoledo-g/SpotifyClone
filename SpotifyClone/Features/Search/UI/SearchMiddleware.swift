//
//  SearchMiddleware.swift
//  SpotifyClone
//
//  Created by Edson Dario Toledo Gonzalez on 25/11/23.
//

import Foundation
import UnidirectionalFlow

struct SearchMiddleware: Middleware {
    
    private let searchUseCase = SearchUseCase()
    
    func process(state: SearchState, with action: SearchAction) async -> SearchAction? {
        switch action {
        case .searchItems(let accessToken, let query):
            do {
                let searchItems = try await searchUseCase.searchItems(accessToken: accessToken, query: query)
                let searchUi = handleSearchItemsSuccess(searchItems)
                return .setResults(searchUi: searchUi)
            } catch {
                return nil
            }
        case .setResults:
            return nil
        }
    }
}

extension SearchMiddleware {
    
    func handleSearchItemsSuccess(_ items: AlbumsAndArtists) -> SearchUi {
        let (albums, artists) = items
        let items = zip(albums.asAnySpotifyItemUi(), artists.asAnySpotifyItemsUi())
        let shuffledItems = items.reduce([AnySpotifyItemUi]()) { partialResult, albumAndArtist in
            let (album, artist) = albumAndArtist
            return partialResult + [album, artist]
        }
        return SearchUi(items: shuffledItems)
    }
}
