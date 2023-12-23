//
//  HomeRemoteDataSource.swift
//  SpotifyClone
//
//  Created by Edson Dario Toledo Gonzalez on 28/08/23.
//

import Foundation

class HomeRemoteDataSource {
    
    func fetchUserTopItems<T: Decodable>(
        accessToken: String,
        type: SpotifyItemType,
        limit: Int,
        offset: Int = 0
    ) async throws -> T {
        let request = buildFetchUserTopItemsRequest(
            accessToken: accessToken,
            type: type,
            limit: limit,
            offset: offset
        )
        let userTopItems: T = try await APICaller.shared.callService(request: request)
        return userTopItems
    }
    
    func fetchRecentlyPlayedTracks(
        accessToken: String,
        limit: Int,
        after: String? = nil,
        before: String? = nil
    ) async throws -> RecentlyPlayedTracksResponse {
        let request = buildFetchRecentlyPlayedTracks(
            accessToken: accessToken,
            limit: limit,
            after: after,
            before: before
        )
        return try await APICaller.shared.callService(request: request)
    }
    
    private func buildFetchUserTopItemsRequest(
        accessToken: String,
        type: SpotifyItemType,
        limit: Int,
        offset: Int
    ) -> Request {
        Request(
            baseUrl: APIConstants.baseApiUrl,
            endpoint: "me/top/\(type.rawValue)",
            queryParams: ["limit": "\(limit)", "offset": "\(offset)"],
            headers: [.authorization: "Bearer \(accessToken)"]
        )
    }
    
    private func buildFetchRecentlyPlayedTracks(
        accessToken: String,
        limit: Int,
        after: String?,
        before: String?
    ) -> Request {
        var queryParams: [String: String] = ["limit": "\(limit)"]
        if let after = after {
            queryParams["after"] = after
        } else if let before = before {
            queryParams["before"] = before
        }
        return Request(
            baseUrl: APIConstants.baseApiUrl,
            endpoint: "me/player/recently-played",
            queryParams: queryParams,
            headers: [.authorization: "Bearer \(accessToken)"]
        )
    }
}
