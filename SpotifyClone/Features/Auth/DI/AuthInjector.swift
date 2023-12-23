//
//  AuthInjector.swift
//  SpotifyClone
//
//  Created by Edson Dario Toledo Gonzalez on 23/12/23.
//

import Foundation

enum AuthInjector {
    
    static func provideAuthUseCase() -> AuthUseCase {
        AuthUseCase(authRepository: provideAuthRepository())
    }
    
    private static func provideAuthRepository() -> AuthRepository {
        AuthRepository(
            authRemoteDataSource: provideAuthRemoteDataSource(),
            authLocalDataSource: provideAuthLocalDataSource()
        )
    }
    
    private static func provideAuthRemoteDataSource() -> AuthRemoteDataSource {
        AuthRemoteDataSource()
    }
    
    private static func provideAuthLocalDataSource() -> AuthLocalDataSource {
        AuthLocalDataSource()
    }
}
