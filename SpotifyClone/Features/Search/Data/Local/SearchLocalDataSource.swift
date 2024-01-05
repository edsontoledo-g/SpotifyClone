//
//  SearchLocalDataSource.swift
//  SpotifyClone
//
//  Created by Edson Dario Toledo Gonzalez on 22/12/23.
//

import Foundation
import SwiftData

class SearchLocalDataSource {
    
    @MainActor func getRecentSearches() throws -> [RecentSearch] {
        let descriptor = FetchDescriptor<RecentSearch>()
        return try StorageProvider.shared?.modelContainer.mainContext.fetch(descriptor) ?? []
    }
    
    @MainActor func saveRecentSearch(id: String, name: String, image: String, type: String) {
        let artist = RecentSearch(id: id, name: name, image: image, type: type)
        StorageProvider.shared?.modelContainer.mainContext.insert(artist)
    }
    
    @MainActor func deleteRecentSearch(id: String) throws {
        try StorageProvider.shared?.modelContainer.mainContext.delete(
            model: RecentSearch.self,
            where: #Predicate { artist in
                artist.id == id
            }
        )
    }
}
