//
//  SearchInjector.swift
//  SpotifyClone
//
//  Created by Edson Dario Toledo Gonzalez on 20/12/23.
//

import Foundation
import SwiftData

enum SearchInjector {
    
    static func provideSearchUseCase() -> SearchUseCase {
        SearchUseCase(searchRepository: provideSearchRepository())
    }
    
    private static func provideSearchRepository() -> SearchRepository {
        SearchRepository(
            searchRemoteDataSource: provideSearchRemoteDataSource(),
            searchLocalDataSource: provideSearchLocalDataSource()
        )
    }
    
    private static func provideSearchRemoteDataSource() -> SearchRemoteDataSource {
        SearchRemoteDataSource()
    }
    
    private static func provideSearchLocalDataSource() -> SearchLocalDataSource {
        return SearchLocalDataSource(modelContainer: DataInjector.provideModelContainer())
    }
}
