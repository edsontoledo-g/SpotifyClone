//
//  APIConstants.swift
//  SpotifyClone
//
//  Created by Edson Dario Toledo Gonzalez on 25/08/23.
//

import Foundation

enum APIConstants {
    static let clientId = ProcessInfo.processInfo.environment["SPOTIFY_CLIENT_ID"] ?? ""
    static let clientSecret = ProcessInfo.processInfo.environment["SPOTIFY_CLIENT_SECRET"] ?? ""
    static let baseApiUrl = "https://api.spotify.com/v1/"
    static let baseAuthUrl = "https://accounts.spotify.com/api/"
    static var signInUrl: URL? {
        let request = Request(
            baseUrl: "https://accounts.spotify.com/",
            endpoint: "authorize",
            queryParams: [
                "response_type": "code",
                "client_id": clientId,
                "scope": "user-read-private,user-top-read,user-read-recently-played,user-library-read,user-read-email,playlist-read-private,user-follow-read",
                "redirect_uri": "https://spotify.com",
                "show_dialog": "TRUE"
            ]
        )
        var urlComponents = URLComponents(string: request.completeUrl)
        urlComponents?.queryItems = request.queryParams.buildQueryItems()
        return urlComponents?.url
    }
}
