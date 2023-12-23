//
//  ProfileRepository.swift
//  SpotifyClone
//
//  Created by Edson Dario Toledo Gonzalez on 08/09/23.
//

import Foundation

class ProfileRepository {
    
    private let profileRemoteDataSource: ProfileRemoteDataSource
    
    init(profileRemoteDataSource: ProfileRemoteDataSource) {
        self.profileRemoteDataSource = profileRemoteDataSource
    }
    
    func fetchProfile(accessToken: String) async throws -> Profile {
        try await profileRemoteDataSource.fetchProfile(accessToken: accessToken)
    }
    
    func fetchIsFollowingArtist(accessToken: String, id: String) async throws -> Bool {
        try await profileRemoteDataSource.fetchIsFollowingArtist(accessToken: accessToken, id: id)
    }
}
