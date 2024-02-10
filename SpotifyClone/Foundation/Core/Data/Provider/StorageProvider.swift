//
//  StorageProvider.swift
//  SpotifyClone
//
//  Created by Edson Dario Toledo Gonzalez on 22/12/23.
//

import Foundation
import SwiftData

class StorageProvider {
    
    static let shared = StorageProvider()
    
    let modelContainer: ModelContainer
    
    init?() {
        do {
            modelContainer = try ModelContainer(for: RecentSearch.self, User.self)
        } catch {
            return nil
        }
    }
}
