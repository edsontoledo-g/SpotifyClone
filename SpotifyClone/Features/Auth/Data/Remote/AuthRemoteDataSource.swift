//
//  AuthRemoteDataSource.swift
//  SpotifyClone
//
//  Created by Edson Dario Toledo Gonzalez on 25/08/23.
//

import Foundation

struct AuthRemoteDataSource {
    
    func fetchAccessTokenData(with code: String) async throws -> AccessTokenResponse {
        let request = buildFetchAccessTokenDataRequest(with: code)
        return try await APICaller.shared.callService(request: request)
    }
    
    func refreshAccessToken(with refreshToken: String) async throws -> AccessTokenResponse {
        let request = buildRefreshAccessTokenRequest(with: refreshToken)
        return try await APICaller.shared.callService(request: request)
    }
    
    private func buildFetchAccessTokenDataRequest(with code: String) -> Request {
        let authData = "\(APIConstants.clientId):\(APIConstants.clientSecret)".data(using: .utf8)
        let authBase64 = authData?.base64EncodedString()
        
        return Request(
            baseUrl: APIConstants.baseAuthUrl,
            endpoint: "token",
            queryParams: [
                "code": code,
                "redirect_uri": "https://spotify.com",
                "grant_type": "authorization_code"
            ],
            httpMethod: .POST,
            headers: [.authorization: "Basic \(authBase64 ?? "")"]
        )
    }
    
    private func buildRefreshAccessTokenRequest(with refreshToken: String) -> Request {
        let authData = "\(APIConstants.clientId):\(APIConstants.clientSecret)".data(using: .utf8)
        let authBase64 = authData?.base64EncodedString()
        
        return Request(
            baseUrl: APIConstants.baseAuthUrl,
            endpoint: "token",
            queryParams: [
                "refresh_token": refreshToken,
                "grant_type": "refresh_token"
            ],
            httpMethod: .POST,
            headers: [.authorization: "Basic \(authBase64 ?? "")"]
        )
    }
}
