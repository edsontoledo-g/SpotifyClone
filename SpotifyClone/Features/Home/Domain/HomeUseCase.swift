//
//  HomeUseCase.swift
//  SpotifyClone
//
//  Created by Edson Dario Toledo Gonzalez on 30/08/23.
//

import Foundation

class HomeUseCase {
    
    private let homeRepository: HomeRepository
    private let artistRepository: ArtistRepository
    
    init(
        homeRepository: HomeRepository, 
        artistRepository: ArtistRepository
    ) {
        self.homeRepository = homeRepository
        self.artistRepository = artistRepository
    }
    
    func fetchUserTopArtists(
        accessToken: String,
        limit: Int = 13,
        offset: Int = 0
    ) async throws -> [Artist] {
        let artistsResponse: ArtistsResponse = try await homeRepository.fetchUserTopItems(
            accessToken: accessToken,
            type: .artist,
            limit: limit,
            offset: offset
        )
        return artistsResponse.items.asUniqueArtists()
        
    }
    
    func fetchUserTopAlbums(
        accessToken: String,
        limit: Int = 8,
        offset: Int = 0
    ) async throws -> [Album] {
        let trackResponse: TrackResponse = try await homeRepository.fetchUserTopItems(
            accessToken: accessToken,
            type: .track,
            limit: limit,
            offset: offset
        )
        return trackResponse.items.asAlbums().asUniqueAlbums()
    }
    
    func fetchRecentlyPlayedTracks(
        accessToken: String,
        limit: Int = 12,
        after: String? = nil,
        before: String? = nil
    ) async throws -> AlbumsAndArtists {
        let recentlyPlayedTracksResponse = try await homeRepository.fetchRecentlyPlayedTracks(
            accessToken: accessToken,
            limit: limit,
            after: after,
            before: before
        )
        let recentlyPlayedTracks = recentlyPlayedTracksResponse.items.map { $0.track }
        let recentlyPlayedAlbums = recentlyPlayedTracks.asAlbums().asUniqueAlbums()
        let recentlyPlayedArtists = recentlyPlayedTracks.asMainArtists().asUniqueArtists()
        let severalArtistsResponse = try await artistRepository.fetchSeveralArtists(
            accessToken: accessToken,
            ids: recentlyPlayedArtists.map { $0.id }
        )
        return (recentlyPlayedAlbums, severalArtistsResponse.artists)
    }
    
    func fetchRelatedArtists(accessToken: String, id: String) async throws -> [Artist] {
        let relatedArtistsResponse = try await artistRepository.fetchRelatedArtists(
            accessToken: accessToken,
            id: id
        )
        return relatedArtistsResponse.artists
    }
}
