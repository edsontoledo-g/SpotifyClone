//
//  ArtistMiddleware.swift
//  SpotifyClone
//
//  Created by Edson Dario Toledo Gonzalez on 08/09/23.
//

import Foundation
import UnidirectionalFlow

struct ArtistMiddleware: Middleware {
    
    private let artistUseCase = ArtistUseCase()
    private let profileUseCase = ProfileUseCase()
    
    func process(state: ArtistState, with action: ArtistAction) async -> ArtistAction? {
        switch action {
        case .loadArtistDetail(let accessToken, let artistId):
            guard !state.artistUi.hasLoaded() else { return .setResults(artistUi: state.artistUi) }
            async let artistCall = artistUseCase.fetchArtist(
                accessToken: accessToken,
                id: artistId
            )
            async let artistTopTracksAndAlbumsCall = artistUseCase.fetchArtistTopTracksAndAlbums(
                accessToken: accessToken,
                artistId: artistId
            )
            async let isFollowingArtistCall = profileUseCase.fetchIsFollowingArtist(
                accessToken: accessToken,
                id: artistId
            )
            async let relatedArtistsCall = artistUseCase.fetchRelatedArtists(
                accessToken: accessToken,
                id: artistId
            )
            do {
                let (
                    artist,
                    artistTopTracksAndAlbums,
                    isFollowingArtist,
                    relatedArtists
                ) = try await (
                    artistCall,
                    artistTopTracksAndAlbumsCall,
                    isFollowingArtistCall,
                    relatedArtistsCall
                )
                var artistUi = handleFetchArtistSuccess(artist, isFollowingArtist: isFollowingArtist)
                artistUi.artistSectionsUi.append(handleFetchArtistTopTracksSuccess(artistTopTracksAndAlbums.tracks))
                artistUi.artistSectionsUi.append(handleFetchArtistTopAlbumsSuccess(artistTopTracksAndAlbums.albums))
                artistUi.artistSectionsUi.append(handleFetchRelatedArtistsSuccess(relatedArtists))
                return .setResults(artistUi: artistUi)
            } catch {
                return nil
            }
        case .setResults:
            return nil
        }
    }
}

extension ArtistMiddleware {
    
    private func handleFetchArtistSuccess(_ artist: Artist, isFollowingArtist: Bool) -> ArtistUi {
        artist.asArtistUi(isFollowing: isFollowingArtist)
    }
    
    private func handleFetchArtistTopTracksSuccess(_ tracks: [Track]) -> ArtistSectionUi {
        ArtistSectionUi(
            id: 0,
            title: "Top",
            items: Array(tracks.asAnyArtistItemsUi().prefix(5)),
            type: .topTracks
        )
    }
    
    private func handleFetchArtistTopAlbumsSuccess(_ albums: [Album]) -> ArtistSectionUi {
        ArtistSectionUi(
            id: 1,
            title: "Top Albums",
            items: Array(albums.asAnyArtistItemUi().prefix(4)),
            type: .topReleases
        )
    }
    
    private func handleFetchRelatedArtistsSuccess(_ artists: [Artist]) -> ArtistSectionUi {
        ArtistSectionUi(
            id: 2,
            title: "Related Artists",
            items: artists.asAnyArtistItemsUi(),
            type: .relatedArtists
        )
    }
}
