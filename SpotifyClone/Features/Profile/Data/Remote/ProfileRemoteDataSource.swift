//
//  ProfileRemoteDataSource.swift
//  SpotifyClone
//
//  Created by Edson Dario Toledo Gonzalez on 08/09/23.
//

import Foundation

class ProfileRemoteDataSource {
    
    func fetchProfile(accessToken: String) async throws -> Profile {
        let request = buildFetchProfileRequest(accessToken: accessToken)
        let profile: Profile = try await APICaller.shared.callService(request: request)
        return profile
    }
    
    func fetchIsFollowingArtist(accessToken: String, id: String) async throws -> Bool {
        let request = buildFetchIsFollowingArtist(accessToken: accessToken, id: id)
        let isFollowingArtist: [Bool] = try await APICaller.shared.callService(request: request)
        return isFollowingArtist.first ?? false
    }
    
    private func buildFetchProfileRequest(accessToken: String) -> Request {
        Request(
            baseUrl: APIConstants.baseApiUrl,
            endpoint: "me",
            headers: [.authorization: "Bearer \(accessToken)"]
        )
    }
    
    private func buildFetchIsFollowingArtist(accessToken: String, id: String) -> Request {
        Request(baseUrl: APIConstants.baseApiUrl,
                endpoint: "me/following/contains",
                queryParams: ["type": "artist", "ids": id],
                headers: [.authorization: "Bearer \(accessToken)"])
    }
}
