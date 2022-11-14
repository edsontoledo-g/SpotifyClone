//
//  PreferencesPresenter.swift
//  SpotifyClone
//
//  Created by Edson Dario Toledo Gonzalez on 10/11/22.
//

import Foundation

protocol AnyPreferencesPresenter: AnyObject {
    var view: AnyPreferencesView? { get set }
    var interactor: AnyPreferencesInputInteractor? { get set }
    var router: AnyPreferencesRouter? { get set }
    
    var preferences: [PreferencesListRow]? { get set }
    
    func viewDidLoad()
    func numberOfRowsInSection() -> Int
}

class PreferencesPresenter: AnyPreferencesPresenter {
    var view: AnyPreferencesView?
    var interactor: AnyPreferencesInputInteractor?
    var router: AnyPreferencesRouter?
    
    var preferences: [PreferencesListRow]?
    
    func viewDidLoad() {
        interactor?.loadPreferences()
    }
    
    func numberOfRowsInSection() -> Int {
        return preferences?.count ?? 0
    }
}

extension PreferencesPresenter: AnyPreferencesOutputInteractor {
    func didLoadPreferences(_ preferences: [PreferencesListRow]) {
        self.preferences = preferences
    }
}
