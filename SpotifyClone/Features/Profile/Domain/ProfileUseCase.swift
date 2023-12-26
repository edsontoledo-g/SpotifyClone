//
//  ProfileUseCase.swift
//  SpotifyClone
//
//  Created by Edson Dario Toledo Gonzalez on 08/09/23.
//

import Foundation

class ProfileUseCase {
    
    private let profileRepository: ProfileRepository
    
    init(profileRepository: ProfileRepository) {
        self.profileRepository = profileRepository
    }
    
    @MainActor func getOrFetchProfile(accessToken: String) async throws -> Profile {
        if let user = getUser() {
            return user.asProfile()
        }
        return try await fetchProfile(accessToken: accessToken)
    }
    
    func fetchIsFollowingArtist(accessToken: String, id: String) async throws -> Bool {
        try await profileRepository.fetchIsFollowingArtist(accessToken: accessToken, id: id)
    }
    
    private func fetchProfile(accessToken: String) async throws -> Profile {
        let profile = try await profileRepository.fetchProfile(accessToken: accessToken)
        await saveUser(profile)
        return profile
    }
    
    @MainActor private func getUser() -> User? {
        try? profileRepository.getUser()
    }
    
    @MainActor private func saveUser(_ profile: Profile) {
        profileRepository.saveUser(
            id: profile.id,
            name: profile.displayName,
            email: profile.email,
            image: profile.images.first?.url ?? ""
        )
    }
}
