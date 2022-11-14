//
//  MainPresenter.swift
//  SpotifyClone
//
//  Created by Edson Dario Toledo Gonzalez on 09/11/22.
//

import UIKit

protocol AnyMainPresenter: AnyObject {
    var view: AnyMainView? { get set }
    var interactor: AnyMainInputInteractor? { get set }
    var router: AnyMainRouter? { get set }
    func viewDidAppear()
}

class MainPresenter: AnyMainPresenter, AnyMainOutputInteractor {
    var view: AnyMainView?
    var interactor: AnyMainInputInteractor?
    var router: AnyMainRouter?
    
    func viewDidAppear() {
        if !AuthenticationManager.shared.isSignedIn {
            if let view = view {
                router?.presentAuthenticationView(on: view)
            }
        }
        
        Task {
            try? await AuthenticationManager.shared.refreshAccessTokenIfNeeded()
        }
    }
}
