//
//  DataInjector.swift
//  SpotifyClone
//
//  Created by Edson Dario Toledo Gonzalez on 22/12/23.
//

import Foundation
import SwiftData

enum DataInjector {
    
    static func provideModelContainer() -> ModelContainer {
        do {
            return try ModelContainer(for: RecentSearch.self)
        } catch {
            fatalError("Failed to create ModelContainer")
        }
    }
}
