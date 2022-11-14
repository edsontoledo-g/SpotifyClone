//
//  AuthenticationInteractor.swift
//  SpotifyClone
//
//  Created by Edson Dario Toledo Gonzalez on 09/11/22.
//

import Foundation

protocol AnyAuthenticationInputInteractor: AnyObject {
    var presenter: AnyAuthenticationOutputInteractor? { get set }
    
    func manageTokens(for code: String)
}

protocol AnyAuthenticationOutputInteractor: AnyObject {
    func tokensSuccess()
    func tokensFailure()
}

class AuthenticationInputInteractor: AnyAuthenticationInputInteractor {
    var presenter: AnyAuthenticationOutputInteractor?
    
    @MainActor
    func manageTokens(for code: String) {
        Task {
            do {
                try await AuthenticationManager.shared.exchangeCodeForToken(code: code)
                presenter?.tokensSuccess()
            } catch {
                presenter?.tokensFailure()
            }
        }
    }
}
