//
//  Reducer.swift
//
//
//  Created by Edson Dario Toledo Gonzalez on 23/08/23.
//

import Observation

@Observable @dynamicMemberLookup public class Store<State, Action> {
    public var state: State
    private let reducer: any Reducer<State, Action>
    private let middlewares: any Collection<any Middleware<State, Action>>
    
    public init(
        state: State,
        reducer: some Reducer<State, Action>,
        middlewares: some Collection<any Middleware<State, Action>>
    ) {
        self.state = state
        self.reducer = reducer
        self.middlewares = middlewares
    }
    
    public subscript<T>(dynamicMember keyPath: KeyPath<State, T>) -> T {
        state[keyPath: keyPath]
    }
    
    @MainActor public func send(_ action: Action) async {
        state = reducer.reduce(oldState: state, with: action)
        
        await withTaskGroup(of: Optional<Action>.self) { group in
            middlewares.forEach { middleware in
                group.addTask {
                    await middleware.process(state: self.state, with: action)
                }
            }
            
            for await case let nextAction? in group {
                await send(nextAction)
            }
        }
    }
}
