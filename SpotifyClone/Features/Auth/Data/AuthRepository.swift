//
//  AuthRepository.swift
//  SpotifyClone
//
//  Created by Edson Dario Toledo Gonzalez on 25/10/23.
//

import Foundation

class AuthRepository {
    
    private let authRemoteDataSource: AuthRemoteDataSource
    private let authLocalDataSource: AuthLocalDataSource
    
    init(
        authRemoteDataSource: AuthRemoteDataSource,
        authLocalDataSource: AuthLocalDataSource
    ) {
        self.authRemoteDataSource = authRemoteDataSource
        self.authLocalDataSource = authLocalDataSource
    }
    
    func fetchAccessTokenData(with code: String) async throws -> AccessTokenResponse {
        try await authRemoteDataSource.fetchAccessTokenData(with: code)
    }
    
    func refreshAccessToken(with refreshToken: String) async throws -> AccessTokenResponse {
        try await authRemoteDataSource.refreshAccessToken(with: refreshToken)
    }
    
    func getAccessToken() -> String? {
        authLocalDataSource.getAccessToken()
    }
    
    func getRefreshToken() -> String? {
        authLocalDataSource.getRefreshToken()
    }
    
    func getAccessTokenExpirationTime() -> Int? {
        authLocalDataSource.getAccessTokenExpirationTime()
    }
    
    func getLastAccessTokenDate() -> String? {
        authLocalDataSource.getLastAccessTokenDate()
    }
    
    func setAccessToken(_ accessToken: String) {
        authLocalDataSource.setAccessToken(accessToken)
    }
    
    func setRefreshToken(_ refreshToken: String?) {
        authLocalDataSource.setRefreshToken(refreshToken)
    }
    
    func setAccessTokenExpirationTime(_ expirationTime: Int) {
        authLocalDataSource.setAccessTokenExpirationTime(expirationTime)
    }
    
    func setLastAccessTokenDate(_ date: String) {
        authLocalDataSource.setLastAccessTokenDate(date)
    }
}
