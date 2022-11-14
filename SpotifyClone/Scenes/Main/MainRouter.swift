//
//  MainRouter.swift
//  SpotifyClone
//
//  Created by Edson Dario Toledo Gonzalez on 09/11/22.
//

import UIKit

protocol AnyMainRouter: AnyObject {
    static func createModule(for view: AnyMainView)
    func presentAuthenticationView(on view: AnyMainView)
}

class MainRouter: AnyMainRouter {
    static func createModule(for view: AnyMainView) {
        let presenter = MainPresenter()
        view.presenter = presenter
        view.presenter?.interactor = MainInputInteractor()
        view.presenter?.view = view
        view.presenter?.router = MainRouter()
        view.presenter?.interactor?.presenter = presenter
    }
    
    func presentAuthenticationView(on view: AnyMainView) {
        guard let originView = view as? MainViewController else {
            return
        }
        
        let destinationView = AuthenticationViewController(nibName: "AuthenticationViewController", bundle: nil)
        destinationView.title = "Sign In"
        let navigationController = UINavigationController(rootViewController: destinationView)
        navigationController.modalPresentationStyle = .fullScreen
        
        originView.present(navigationController, animated: true)
    }
}
