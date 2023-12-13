//
//  SearchRepository.swift
//  SpotifyClone
//
//  Created by Edson Dario Toledo Gonzalez on 25/11/23.
//

import Foundation

struct SearchRepository {
    
    private let searchRemote = SearchRemoteDataSource()
    
    func searchItems(accessToken: String, query: String) async throws -> SearchItemsResponse {
        try await searchRemote.searchItems(accessToken: accessToken, query: query)
    }
}
