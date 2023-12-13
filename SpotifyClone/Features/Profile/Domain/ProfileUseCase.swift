//
//  ProfileUseCase.swift
//  SpotifyClone
//
//  Created by Edson Dario Toledo Gonzalez on 08/09/23.
//

import Foundation

class ProfileUseCase {
    
    private let profileRepository = ProfileRepository()
    
    func fetchProfile(accessToken: String) async throws -> Profile {
        try await profileRepository.fetchProfile(accessToken: accessToken)
    }
    
    func fetchIsFollowingArtist(accessToken: String, id: String) async throws -> Bool {
        try await profileRepository.fetchIsFollowingArtist(accessToken: accessToken, id: id)
    }
}
