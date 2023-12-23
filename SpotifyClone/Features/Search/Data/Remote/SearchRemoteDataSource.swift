//
//  SearchRemoteDataSource.swift
//  SpotifyClone
//
//  Created by Edson Dario Toledo Gonzalez on 25/11/23.
//

import Foundation

class SearchRemoteDataSource {
    
    func searchItems(accessToken: String, query: String) async throws -> SearchItemsResponse {
        let request = buildSearchItemsRequest(accessToken: accessToken, query: query)
        return try await APICaller.shared.callService(request: request)
    }
    
    private func buildSearchItemsRequest(accessToken: String, query: String) -> Request {
        Request(
            baseUrl: APIConstants.baseApiUrl,
            endpoint: "search",
            queryParams: [
                "q": query,
                "type": SearchItemType.allCases.map { $0.rawValue }.joined(separator: ",")
            ],
            headers: [.authorization: "Bearer \(accessToken)"]
        )
    }
}
