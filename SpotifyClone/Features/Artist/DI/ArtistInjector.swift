//
//  ArtistInjector.swift
//  SpotifyClone
//
//  Created by Edson Dario Toledo Gonzalez on 23/12/23.
//

import Foundation

enum ArtistInjector {
    
    static func provideArtistUseCase() -> ArtistUseCase {
        ArtistUseCase(artistRepository: provideArtistRepository())
    }
    
    static func provideArtistRepository() -> ArtistRepository {
        ArtistRepository(artistRemoteDataSource: provideArtistRemoteDataSource())
    }
    
    private static func provideArtistRemoteDataSource() -> ArtistRemoteDataSource {
        ArtistRemoteDataSource()
    }
}
