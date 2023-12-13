//
//  SearchUseCase.swift
//  SpotifyClone
//
//  Created by Edson Dario Toledo Gonzalez on 25/11/23.
//

import Foundation

struct SearchUseCase {
    
    private let searchRepository = SearchRepository()
    
    func searchItems(accessToken: String, query: String) async throws -> AlbumsAndArtists {
        let searchItemsResponse = try await searchRepository.searchItems(
            accessToken: accessToken,
            query: query
        )
        let searchedAlbums = searchItemsResponse.albums.items
        let searchedArtists = searchItemsResponse.artists.items
        return (searchedAlbums, searchedArtists)
    }
}
