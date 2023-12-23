//
//  SearchRepository.swift
//  SpotifyClone
//
//  Created by Edson Dario Toledo Gonzalez on 25/11/23.
//

import Foundation

class SearchRepository {
    
    private let searchRemoteDataSource: SearchRemoteDataSource
    private let searchLocalDataSource: SearchLocalDataSource
    
    init(
        searchRemoteDataSource: SearchRemoteDataSource,
        searchLocalDataSource: SearchLocalDataSource
    ) {
        self.searchRemoteDataSource = searchRemoteDataSource
        self.searchLocalDataSource = SearchLocalDataSource.shared
    }
    
    func searchItems(accessToken: String, query: String) async throws -> SearchItemsResponse {
        try await searchRemoteDataSource.searchItems(accessToken: accessToken, query: query)
    }
    
    @MainActor func getRecentSearches() throws -> [RecentSearch] {
        try searchLocalDataSource.getRecentSearches()
    }
    
    @MainActor func saveRecentSearch(id: String, name: String, image: String, type: String) {
        searchLocalDataSource.saveRecentSearch(id: id, name: name, image: image, type: type)
    }
    
    @MainActor func deleteRecentSearch(id: String) throws {
        try searchLocalDataSource.deleteRecentSearch(id: id)
    }
}
