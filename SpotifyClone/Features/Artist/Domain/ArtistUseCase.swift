//
//  ArtistUseCase.swift
//  SpotifyClone
//
//  Created by Edson Dario Toledo Gonzalez on 07/09/23.
//

import Foundation

class ArtistUseCase {
    
    private let artistRepository = ArtistRepository()
    
    func fetchArtist(accessToken: String, id: String) async throws -> Artist {
        try await artistRepository.fetchArtist(accessToken: accessToken, id: id)
    }
    
    func fetchArtistTopTracksAndAlbums(
        accessToken: String,
        artistId: String
    ) async throws -> (tracks: [Track], albums: [Album]) {
        let artistTopTracksResponse = try await artistRepository.fetchArtistTopTracks(
            accessToken: accessToken,
            artistId: artistId
        )
        let artistTopTracks = artistTopTracksResponse.tracks
        return (artistTopTracks, artistTopTracks.asAlbums().asUniqueAlbums())
    }
    
    func fetchRelatedArtists(accessToken: String, id: String) async throws -> [Artist] {
        try await artistRepository.fetchRelatedArtists(accessToken: accessToken, id: id).artists
    }
}

