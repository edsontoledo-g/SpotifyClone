//
//  AuthenticationPresenter.swift
//  SpotifyClone
//
//  Created by Edson Dario Toledo Gonzalez on 09/11/22.
//

import Foundation

protocol AnyAuthenticationPresenter: AnyObject {
    var view: AnyAuthenticationView? { get set }
    var interactor: AnyAuthenticationInputInteractor? { get set }
    var router: AnyAuthenticationRouter? { get set }
    
    func loadAuthenticationPage()
    func didStartProvisionalNavigation(with url: URL?)
}

class AuthenticationPresenter: AnyAuthenticationPresenter {
    var view: AnyAuthenticationView?
    var interactor: AnyAuthenticationInputInteractor?
    var router: AnyAuthenticationRouter?
    
    func loadAuthenticationPage() {
        guard let url = AuthenticationManager.shared.signInURL else {
            return
        }
        
        let request = URLRequest(url: url)
        view?.loadRequest(request)
    }
    
    func didStartProvisionalNavigation(with url: URL?) {
        guard let url = url else {
            return
        }

        let urlComponents = URLComponents(string: url.absoluteString)
        guard let code = urlComponents?.queryItems?.first(where: { $0.name == "code" })?.value else {
            return
        }
        
        interactor?.manageTokens(for: code)
    }
}

extension AuthenticationPresenter: AnyAuthenticationOutputInteractor {
    func tokensSuccess() {
        if let view = view {
            router?.dismissView(view)
        }
    }
    
    func tokensFailure() {
        if let view = view {
            router?.showTokensFailureAlert(in: view) { [weak self] in
                self?.loadAuthenticationPage()
            }
        }
    }
}
