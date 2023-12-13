//
//  HomeRepository.swift
//  SpotifyClone
//
//  Created by Edson Dario Toledo Gonzalez on 30/08/23.
//

import Foundation

struct HomeRepository {
    
    private let homeRemote = HomeRemoteDataSource()
    
    func fetchUserTopItems<T: Decodable>(
        accessToken: String,
        type: SpotifyItemType,
        limit: Int,
        offset: Int
    ) async throws -> T {
        try await homeRemote.fetchUserTopItems(
            accessToken: accessToken,
            type: type,
            limit: limit,
            offset: offset
        )
    }
    
    func fetchRecentlyPlayedTracks(
        accessToken: String,
        limit: Int,
        after: String?,
        before: String?
    ) async throws -> RecentlyPlayedTracksResponse {
        try await homeRemote.fetchRecentlyPlayedTracks(
            accessToken: accessToken,
            limit: limit,
            after: after,
            before: before
        )
    }
}
