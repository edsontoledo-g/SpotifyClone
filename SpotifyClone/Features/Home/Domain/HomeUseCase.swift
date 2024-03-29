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
    private let showRepository: ShowRepository
    
    init(
        homeRepository: HomeRepository, 
        artistRepository: ArtistRepository,
        showRepository: ShowRepository
    ) {
        self.homeRepository = homeRepository
        self.artistRepository = artistRepository
        self.showRepository = showRepository
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
        limit: Int = 13,
        offset: Int = 0
    ) async throws -> [Album] {
        let trackResponse: TrackResponse = try await homeRepository.fetchUserTopItems(
            accessToken: accessToken,
            type: .track,
            limit: limit,
            offset: offset
        )
        return Array(trackResponse.items.asAlbums().asUniqueAlbums().prefix(8))
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
    
    func fetchUserSavedShows(
        accessToken: String,
        limit: Int = 10,
        offset: Int = 0
    ) async throws -> [Show] {
        let userSavedShows = try await homeRepository.fetchUserSavedShows(
            accessToken: accessToken,
            limit: limit,
            offset: offset
        )
        return userSavedShows.asShows()
    }
    
    func fetchShowsEpisodes(accessToken: String, ids: [String]) async throws -> [Episode] {
        let severalShowResponse = try await showRepository.fetchSeveralShows(accessToken: accessToken, ids: ids)
        var showsEpisodes: [Episode] = []
        for show in severalShowResponse.shows {
            let currentShow = try await showRepository.fetchShow(accessToken: accessToken, id: show.id)
            showsEpisodes += currentShow.episodes?.items.shuffled().prefix(3) ?? []
        }
        return showsEpisodes.shuffled()
    }
}
