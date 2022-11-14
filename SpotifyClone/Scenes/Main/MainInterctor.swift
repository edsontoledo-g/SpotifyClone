//
//  MainInterctor.swift
//  SpotifyClone
//
//  Created by Edson Dario Toledo Gonzalez on 09/11/22.
//

import Foundation

protocol AnyMainInputInteractor: AnyObject {
    var presenter: AnyMainOutputInteractor? { get set }
}

protocol AnyMainOutputInteractor: AnyObject { }

class MainInputInteractor: AnyMainInputInteractor {
    var presenter: AnyMainOutputInteractor?
}
