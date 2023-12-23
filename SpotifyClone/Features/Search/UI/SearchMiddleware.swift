//
//  SearchMiddleware.swift
//  SpotifyClone
//
//  Created by Edson Dario Toledo Gonzalez on 25/11/23.
//

import Foundation
import UnidirectionalFlow

class SearchMiddleware: Middleware {
    
    private let searchUseCase: SearchUseCase
    
    init() {
        searchUseCase = SearchInjector.provideSearchUseCase()
    }
    
    func process(state: SearchState, with action: SearchAction) async -> SearchAction? {
        switch action {
        case .getRecentSearches:
            let recentSearches = await searchUseCase.getRecentSearches()
            let searchUi = handleGetRecentSearchesSuccess(recentSearches)
            return .setResults(searchUi: searchUi)
        case .addRecentSearch(let item):
            guard !state.searchUi.hasRecentSearch(with: item.id) else { return nil }
            await searchUseCase.saveRecentSearch(
                id: item.id,
                name: item.name,
                image: item.image,
                type: item.type.rawValue
            )
            let searchUi = handleAddRecentSearchSuccess(state.searchUi, item)
            return .setResults(searchUi: searchUi)
        case .deleteRecentSearch(let item):
            await searchUseCase.deleteRecentSearch(id: item.id)
            let searchUi = handleDeleteRecentSearchSuccess(state.searchUi, item)
            return .setResults(searchUi: searchUi)
        case .searchItems(let accessToken, let query):
            do {
                let searchItems = try await searchUseCase.searchItems(accessToken: accessToken, query: query)
                let searchUi = handleSearchItemsSuccess(state.searchUi, searchItems)
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
    
    func handleGetRecentSearchesSuccess(_ artistsModel: [RecentSearch]) -> SearchUi {
        SearchUi(recentSearches: artistsModel.asAnySpotifyItemsUi())
    }
    
    func handleAddRecentSearchSuccess(_ searchUi: SearchUi, _ item: AnySpotifyItemUi) -> SearchUi {
        var searchUi = searchUi
        searchUi.recentSearches.append(item)
        return searchUi
    }
    
    func handleDeleteRecentSearchSuccess(_ searchUi: SearchUi, _ item: AnySpotifyItemUi) -> SearchUi {
        var searchUi = searchUi
        searchUi.recentSearches.removeAll(where: { $0.id == item.id })
        return searchUi
    }
    
    func handleSearchItemsSuccess(_ searchUi: SearchUi, _ items: AlbumsAndArtists) -> SearchUi {
        let (albums, artists) = items
        let items = zip(albums.asAnySpotifyItemUi(), artists.asAnySpotifyItemsUi())
        let shuffledItems = items.reduce([AnySpotifyItemUi]()) { partialResult, albumAndArtist in
            let (album, artist) = albumAndArtist
            return partialResult + [album, artist]
        }
        var searchUi = searchUi
        searchUi.suggestions = shuffledItems
        return searchUi
    }
}
