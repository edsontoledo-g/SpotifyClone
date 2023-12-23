//
//  SearchUseCase.swift
//  SpotifyClone
//
//  Created by Edson Dario Toledo Gonzalez on 25/11/23.
//

import Foundation

class SearchUseCase {
    
    private let searchRepository: SearchRepository
    
    init(searchRepository: SearchRepository) {
        self.searchRepository = searchRepository
    }
    
    func searchItems(accessToken: String, query: String) async throws -> AlbumsAndArtists {
        let searchItemsResponse = try await searchRepository.searchItems(
            accessToken: accessToken,
            query: query
        )
        let searchedAlbums = searchItemsResponse.albums.items
        let searchedArtists = searchItemsResponse.artists.items
        return (searchedAlbums, searchedArtists)
    }
    
    @MainActor func getRecentSearches() -> [RecentSearch] {
        (try? searchRepository.getRecentSearches()) ?? []
    }
    
    @MainActor func saveRecentSearch(id: String, name: String, image: String, type: String) {
        searchRepository.saveRecentSearch(id: id, name: name, image: image, type: type)
    }
    
    @MainActor func deleteRecentSearch(id: String) {
        try? searchRepository.deleteRecentSearch(id: id)
    }
}
