//
//  HomeMiddleware.swift
//  SpotifyClone
//
//  Created by Edson Dario Toledo Gonzalez on 28/08/23.
//

import Foundation
import UnidirectionalFlow

class HomeMiddleware: Middleware {
    
    private let homeUseCase: HomeUseCase
    private let profileUseCase: ProfileUseCase
    
    init() {
        homeUseCase = HomeInjector.provideHomeUseCase()
        profileUseCase = ProfileInjector.provideProfileUseCase()
    }
    
    func process(state: HomeState, with action: HomeAction) async -> HomeAction? {
        switch action {
        case .loadHome(let accessToken):
            guard !state.homeUi.hasLoadedHome() else {
                return .setResults(homeUi: state.homeUi)
            }
            async let userProfileCall = profileUseCase.getOrFetchProfile(accessToken: accessToken)
            async let userTopAlbumsCall = homeUseCase.fetchUserTopAlbums(accessToken: accessToken)
            async let recentlyPlayedTracksCall = homeUseCase.fetchRecentlyPlayedTracks(accessToken: accessToken)
            async let userTopArtistsCall = homeUseCase.fetchUserTopArtists(accessToken: accessToken)
            async let userSavedShowsCall = homeUseCase.fetchUserSavedShows(accessToken: accessToken)
            do {
                let (
                    userProfile,
                    userTopAlbums,
                    recentlyPlayedTracks,
                    userTopArtists,
                    userSavedShows
                ) = try await (
                    userProfileCall,
                    userTopAlbumsCall,
                    recentlyPlayedTracksCall,
                    userTopArtistsCall,
                    userSavedShowsCall
                )
                var homeUi = handleGetOrFetchUserSuccess(userProfile)
                homeUi = handleFetchUserTopAlbumsSuccess(homeUi, userTopAlbums)
                homeUi = handleFetchRecentlyPlayedTracksSuccess(homeUi, recentlyPlayedTracks)
                if let userTopArtist = userTopArtists.first {
                    let relatedArtists = try await homeUseCase.fetchRelatedArtists(
                        accessToken: accessToken,
                        id: userTopArtist.id
                    )
                    homeUi = handleFetchRelatedArtistsSuccess(homeUi, relatedArtists, relatedTo: userTopArtist)
                }
                homeUi = handleFetchUserTopArtistsSuccess(homeUi, userTopArtists)
                homeUi = handleFetchUserSavedShowsSucces(homeUi, userSavedShows)
                return .setResults(homeUi: homeUi)
            } catch {
                return nil
            }
        case .loadShows(let accessToken):
            guard !state.homeUi.hasLoadedShows() else {
                return .setResults(homeUi: state.homeUi)
            }
            var homeUi = state.homeUi
            guard let userSavedShows = homeUi.homeSectionsUi.first (where: { $0.type == .savedShows }) else { return nil }
            let userSavedShowsIds = userSavedShows.items.map { $0.id }
            async let showsEpisodesCall = homeUseCase.fetchShowsEpisodes(accessToken: accessToken, ids: userSavedShowsIds)
            do {
                let (showsEpisodes) = try await (showsEpisodesCall)
                homeUi = handleFetchShowsEpisodesSuccess(homeUi, showsEpisodes)
                return .setResults(homeUi: homeUi)
            } catch {
                return nil
            }
        case .setResults:
            return nil
        }
    }
}

extension HomeMiddleware {
    
    private func handleGetOrFetchUserSuccess(_ profile: Profile) -> HomeUi {
        HomeUi(profileUi: profile.asProfileUi())
    }
    
    private func handleFetchUserTopAlbumsSuccess(_ homeUi: HomeUi, _ albums: [Album]) -> HomeUi {
        let homeSectionUi = HomeSectionUi(
            id: 0,
            items: albums.asUniqueAlbums().asAnySpotifyItemUi(),
            type: .topTracks
        )
        var homeUi = homeUi
        homeUi.homeSectionsUi.append(homeSectionUi)
        return homeUi
    }
    
    private func handleFetchRecentlyPlayedTracksSuccess(
        _ homeUi: HomeUi, 
        _ albumsAndArtists: AlbumsAndArtists
    ) -> HomeUi {
        let albums = albumsAndArtists.albums.asAnySpotifyItemUi()
        let artists = albumsAndArtists.artists.asAnySpotifyItemsUi()
        let recentlyPlayedAlbumsAndArtists = Array((albums + artists).shuffled())
        let homeSectionUi = HomeSectionUi(
            id: 1,
            title: "Recently Played",
            items: recentlyPlayedAlbumsAndArtists,
            type: .recentlyPlayed
        )
        var homeUi = homeUi
        homeUi.homeSectionsUi.append(homeSectionUi)
        return homeUi
    }
    
    private func handleFetchRelatedArtistsSuccess(
        _ homeUi: HomeUi,
        _ artists: [Artist],
        relatedTo artist: Artist
    ) -> HomeUi {
        let homeSectionUi = HomeSectionUi(
            id: 2,
            title: "Because you like",
            relatedItem: artist.asAnySpotifyItemUi(),
            items: artists.asAnySpotifyItemsUi(),
            type: .relatedArtists
        )
        var homeUi = homeUi
        homeUi.homeSectionsUi.append(homeSectionUi)
        return homeUi
    }
    
    private func handleFetchUserTopArtistsSuccess(_ homeUi: HomeUi, _ artists: [Artist]) -> HomeUi {
        let homeSectionUi = HomeSectionUi(
            id: 3,
            title: "Your top artists",
            items: artists.asUniqueArtists().asAnySpotifyItemsUi(),
            type: .topArtists
        )
        var homeUi = homeUi
        homeUi.homeSectionsUi.append(homeSectionUi)
        return homeUi
    }
    
    private func handleFetchUserSavedShowsSucces(_ homeUi: HomeUi, _ shows: [Show]) -> HomeUi {
        let homeSectionUi = HomeSectionUi(
            id: 4,
            title: "Your shows",
            items: shows.asAnySpotifyItemsUi(),
            type: .savedShows
        )
        var homeUi = homeUi
        homeUi.homeSectionsUi.append(homeSectionUi)
        return homeUi
    }
    
    private func handleFetchShowsEpisodesSuccess(_ homeUi: HomeUi, _ episodes: [Episode]) -> HomeUi {
        let homeSectionUi = HomeSectionUi(
            id: 5,
            title: "",
            items: episodes.asAnySpotifyItemUi(),
            type: .showsEpisodes
        )
        var homeUi = homeUi
        homeUi.homeSectionsUi.append(homeSectionUi)
        return homeUi
    }
}
