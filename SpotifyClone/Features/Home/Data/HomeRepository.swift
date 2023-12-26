//
//  HomeRepository.swift
//  SpotifyClone
//
//  Created by Edson Dario Toledo Gonzalez on 30/08/23.
//

import Foundation

class HomeRepository {
    
    private let homeRemoteDataSource: HomeRemoteDataSource
    
    init(homeRemoteDataSource: HomeRemoteDataSource) {
        self.homeRemoteDataSource = homeRemoteDataSource
    }
    
    func fetchUserTopItems<T: Decodable>(
        accessToken: String,
        type: SpotifyItemType,
        limit: Int,
        offset: Int
    ) async throws -> T {
        try await homeRemoteDataSource.fetchUserTopItems(
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
        try await homeRemoteDataSource.fetchRecentlyPlayedTracks(
            accessToken: accessToken,
            limit: limit,
            after: after,
            before: before
        )
    }
    
    func fetchUserSavedShows(
        accessToken: String,
        limit: Int,
        offset: Int
    ) async throws -> UserSavedShowsResponse {
        try await homeRemoteDataSource.fetchUserSavedShows(
            accessToken: accessToken,
            limit: limit,
            offset: offset
        )
    }
}
