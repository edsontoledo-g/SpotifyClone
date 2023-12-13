//
//  ProfileRepository.swift
//  SpotifyClone
//
//  Created by Edson Dario Toledo Gonzalez on 08/09/23.
//

import Foundation

class ProfileRepository {
    
    private let profileRemote = ProfileRemoteDataSource()
    
    func fetchProfile(accessToken: String) async throws -> Profile {
        try await profileRemote.fetchProfile(accessToken: accessToken)
    }
    
    func fetchIsFollowingArtist(accessToken: String, id: String) async throws -> Bool {
        try await profileRemote.fetchIsFollowingArtist(accessToken: accessToken, id: id)
    }
}
