//
//  AlbumInjector.swift
//  SpotifyClone
//
//  Created by Edson Dario Toledo Gonzalez on 23/12/23.
//

import Foundation

enum AlbumInjector {
    
    static func provideAlbumUseCase() -> AlbumUseCase {
        AlbumUseCase(
            albumRepository: provideAlbumRepository(),
            artistRepository: ArtistInjector.provideArtistRepository()
        )
    }
    
    private static func provideAlbumRepository() -> AlbumRepository {
        AlbumRepository(albumRemoteDataSource: provideAlbumRemoteDataSource())
    }
    
    private static func provideAlbumRemoteDataSource() -> AlbumRemoteDataSource {
        AlbumRemoteDataSource()
    }
}
