//
//  HomeRouter.swift
//  SpotifyClone
//
//  Created by Edson Dario Toledo Gonzalez on 10/11/22.
//

import Foundation

protocol AnyHomeRouter: AnyObject {
    static func createModule(for view: AnyHomeView)
    
    func presentPreferences(on view: AnyHomeView, for userProfile: UserProfile)
}

class HomeRouter: AnyHomeRouter {
    static func createModule(for view: AnyHomeView) {
        let presenter = HomePresenter()
        view.presenter = presenter
        view.presenter?.interactor = HomeInputInteractor()
        view.presenter?.view = view
        view.presenter?.router = HomeRouter()
        view.presenter?.interactor?.presenter = presenter
    }
    
    func presentPreferences(on view: AnyHomeView, for userProfile: UserProfile) {
        guard let originView = view as? HomeViewController else {
            return
        }
        
//        let destinationView = PreferencesViewController(nibName: "PreferencesViewController", bundle: nil)
        let destinationView = PreferencesViewController(nibName: "PreferencesViewController", bundle: nil)
        destinationView.configure(with: userProfile)
        
        originView.navigationController?.pushViewController(destinationView, animated: true)
    }
}
