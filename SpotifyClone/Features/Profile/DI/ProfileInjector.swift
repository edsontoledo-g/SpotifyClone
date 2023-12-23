//
//  ProfileInjector.swift
//  SpotifyClone
//
//  Created by Edson Dario Toledo Gonzalez on 23/12/23.
//

import Foundation

enum ProfileInjector {
    
    static func provideProfileUseCase() -> ProfileUseCase {
        ProfileUseCase(profileRepository: provideProfileRepository())
    }
    
    private static func provideProfileRepository() -> ProfileRepository {
        ProfileRepository(profileRemoteDataSource: provideProfileRemoteDataSource())
    }
    
    private static func provideProfileRemoteDataSource() -> ProfileRemoteDataSource {
        ProfileRemoteDataSource()
    }
}
