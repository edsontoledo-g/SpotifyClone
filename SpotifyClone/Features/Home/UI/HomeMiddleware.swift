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
            guard !state.homeUi.hasLoaded() else { return .setResults(homeUi: state.homeUi) }
            async let userProfileCall = profileUseCase.fetchProfile(accessToken: accessToken)
            async let userTopAlbumsCall = homeUseCase.fetchUserTopAlbums(accessToken: accessToken)
            async let recentlyPlayedTracksCall = homeUseCase.fetchRecentlyPlayedTracks(accessToken: accessToken)
            async let userTopArtistsCall = homeUseCase.fetchUserTopArtists(accessToken: accessToken)
            do {
                let (
                    userProfile,
                    userTopAlbums,
                    recentlyPlayedTracks,
                    userTopArtists
                ) = try await (
                    userProfileCall,
                    userTopAlbumsCall,
                    recentlyPlayedTracksCall,
                    userTopArtistsCall
                )
                var homeUi = handleFetchUserProfileSuccess(userProfile)
                var homeSectionsUi: [HomeSectionUi] = []
                homeSectionsUi.append(handleFetchUserTopAlbumsSuccess(userTopAlbums))
                homeSectionsUi.append(handleFetchRecentlyPlayedTracksSuccess(recentlyPlayedTracks))
                if let userTopArtist = userTopArtists.first {
                    let relatedArtists = try await homeUseCase.fetchRelatedArtists(
                        accessToken: accessToken,
                        id: userTopArtist.id
                    )
                    homeSectionsUi.append(handleFetchRelatedArtistsSuccess(relatedArtists, relatedTo: userTopArtist))
                }
                homeSectionsUi.append(handleFetchUserTopArtistsSuccess(userTopArtists))
                homeUi.homeSectionsUi = homeSectionsUi
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
    
    private func handleFetchUserProfileSuccess(_ profile: Profile) -> HomeUi {
        HomeUi(profileUi: profile.asProfileUi())
    }
    
    private func handleFetchUserTopAlbumsSuccess(_ albums: [Album]) -> HomeSectionUi {
        HomeSectionUi(
            id: 0,
            items: albums.asUniqueAlbums().asAnySpotifyItemUi(),
            type: .topTracks
        )
    }
    
    private func handleFetchRecentlyPlayedTracksSuccess(
        _ albumsAndArtists: AlbumsAndArtists
    ) -> HomeSectionUi {
        let albums = albumsAndArtists.albums.asAnySpotifyItemUi()
        let artists = albumsAndArtists.artists.asAnySpotifyItemsUi()
        let recentlyPlayedAlbumsAndArtists = Array((albums + artists).shuffled())
        return HomeSectionUi(
            id: 1,
            title: "Recently Played",
            items: recentlyPlayedAlbumsAndArtists,
            type: .recentlyPlayed
        )
    }
    
    private func handleFetchRelatedArtistsSuccess(
        _ artists: [Artist],
        relatedTo artist: Artist
    ) -> HomeSectionUi {
        HomeSectionUi(
            id: 2,
            title: "Because you like",
            relatedItem: artist.asAnySpotifyItemUi(),
            items: artists.asAnySpotifyItemsUi(),
            type: .relatedArtists
        )
    }
    
    private func handleFetchUserTopArtistsSuccess(_ artists: [Artist]) -> HomeSectionUi {
        HomeSectionUi(
            id: 3,
            title: "Your top artists",
            items: artists.asUniqueArtists().asAnySpotifyItemsUi(),
            type: .topArtists
        )
    }
}
