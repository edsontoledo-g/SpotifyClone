//
//  Middleware.swift
//
//
//  Created by Edson Dario Toledo Gonzalez on 23/08/23.
//

import Foundation

public protocol Middleware<State, Action> {
    associatedtype State
    associatedtype Action
    
    func process(state: State, with action: Action) async -> Action?
}
