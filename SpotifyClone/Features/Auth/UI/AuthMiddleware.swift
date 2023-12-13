//
//  AuthMiddleware.swift
//  SpotifyClone
//
//  Created by Edson Dario Toledo Gonzalez on 25/08/23.
//

import Foundation
import UnidirectionalFlow

struct AuthMiddleware: Middleware {
    
    private let authUseCase = AuthUseCase()
    
    func process(state: AuthState, with action: AuthAction) async -> AuthAction? {
        switch action {
        case .retreiveCode(let url):
            guard let url = url else { return .setError }
            let urlComponents = URLComponents(string: url.absoluteString)
            guard let code = urlComponents?.queryItems?.first(where: { $0.name == "code" })?.value else { return .setError }
            return .fetchAndSaveAccessToken(code: code)
        case .fetchAndSaveAccessToken(let code):
            guard let accessTokenResponse = try? await authUseCase.fetchAccessTokenData(with: code) else { return .setError }
            authUseCase.saveAccessTokenData(accessTokenResponse)
            return .setResults(accessToken: accessTokenResponse.accessToken)
        case .getOrFetchAccessToken:
            guard let accessToken = authUseCase.getAccessToken() else { return .auth }
            guard !authUseCase.isAccessTokenExpired() else {
                guard let refreshToken = authUseCase.getRefreshToken(),
                      let accessTokenResponse = try? await authUseCase.refreshAccessToken(with: refreshToken) else { return .auth }
                authUseCase.saveAccessTokenData(accessTokenResponse)
                return .setResults(accessToken: accessTokenResponse.accessToken)
            }
            return .setResults(accessToken: accessToken)
        default:
            return nil
        }
    }
}
