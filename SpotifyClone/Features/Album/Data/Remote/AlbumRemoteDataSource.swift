//
//  AlbumRemoteDataSource.swift
//  SpotifyClone
//
//  Created by Edson Dario Toledo Gonzalez on 26/10/23.
//

import Foundation

protocol AlbumRemote {
    func fetchAlbum(accessToken: String, id: String) async throws -> Album
}

struct AlbumRemoteDataSource: AlbumRemote {
    
    func fetchAlbum(accessToken: String, id: String) async throws -> Album {
        let request = buildFetchAlbumRequest(accessToken: accessToken, id: id)
        return try await APICaller.shared.callService(request: request)
    }
    
    private func buildFetchAlbumRequest(accessToken: String, id: String) -> Request {
        Request(
            baseUrl: APIConstants.baseApiUrl,
            endpoint: "albums/\(id)",
            headers: [.authorization: "Bearer \(accessToken)"]
        )
    }
}
