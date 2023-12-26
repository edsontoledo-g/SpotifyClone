//
//  ShowInjector.swift
//  SpotifyClone
//
//  Created by Edson Dario Toledo Gonzalez on 24/12/23.
//

import Foundation

enum ShowInjector {
    
    static func provideShowUseCase() -> ShowUseCase {
        ShowUseCase(showRepository: provideShowRepository())
    }
    
    private static func provideShowRepository() -> ShowRepository {
        ShowRepository(showRemoteDataSource: provideShowRemoteDataSource())
    }
    
    private static func provideShowRemoteDataSource() -> ShowRemoteDataSource {
        ShowRemoteDataSource()
    }
}
