//
//  ShowRepository.swift
//  SpotifyClone
//
//  Created by Edson Dario Toledo Gonzalez on 24/12/23.
//

import Foundation

class ShowRepository {
    
    private let showRemoteDataSource: ShowRemoteDataSource
    
    init(showRemoteDataSource: ShowRemoteDataSource) {
        self.showRemoteDataSource = showRemoteDataSource
    }
    
    func fetchShow(accessToken: String, id: String) async throws -> Show {
        try await showRemoteDataSource.fetchShow(accessToken: accessToken, id: id)
    }
    
    func fetchSeveralShows(accessToken: String, ids: [String]) async throws -> SeveralShowsResponse {
        try await showRemoteDataSource.fetchSeveralShows(accessToken: accessToken, ids: ids)
    }
}
