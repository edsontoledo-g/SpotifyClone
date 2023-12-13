//
//  AlbumMiddleware.swift
//  SpotifyClone
//
//  Created by Edson Dario Toledo Gonzalez on 26/10/23.
//

import Foundation
import UnidirectionalFlow

struct AlbumMiddleware: Middleware {
    
    private let albumUseCase = AlbumUseCase()
    
    func process(state: AlbumState, with action: AlbumAction) async -> AlbumAction? {
        switch action {
        case .loadAlbumDetail(let accessToken, let albumId):
            guard !state.albumUi.hasLoaded() else { return .setResults(albumUi: state.albumUi) }
            async let albumCall = albumUseCase.fetchAlbum(accessToken: accessToken, id: albumId)
            do {
                let (album) = try await (albumCall)
                let albumUi = handleFetchAlbumSuccess(album)
                return .setResults(albumUi: albumUi)
            } catch {
                return nil
            }
        case .setResults:
            return nil
        }
    }
}

extension AlbumMiddleware {
    
    private func handleFetchAlbumSuccess(_ album: Album) -> AlbumUi {
        var albumUi = album.asAlbumUi()
        albumUi.albumSectionsUi.append(
            AlbumSectionUi(
                id: 0,
                items: album.tracks?.items.asAnyAlbumItemsUi() ?? [],
                type: .tracks
            )
        )
        return albumUi
    }
}
