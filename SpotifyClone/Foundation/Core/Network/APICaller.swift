//
//  APICaller.swift
//  SpotifyClone
//
//  Created by Edson Dario Toledo Gonzalez on 24/08/23.
//

import Foundation

class APICaller {
    
    static let shared = APICaller()
    
    func callService<Response: Decodable>(request: Request) async throws -> Response {
        guard var urlComponents = URLComponents(string: request.completeUrl) else {
            throw NetworkError.badUrl
        }
        urlComponents.queryItems = request.queryParams.buildQueryItems()
        guard let url = urlComponents.url else {
            throw NetworkError.badUrl
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.httpMethod.rawValue
        if request.httpMethod == .POST {
            urlRequest.httpBody = urlComponents.query?.data(using: .utf8)
        }
        urlRequest.setHeaders(request.headers)
        do {
            let (data, _) = try await URLSession.shared.data(for: urlRequest)
            let response = try JSONDecoder().decode(Response.self, from: data)
            return response
        } catch {
            throw NetworkError.badRequest
        }
    }
}
