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
            guard !state.homeUi.hasLoaded() else {
                return .setResults(homeUi: state.homeUi, filteredHomeUi: state.filteredHomeUi)
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
                homeUi = handleFetchUserSavedShowssSucces(homeUi, userSavedShows)
                return .setResults(homeUi: homeUi, filteredHomeUi: homeUi)
            } catch {
                return nil
            }
        case .removeFilter:
            return .setResults(homeUi: state.homeUi, filteredHomeUi: state.homeUi)
        case .filterMusic:
            var filteredHomeUi = state.homeUi
            filteredHomeUi.homeSectionsUi = filteredHomeUi.homeSectionsUi.filter { $0.type.isMusic() }
            return .setResults(homeUi: state.homeUi, filteredHomeUi: filteredHomeUi)
        case .filterShows:
            var filteredHomeUi = state.homeUi
            filteredHomeUi.homeSectionsUi = filteredHomeUi.homeSectionsUi.filter { $0.type.isShow() }
            return .setResults(homeUi: state.homeUi, filteredHomeUi: filteredHomeUi)
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
    
    private func handleFetchUserSavedShowssSucces(_ homeUi: HomeUi, _ shows: [Show]) -> HomeUi {
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
}
