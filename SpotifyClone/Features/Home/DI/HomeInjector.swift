//
//  HomeInjector.swift
//  SpotifyClone
//
//  Created by Edson Dario Toledo Gonzalez on 23/12/23.
//

import Foundation

enum HomeInjector {
    
    static func provideHomeUseCase() -> HomeUseCase {
        HomeUseCase(
            homeRepository: provideHomeRepository(),
            artistRepository: ArtistInjector.provideArtistRepository(),
            showRepository: ShowInjector.provideShowRepository()
        )
    }
    
    static func provideHomeRepository() -> HomeRepository {
        HomeRepository(homeRemoteDataSource: provideHomeRemoteDataSource())
    }
    
    private static func provideHomeRemoteDataSource() -> HomeRemoteDataSource {
        HomeRemoteDataSource()
    }
}
