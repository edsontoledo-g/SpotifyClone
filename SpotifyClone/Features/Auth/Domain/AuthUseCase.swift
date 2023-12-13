//
//  AuthUseCase.swift
//  SpotifyClone
//
//  Created by Edson Dario Toledo Gonzalez on 25/10/23.
//

import Foundation

struct AuthUseCase {
    
    private let authRepository = AuthRepository()
    
    var dateFormatter: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        return dateFormatter
    }
    
    func fetchAccessTokenData(with code: String) async throws -> AccessTokenResponse {
        try await authRepository.fetchAccessTokenData(with: code)
    }
    
    func refreshAccessToken(with refreshToken: String) async throws -> AccessTokenResponse {
        try await authRepository.refreshAccessToken(with: refreshToken)
    }
    
    func saveAccessTokenData(_ accessTokenResponse: AccessTokenResponse) {
        authRepository.setAccessToken(accessTokenResponse.accessToken)
        authRepository.setRefreshToken(accessTokenResponse.refreshToken)
        authRepository.setAccessTokenExpirationTime(accessTokenResponse.expiresIn)
        authRepository.setLastAccessTokenDate(dateFormatter.string(from: Date.now))
    }
    
    func isAccessTokenExpired() -> Bool {
        guard let lastAccessTokenDate = getLastAccessTokenDate(),
              let accessTokenExpirationTime = authRepository.getAccessTokenExpirationTime() else { return true }
        return lastAccessTokenDate.addingTimeInterval(TimeInterval(accessTokenExpirationTime)) < Date.now
    }
    
    func getAccessToken() -> String? {
        authRepository.getAccessToken()
    }
    
    func getRefreshToken() -> String? {
        authRepository.getRefreshToken()
    }
    
    func getLastAccessTokenDate() -> Date? {
        guard let dateString = authRepository.getLastAccessTokenDate() else { return nil }
        return dateFormatter.date(from: dateString)
    }
}
