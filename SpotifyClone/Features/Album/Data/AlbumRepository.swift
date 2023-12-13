//
//  AlbumRepository.swift
//  SpotifyClone
//
//  Created by Edson Dario Toledo Gonzalez on 26/10/23.
//

import Foundation

struct AlbumRepository {
    
    private let albumRemote = AlbumRemoteDataSource()
    
    func fetchAlbum(accessToken: String, id: String) async throws -> Album {
        try await albumRemote.fetchAlbum(accessToken: accessToken, id: id)
    }
}
