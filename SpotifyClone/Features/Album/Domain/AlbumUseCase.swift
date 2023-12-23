//
//  AlbumUseCase.swift
//  SpotifyClone
//
//  Created by Edson Dario Toledo Gonzalez on 26/10/23.
//

import Foundation

class AlbumUseCase {
    
    private let albumRepository: AlbumRepository
    private let artistRepository: ArtistRepository
    
    init(
        albumRepository: AlbumRepository,
        artistRepository: ArtistRepository
    ) {
        self.albumRepository = albumRepository
        self.artistRepository = artistRepository
    }
    
    func fetchAlbum(accessToken: String, id: String) async throws -> Album {
        var album = try await albumRepository.fetchAlbum(
            accessToken: accessToken,
            id: id
        )
        guard let artistIds = album.artists?.map({ $0.id }) else { return album }
        let severalArtistsResponse = try await artistRepository.fetchSeveralArtists(
            accessToken: accessToken,
            ids: artistIds
        )
        album.artists = severalArtistsResponse.artists
        return album
    }
}
