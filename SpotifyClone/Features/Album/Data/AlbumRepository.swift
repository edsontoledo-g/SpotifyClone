//
//  AlbumRepository.swift
//  SpotifyClone
//
//  Created by Edson Dario Toledo Gonzalez on 26/10/23.
//

import Foundation

class AlbumRepository {
    
    private let albumRemoteDataSource: AlbumRemoteDataSource
    
    init(albumRemoteDataSource: AlbumRemoteDataSource) {
        self.albumRemoteDataSource = albumRemoteDataSource
    }
    
    func fetchAlbum(accessToken: String, id: String) async throws -> Album {
        try await albumRemoteDataSource.fetchAlbum(accessToken: accessToken, id: id)
    }
}
