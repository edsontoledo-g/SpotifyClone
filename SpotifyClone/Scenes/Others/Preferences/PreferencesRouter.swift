//
//  PreferencesRouter.swift
//  SpotifyClone
//
//  Created by Edson Dario Toledo Gonzalez on 10/11/22.
//

import Foundation

protocol AnyPreferencesRouter: AnyObject {
    static func createModule(for view: AnyPreferencesView)
}

class PreferencesRouter: AnyPreferencesRouter {
    static func createModule(for view: AnyPreferencesView) {
        let presenter = PreferencesPresenter()
        view.presenter = presenter
        view.presenter?.interactor = PreferencesInputInteractor()
        view.presenter?.view = view
        view.presenter?.router = PreferencesRouter()
        view.presenter?.interactor?.presenter = presenter
    }
}
