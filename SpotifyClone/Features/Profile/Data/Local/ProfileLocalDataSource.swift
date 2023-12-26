//
//  ProfileLocalDataSource.swift
//  SpotifyClone
//
//  Created by Edson Dario Toledo Gonzalez on 23/12/23.
//

import Foundation
import SwiftData

class ProfileLocalDataSource {
    
    private let modelContainer: ModelContainer
    
    init(modelContainer: ModelContainer) {
        self.modelContainer = modelContainer
    }
    
    @MainActor func getUser() throws -> User? {
        let descriptor = FetchDescriptor<User>()
        return try modelContainer.mainContext.fetch(descriptor).first
    }
    
    @MainActor func saveUser(id: String, name: String, email: String, image: String) {
        let user = User(id: id, name: name, email: email, image: image)
        modelContainer.mainContext.insert(user)
    }
    
    @MainActor func deleteUser() throws {
        try modelContainer.mainContext.delete(model: User.self)
    }
}
