//
//  ShowRemoteDataSource.swift
//  SpotifyClone
//
//  Created by Edson Dario Toledo Gonzalez on 24/12/23.
//

import Foundation

class ShowRemoteDataSource {
    
    func fetchShow(accessToken: String, id: String) async throws -> Show {
        let request = buildDetchShowRequest(accessToken: accessToken, id: id)
        return try await APICaller.shared.callService(request: request)
    }
    
    func fetchSeveralShows(accessToken: String, ids: [String]) async throws -> SeveralShowsResponse {
        let request = buildFetchSeverslShowsRequest(accessToken: accessToken, ids: ids)
        return try await APICaller.shared.callService(request: request)
    }
    
    private func buildDetchShowRequest(accessToken: String, id: String) -> Request {
        Request(
            baseUrl: APIConstants.baseApiUrl,
            endpoint: "shows/\(id)",
            headers: [.authorization: "Bearer \(accessToken)"])
    }
    
    private func buildFetchSeverslShowsRequest(accessToken: String, ids: [String]) -> Request {
        let idsString = ids.joined(separator: ",")
        return Request(
            baseUrl: APIConstants.baseApiUrl,
            endpoint: "shows",
            queryParams: ["ids": idsString],
            headers: [.authorization: "Bearer \(accessToken)"]
        )
    }
}
