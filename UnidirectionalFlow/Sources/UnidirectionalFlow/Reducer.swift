//
//  Reducer.swift
//  
//
//  Created by Edson Dario Toledo Gonzalez on 23/08/23.
//

import Foundation

public protocol Reducer<State, Action> {
    associatedtype State
    associatedtype Action
    
    func reduce(oldState: State, with action: Action) -> State
}
