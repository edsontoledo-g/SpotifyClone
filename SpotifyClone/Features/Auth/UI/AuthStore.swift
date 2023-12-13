//
//  AuthStore.swift
//  SpotifyClone
//
//  Created by Edson Dario Toledo Gonzalez on 25/08/23.
//

import Foundation
import UnidirectionalFlow

typealias AuthStore = Store<AuthState, AuthAction>

struct AuthState: Equatable {
    var accessToken: String = ""
    var showAuth: Bool = false
}

enum AuthAction: Equatable {
    case retreiveCode(url: URL?)
    case fetchAndSaveAccessToken(code: String)
    case getOrFetchAccessToken
    case setResults(accessToken: String)
    case auth
    case setError
}

struct AuthReducer: Reducer {
    
    func reduce(oldState: AuthState, with action: AuthAction) -> AuthState {
        var state = oldState
        switch action {
        case .setResults(let accessToken):
            state.accessToken = accessToken
            state.showAuth = false
        case .auth:
            state.showAuth = true
        default:
            break
        }
        return state
    }
}
