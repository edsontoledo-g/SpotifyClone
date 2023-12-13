//
//  ArtistRemoteDataSource.swift
//  SpotifyClone
//
//  Created by Edson Dario Toledo Gonzalez on 30/08/23.
//

import Foundation

protocol ArtistRemote {
    func fetchArtist(accessToken: String, id: String) async throws -> Artist
    func fetchSeveralArtists(accessToken: String, ids: [String]) async throws -> SeveralArtistsResponse
    func fetchRelatedArtists(accessToken: String, id: String) async throws -> SeveralArtistsResponse
    func fetchArtistTopTracks(accessToken: String, artistId: String) async throws -> ArtistTopTracksResponse
}

struct ArtistRemoteDataSource: ArtistRemote {
    
    func fetchArtist(accessToken: String, id: String) async throws -> Artist {
        let request = buildFetchArtistRequest(accessToken: accessToken, id: id)
        return try await APICaller.shared.callService(request: request)
    }
    
    func fetchSeveralArtists(accessToken: String, ids: [String]) async throws -> SeveralArtistsResponse {
        let request = buildFetchSeveralArtistsRequest(accessToken: accessToken, ids: ids)
        return try await APICaller.shared.callService(request: request)
    }
    
    func fetchRelatedArtists(accessToken: String, id: String) async throws -> SeveralArtistsResponse {
        let request = buildFetchRelatedArtistsRequest(accessToken: accessToken, id: id)
        return try await APICaller.shared.callService(request: request)
    }
    
    func fetchArtistTopTracks(accessToken: String, artistId: String) async throws -> ArtistTopTracksResponse {
        let request = buildFetchArtistTopTracksRequest(accessToken: accessToken, artistId: artistId)
        return try await APICaller.shared.callService(request: request)
    }
    
    private func buildFetchArtistRequest(accessToken: String, id: String) -> Request {
        Request(
            baseUrl: APIConstants.baseApiUrl,
            endpoint: "artists/\(id)",
            headers: [.authorization: "Bearer \(accessToken)"]
        )
    }
    
    private func buildFetchSeveralArtistsRequest(accessToken: String, ids: [String]) -> Request {
        let idsString = ids.joined(separator: ",")
        return Request(
            baseUrl: APIConstants.baseApiUrl,
            endpoint: "artists",
            queryParams: ["ids": idsString],
            headers: [.authorization: "Bearer \(accessToken)"]
        )
    }
    
    private func buildFetchRelatedArtistsRequest(accessToken: String, id: String) -> Request {
        Request(
            baseUrl: APIConstants.baseApiUrl,
            endpoint: "artists/\(id)/related-artists",
            headers: [.authorization: "Bearer \(accessToken)"]
        )
    }
    
    private func buildFetchArtistTopTracksRequest(accessToken: String, artistId: String) -> Request {
        Request(
            baseUrl: APIConstants.baseApiUrl,
            endpoint: "artists/\(artistId)/top-tracks",
            queryParams: ["market": "ES"],
            headers: [.authorization: "Bearer \(accessToken)"]
        )
    }
}
