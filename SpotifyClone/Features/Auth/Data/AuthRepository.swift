//
//  AuthRepository.swift
//  SpotifyClone
//
//  Created by Edson Dario Toledo Gonzalez on 25/10/23.
//

import Foundation

struct AuthRepository {
    
    private let authRemote = AuthRemoteDataSource()
    private let authLocal = AuthLocalDataSource()
    
    func fetchAccessTokenData(with code: String) async throws -> AccessTokenResponse {
        try await authRemote.fetchAccessTokenData(with: code)
    }
    
    func refreshAccessToken(with refreshToken: String) async throws -> AccessTokenResponse {
        try await authRemote.refreshAccessToken(with: refreshToken)
    }
    
    func getAccessToken() -> String? {
        authLocal.getAccessToken()
    }
    
    func getRefreshToken() -> String? {
        authLocal.getRefreshToken()
    }
    
    func getAccessTokenExpirationTime() -> Int? {
        authLocal.getAccessTokenExpirationTime()
    }
    
    func getLastAccessTokenDate() -> String? {
        authLocal.getLastAccessTokenDate()
    }
    
    func setAccessToken(_ accessToken: String) {
        authLocal.setAccessToken(accessToken)
    }
    
    func setRefreshToken(_ refreshToken: String?) {
        authLocal.setRefreshToken(refreshToken)
    }
    
    func setAccessTokenExpirationTime(_ expirationTime: Int) {
        authLocal.setAccessTokenExpirationTime(expirationTime)
    }
    
    func setLastAccessTokenDate(_ date: String) {
        authLocal.setLastAccessTokenDate(date)
    }
}
