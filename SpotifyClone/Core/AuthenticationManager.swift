//
//  AuthenticationManager.swift
//  SpotifyClone
//
//  Created by Edson Dario Toledo Gonzalez on 08/11/22.
//

import Foundation

class AuthenticationManager {
    static let shared = AuthenticationManager()
    
    enum AuthenticationError: Error {
        case badURL
        case badRequest
        case encodeData(String)
        case noRefreshTokenFound
    }
    
    struct Constants {
        static let baseURL = "https://accounts.spotify.com"
        static let queryParams = [
            "response_type": "code",
            "client_id": APICaller.Constants.clientID,
            "scope": "user-read-private",
            "redirect_uri": "https://www.spotify.com",
            "show_dialog": "TRUE"
        ]
    }
    
    struct RequestComponents {
        let baseURL: String
        let endpoint: Endpoint
        var queryParams: [String: String] = [:]
        
        var url: String {
            baseURL + endpoint.rawValue
        }
        
        enum Endpoint: String {
            case authentication = "/authorize"
            case token = "/api/token"
        }
    }
    
    var signInURL: URL? {
        let components = RequestComponents(
            baseURL: Constants.baseURL,
            endpoint: .authentication,
            queryParams: [
                "response_type": "code",
                "client_id": APICaller.Constants.clientID,
                "scope": "user-read-private,playlist-modify-public,playlist-read-private,playlist-modify-private,user-library-modify,user-library-read,user-read-email,user-top-read,user-read-recently-played",
                "redirect_uri": "https://www.spotify.com",
                "show_dialog": "TRUE"
            ]
        )
        
        var serviceURL = URLComponents(string: components.url)
        serviceURL?.queryItems = buildQueryItems(params: components.queryParams)
        
        return serviceURL?.url
    }
    
    var accessToken: String? {
        UserDefaults.standard.string(forKey: "access_token")
    }
    
    var refreshToken: String? {
        UserDefaults.standard.string(forKey: "refresh_token")
    }
    
    var tokenExpirationDate: Date? {
        UserDefaults.standard.object(forKey: "token_expiration_date") as? Date
    }
    
    var shouldRefreshToken: Bool {
        guard let tokenExpirationDate = tokenExpirationDate else {
            return false
        }
        
        let currentDate = Date()
        let fiveMinutes = TimeInterval(300)
        
        return currentDate.addingTimeInterval(fiveMinutes) >= tokenExpirationDate
    }
    
    var isSignedIn: Bool {
        accessToken != nil
    }
    
    func exchangeCodeForToken(code: String) async throws {
        let components = RequestComponents(
            baseURL: Constants.baseURL,
            endpoint: .token,
            queryParams: [
                "grant_type": "authorization_code",
                "code": code,
                "redirect_uri": "https://www.spotify.com",
            ]
        )
        
        var serviceURL = URLComponents(string: components.url)
        serviceURL?.queryItems = buildQueryItems(params: components.queryParams)
        
        guard let url = serviceURL?.url else {
            throw AuthenticationError.badURL
        }
        
        let token = "\(APICaller.Constants.clientID):\(APICaller.Constants.clientSecret)"
        let tokenData = token.data(using: .utf8)
        
        guard let tokenBase64 = tokenData?.base64EncodedString() else {
            throw AuthenticationError.encodeData("AccessToken")
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = serviceURL?.query?.data(using: .utf8)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue("Basic \(tokenBase64)", forHTTPHeaderField: "Authorization")
        
        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            let response = try JSONDecoder().decode(AuthenticationResponse.self, from: data)
            cacheToken(response: response)
        } catch {
            throw AuthenticationError.badRequest
        }
    }
    
    func refreshAccessTokenIfNeeded() async throws {
        guard shouldRefreshToken else {
            return
        }
        
        guard let refreshToken = self.refreshToken else {
            throw AuthenticationError.noRefreshTokenFound
        }
        
        let components = RequestComponents(
            baseURL: Constants.baseURL,
            endpoint: .token,
            queryParams: [
                "grant_type": "refresh_token",
                "refresh_token": refreshToken,
            ]
        )
        
        var serviceURL = URLComponents(string: components.url)
        serviceURL?.queryItems = buildQueryItems(params: components.queryParams)
        
        guard let url = serviceURL?.url else {
            throw AuthenticationError.badURL
        }
        
        let token = "\(APICaller.Constants.clientID):\(APICaller.Constants.clientSecret)"
        let tokenData = token.data(using: .utf8)
        
        guard let tokenBase64 = tokenData?.base64EncodedString() else {
            throw AuthenticationError.encodeData("RefreshToken")
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = serviceURL?.query?.data(using: .utf8)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue("Basic \(tokenBase64)", forHTTPHeaderField: "Authorization")
        
        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            let response = try JSONDecoder().decode(AuthenticationResponse.self, from: data)
            cacheToken(response: response)
        } catch {
            throw AuthenticationError.badRequest
        }
    }
    
    func cacheToken(response: AuthenticationResponse) {
        UserDefaults.standard.setValue(response.access_token, forKey: "access_token")
        
        if let refresh_token = response.refresh_token {
            UserDefaults.standard.setValue(refresh_token, forKey: "refresh_token")
        }
        
        let expirationDate = Date().addingTimeInterval(TimeInterval(response.expires_in))
        UserDefaults.standard.setValue(expirationDate, forKey: "token_expiration_date")
    }
    
    func buildQueryItems(params: [String: String]) -> [URLQueryItem] {
        params.map{ URLQueryItem(name: $0, value: $1) }
    }
}
