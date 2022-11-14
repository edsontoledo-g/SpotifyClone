//
//  PreferencesInteractor.swift
//  SpotifyClone
//
//  Created by Edson Dario Toledo Gonzalez on 10/11/22.
//

import Foundation

protocol AnyPreferencesInputInteractor: AnyObject {
    var presenter: AnyPreferencesOutputInteractor? { get set }
    
    func loadPreferences()
}

protocol AnyPreferencesOutputInteractor: AnyObject {
    func didLoadPreferences(_ preferences: [PreferencesListRow])
}

class PreferencesInputInteractor: AnyPreferencesInputInteractor {
    var presenter: AnyPreferencesOutputInteractor?
    
    func loadPreferences() {
        let preferences = PreferencesListRow.preferencesSections
        
        presenter?.didLoadPreferences(preferences)
    }
}
