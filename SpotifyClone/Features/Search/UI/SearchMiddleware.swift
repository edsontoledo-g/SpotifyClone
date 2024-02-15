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
    private let profileUseCase: ProfileUseCase
    private var searchTask: Task<AlbumsAndArtists, Error>?
    
    init() {
        searchUseCase = SearchInjector.provideSearchUseCase()
        profileUseCase = ProfileInjector.provideProfileUseCase()
    }
    
    func process(state: SearchState, with action: SearchAction) async -> SearchAction? {
        switch action {
        case .loadSearch(let accessToken):
            async let userProfileCall = try profileUseCase.getOrFetchProfile(accessToken: accessToken)
            async let recentSearchesCall = await searchUseCase.getRecentSearches()
            do {
                let (
                    userProfile,
                    recentSearches
                ) = try await (
                    userProfileCall,
                    recentSearchesCall
                )
                var searchUi = handleGetOrFetchUserSuccess(userProfile)
                searchUi = handleGetRecentSearchesSuccess(searchUi, recentSearches)
                return .setResults(searchUi: searchUi)
            } catch {
                return nil
            }
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
            searchTask?.cancel()
            searchTask = Task.detached {
                try await Task.sleep(nanoseconds: 500_000_000)
                return try await self.searchUseCase.searchItems(accessToken: accessToken, query: query)
            }
            do {
                let searchItems = try await searchTask!.value
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
    
    private func handleGetOrFetchUserSuccess(_ profile: Profile) -> SearchUi {
        SearchUi(profileUi: profile.asProfileUi())
    }
    
    private func handleGetRecentSearchesSuccess(_ searchUi: SearchUi, _ recentSearches: [RecentSearch]) -> SearchUi {
        var searchUi = searchUi
        searchUi.recentSearches = recentSearches.asAnySpotifyItemsUi()
        return searchUi
    }
    
    private func handleAddRecentSearchSuccess(_ searchUi: SearchUi, _ item: AnySpotifyItemUi) -> SearchUi {
        var searchUi = searchUi
        searchUi.recentSearches.append(item)
        return searchUi
    }
    
    private func handleDeleteRecentSearchSuccess(_ searchUi: SearchUi, _ item: AnySpotifyItemUi) -> SearchUi {
        var searchUi = searchUi
        searchUi.recentSearches.removeAll(where: { $0.id == item.id })
        return searchUi
    }
    
    private func handleSearchItemsSuccess(_ searchUi: SearchUi, _ items: AlbumsAndArtists) -> SearchUi {
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
