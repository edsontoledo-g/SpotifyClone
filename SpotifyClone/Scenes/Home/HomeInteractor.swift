//
//  HomeInteractor.swift
//  SpotifyClone
//
//  Created by Edson Dario Toledo Gonzalez on 10/11/22.
//

import Foundation

protocol AnyHomeInputInteractor: AnyObject {
    var presenter: AnyHomeOuputInteractor? { get set }
    
    func getUserProfile() async
    func getRecenlyPlayedTracks() async
    func getUserTopItems() async
    func getRecommendations(seedArtist: String, seedGenre: String, seedTrack: String) async
    func getRelatedArtists(for artist: Artist) async
    func treatRecentlyPlayedTracks(_ tracks: [Track]) async
    func treatRecentlyTopItems(tracks: [Track], artists: [Artist])
    func treatRecommendations(tracks: [Track]) async
}

protocol AnyHomeOuputInteractor: AnyObject {
    func didFinishGettingUserProfile(result: Result<UserProfile, APICaller.NetworkError>)
    func didFinishGettingRecentlyPlayedTracks(result: Result<[Track], APICaller.NetworkError>)
    func didFinishGettingUserTopItems(result: Result<([Artist], [Track]), APICaller.NetworkError>)
    func didFinishGettingRecomendations(result: Result<[Track], APICaller.NetworkError>)
    func didFinishGettingRelatedArtists(result: Result<(Artist, [Artist]), APICaller.NetworkError>)
    func didFinishTreatingRecentlyplayedTracks(result: ([Artist], [Album]))
    func didFinishTreatingTopItems(result: ([Artist], [Album]))
    func didFinishTreatingRecommendations(result: ([Artist], [Album]))
}

class HomeInputInteractor: AnyHomeInputInteractor {
    var presenter: AnyHomeOuputInteractor?
    
    func getUserProfile() async {
        let request = APICaller.Request(baseURL: APICaller.Constants.baseURL, endpoint: .userProfile)
        
        do {
            let userProfile = try await APICaller.shared.callService(request: request, type: UserProfile.self)
            presenter?.didFinishGettingUserProfile(result: .success(userProfile))
        } catch {
            presenter?.didFinishGettingUserProfile(result: .failure(error as! APICaller.NetworkError))
        }
    }
    
    func getRecenlyPlayedTracks() async {
        let request = APICaller.Request(
            baseURL: APICaller.Constants.baseURL,
            endpoint: .recentlyPlayed,
            queryParams: ["limit": "24"]
        )
        
        do {
            let recentlyPlayedTracks = try await APICaller.shared.callService(request: request, type: RecentlyPlayedTracksResponse.self)
            presenter?.didFinishGettingRecentlyPlayedTracks(result: .success(recentlyPlayedTracks.items.map { $0.track }))
        } catch {
            presenter?.didFinishGettingRecentlyPlayedTracks(result: .failure(error as! APICaller.NetworkError))
        }
    }
    
    func getUserTopItems() async {
        let artistsRequest = APICaller.Request(
            baseURL: APICaller.Constants.baseURL,
            endpoint: .userTopArtists,
            queryParams: ["limit": "6"]
        )
        let tracksRequest = APICaller.Request(
            baseURL: APICaller.Constants.baseURL,
            endpoint: .userTopTracks,
            queryParams: ["limit": "18"]
        )

        do {
            async let responseUserTopArtists = try APICaller.shared.callService(request: artistsRequest, type: UserTopArtistsResponse.self)
            async let responseUserTopTracks = try APICaller.shared.callService(request: tracksRequest, type: UserTopTracksResponse.self)

            let (userTopArtists, userTopTracks) = try await (responseUserTopArtists.items, responseUserTopTracks.items)
            presenter?.didFinishGettingUserTopItems(result: .success((userTopArtists, userTopTracks)))
        } catch {
            presenter?.didFinishGettingUserTopItems(result: .failure(error as! APICaller.NetworkError))
        }
    }
    
    func getRecommendations(seedArtist: String, seedGenre: String, seedTrack: String) async {
        let request = APICaller.Request(
            baseURL: APICaller.Constants.baseURL,
            endpoint: .recommendations,
            queryParams: [
                "limit": "6",
                "seed_artists": seedArtist,
                "seed_genres": seedGenre,
                "seed_tracks": seedTrack
            ]
        )
        
        do {
            let recommendations = try await APICaller.shared.callService(request: request, type: RecommendationsRespose.self)
            presenter?.didFinishGettingRecomendations(result: .success(recommendations.tracks))
        } catch {
            presenter?.didFinishGettingRecomendations(result: .failure(error as! APICaller.NetworkError))
        }
    }
    
    func getRelatedArtists(for artist: Artist) async {
        let request = APICaller.Request(
            baseURL: APICaller.Constants.baseURL,
            endpoint: .custom
        )
        
        do {
            let relatedArtists = try await APICaller.shared.callService(request: request, type: RelatedArtistsResponse.self, customEndpoint: "/artists/\(artist.id)/related-artists")
            presenter?.didFinishGettingRelatedArtists(result: .success((artist, relatedArtists.artists)))
        } catch {
            presenter?.didFinishGettingRelatedArtists(result: .failure(error as! APICaller.NetworkError))
        }
    }
    
    func treatRecentlyPlayedTracks(_ tracks: [Track]) async {
        let (artists, albums) = await treatTracks(tracks: tracks)
        presenter?.didFinishTreatingRecentlyplayedTracks(result: (artists, albums))
    }
    
    func treatRecentlyTopItems(tracks: [Track], artists: [Artist]) {
        let allAlbums = tracks.map { $0.album }
        var uniqueAlbums: [Album] = []
        
        for album in allAlbums {
            if !uniqueAlbums.contains(where: { $0.id == album.id }) {
                uniqueAlbums.append(album)
            }
        }
        
        presenter?.didFinishTreatingTopItems(result: (artists, uniqueAlbums))
    }
    
    func treatRecommendations(tracks: [Track]) async {
        let (artists, albums) = await treatTracks(tracks: tracks)
        presenter?.didFinishTreatingRecommendations(result: (artists, albums))
    }
    
    
    private func treatTracks(tracks: [Track]) async -> (artists: [Artist], albums: [Album]) {
        let allArtists: [Artist] = tracks.compactMap { $0.artists.first }
        let allAlbums: [Album] = tracks.map { $0.album }
        var uniqueArtists: [Artist] = []
        var uniqueAlbums: [Album] = []
        
        for artist in allArtists {
            if !uniqueArtists.contains(where: { $0.id == artist.id }) {
                let request = APICaller.Request(
                    baseURL: APICaller.Constants.baseURL,
                    endpoint: .custom
                )
                
                guard let fullArtist = try? await APICaller.shared.callService(request: request, type: Artist.self, customEndpoint: "/artists/\(artist.id)") else {
                    continue
                }

                uniqueArtists.append(fullArtist)
            }
        }
        
        for album in allAlbums {
            if !uniqueAlbums.contains(where: { $0.id == album.id }) {
                uniqueAlbums.append(album)
            }
        }
        
        return (uniqueArtists, uniqueAlbums)
    }
}
