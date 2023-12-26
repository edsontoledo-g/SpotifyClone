//
//  ProfileRepository.swift
//  SpotifyClone
//
//  Created by Edson Dario Toledo Gonzalez on 08/09/23.
//

import Foundation

class ProfileRepository {
    
    private let profileRemoteDataSource: ProfileRemoteDataSource
    private let profileLocalDataSource: ProfileLocalDataSource
    
    init(
        profileRemoteDataSource: ProfileRemoteDataSource,
        profileLocalDataSource: ProfileLocalDataSource
    ) {
        self.profileRemoteDataSource = profileRemoteDataSource
        self.profileLocalDataSource = profileLocalDataSource
    }
    
    func fetchProfile(accessToken: String) async throws -> Profile {
        try await profileRemoteDataSource.fetchProfile(accessToken: accessToken)
    }
    
    func fetchIsFollowingArtist(accessToken: String, id: String) async throws -> Bool {
        try await profileRemoteDataSource.fetchIsFollowingArtist(accessToken: accessToken, id: id)
    }
    
    @MainActor func getUser() throws -> User? {
        try profileLocalDataSource.getUser()
    }
    
    @MainActor func saveUser(id: String, name: String, email: String, image: String) {
        profileLocalDataSource.saveUser(id: id, name: name, email: email, image: image)
    }
    
    @MainActor func deleteUser() throws {
        try profileLocalDataSource.deleteUser()
    }
}
