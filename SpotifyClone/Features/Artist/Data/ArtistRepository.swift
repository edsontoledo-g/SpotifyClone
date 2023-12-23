//
//  ArtistRepository.swift
//  SpotifyClone
//
//  Created by Edson Dario Toledo Gonzalez on 30/08/23.
//

import Foundation

class ArtistRepository {
    
    private let artistRemoteDataSource: ArtistRemoteDataSource
    
    init(artistRemoteDataSource: ArtistRemoteDataSource) {
        self.artistRemoteDataSource = artistRemoteDataSource
    }
    
    func fetchArtist(accessToken: String, id: String) async throws -> Artist {
        try await artistRemoteDataSource.fetchArtist(accessToken: accessToken, id: id)
    }
    
    func fetchSeveralArtists(accessToken: String, ids: [String]) async throws -> SeveralArtistsResponse {
        try await artistRemoteDataSource.fetchSeveralArtists(accessToken: accessToken, ids: ids)
    }
    
    func fetchRelatedArtists(accessToken: String, id: String) async throws -> SeveralArtistsResponse {
        try await artistRemoteDataSource.fetchRelatedArtists(accessToken: accessToken, id: id)
    }
    
    func fetchArtistTopTracks(accessToken: String, artistId: String) async throws -> ArtistTopTracksResponse {
        try await artistRemoteDataSource.fetchArtistTopTracks(accessToken: accessToken, artistId: artistId)
    }
}
