//
//  AuthLocalDataSource.swift
//  SpotifyClone
//
//  Created by Edson Dario Toledo Gonzalez on 25/08/23.
//

import Foundation

struct AuthLocalDataSource {
    
    enum Constants {
        static let accessTokenKey = "accessToken"
        static let refreshTokenKey = "refreshToken"
        static let accessTokenExpirationTimeKey = "accessTokenExpirationTime"
        static let lastAccessTokenDateKey = "lastAccessTokenDate"
    }
    
    func getAccessToken() -> String? {
        UserDefaults.standard.string(forKey: Constants.accessTokenKey)
    }
    
    func getRefreshToken() -> String? {
        UserDefaults.standard.string(forKey: Constants.refreshTokenKey)
    }
    
    func getAccessTokenExpirationTime() -> Int? {
        UserDefaults.standard.integer(forKey: Constants.accessTokenExpirationTimeKey)
    }
    
    func getLastAccessTokenDate() -> String? {
        UserDefaults.standard.string(forKey: Constants.lastAccessTokenDateKey)
    }
    
    func setAccessToken(_ accessToken: String) {
        UserDefaults.standard.setValue(accessToken, forKey: Constants.accessTokenKey)
    }
    
    func setRefreshToken(_ refreshToken: String?) {
        guard let refreshToken = refreshToken else { return }
        UserDefaults.standard.setValue(refreshToken, forKey: Constants.refreshTokenKey)
    }
    
    func setAccessTokenExpirationTime(_ expirationTime: Int) {
        UserDefaults.standard.setValue(expirationTime, forKey: Constants.accessTokenExpirationTimeKey)
    }
    
    func setLastAccessTokenDate(_ date: String) {
        UserDefaults.standard.setValue(date, forKey: Constants.lastAccessTokenDateKey)
    }
}
