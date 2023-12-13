//
//  ArtistRepository.swift
//  SpotifyClone
//
//  Created by Edson Dario Toledo Gonzalez on 30/08/23.
//

import Foundation

struct ArtistRepository {
    
    private let artistRemote = ArtistRemoteDataSource()
    
    func fetchArtist(accessToken: String, id: String) async throws -> Artist {
        try await artistRemote.fetchArtist(accessToken: accessToken, id: id)
    }
    
    func fetchSeveralArtists(accessToken: String, ids: [String]) async throws -> SeveralArtistsResponse {
        try await artistRemote.fetchSeveralArtists(accessToken: accessToken, ids: ids)
    }
    
    func fetchRelatedArtists(accessToken: String, id: String) async throws -> SeveralArtistsResponse {
        try await artistRemote.fetchRelatedArtists(accessToken: accessToken, id: id)
    }
    
    func fetchArtistTopTracks(accessToken: String, artistId: String) async throws -> ArtistTopTracksResponse {
        try await artistRemote.fetchArtistTopTracks(accessToken: accessToken, artistId: artistId)
    }
}
