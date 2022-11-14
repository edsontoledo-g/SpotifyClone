//
//  AuthenticationRouter.swift
//  SpotifyClone
//
//  Created by Edson Dario Toledo Gonzalez on 09/11/22.
//

import UIKit

protocol AnyAuthenticationRouter: AnyObject {
    var tokensFailureCompletion: (() -> Void)? { get set }
    
    static func createModule(for view: AnyAuthenticationView)
    
    func dismissView(_ view: AnyAuthenticationView)
    func showTokensFailureAlert(in view: AnyAuthenticationView, tokensFailureCompletion: (() -> Void)?)
}

class AuthenticationRouter: AnyAuthenticationRouter {
    var tokensFailureCompletion: (() -> Void)?
    
    static func createModule(for view: AnyAuthenticationView) {
        let presenter = AuthenticationPresenter()
        view.presenter = presenter
        view.presenter?.interactor = AuthenticationInputInteractor()
        view.presenter?.view = view
        view.presenter?.router = AuthenticationRouter()
        view.presenter?.interactor?.presenter = presenter
    }
    
    func dismissView(_ view: AnyAuthenticationView) {
        guard let view = view as? AuthenticationViewController else {
            return
        }
        
        view.dismiss(animated: true)
    }
    
    func showTokensFailureAlert(in view: AnyAuthenticationView, tokensFailureCompletion: (() -> Void)?) {
        self.tokensFailureCompletion = tokensFailureCompletion
        
        guard let view = view as? AuthenticationViewController else {
            return
        }
        
        let alert = UIAlertController(
            title: "Uh-oh! Something went wrong",
            message: "Please try it again.",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Ok", style: .default) {  [weak self] _ in
            self?.tokensFailureCompletion?()
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        view.present(alert, animated: true)
    }
}
