//
//  APICaller.swift
//  SpotifyClone
//
//  Created by Edson Dario Toledo Gonzalez on 08/11/22.
//

import Foundation

@MainActor
class APICaller {
    static let shared = APICaller()
    
    enum NetworkError: Error {
        case badURL
        case badRequest
        case connectionError
        case invalidToken
        case httpResponse
        case JSONDecoder
    }
    
    struct Constants {
        static let baseURL = "https://api.spotify.com/v1"
        static let clientID = "6e3463390a304f9c8b3e9ca273e59123"
        static let clientSecret = "e72e49912c474f82924897c51d014fd0"
    }
    
    struct Request {
        enum Endpoint: String {
            case userProfile = "/me"
            case recentlyPlayed = "/me/player/recently-played"
            case userTopArtists = "/me/top/artists"
            case userTopTracks = "/me/top/tracks"
            case recommendations = "/recommendations"
            case custom
        }
        
        enum HTTPMethod: String {
            case GET
            case POST
        }
        
        let baseURL: String
        let endpoint: Endpoint
        var queryParams: [String:String] = [:]
        let httpMethod: HTTPMethod = .GET
        
        var url: String {
            if endpoint == .custom {
                return baseURL
            } else {
                return baseURL + endpoint.rawValue
            }
        }
    }
    
    func callService<T: Decodable>(request: Request, type: T.Type, customEndpoint: String? = nil) async throws -> T {
        var serviceURL: URLComponents?
        if request.endpoint == .custom {
            serviceURL = URLComponents(string: request.url + (customEndpoint ?? ""))
        } else {
            serviceURL = URLComponents(string: request.url)
        }
       
        serviceURL?.queryItems = buildQueryItems(params: request.queryParams)
        
        guard let url = serviceURL?.url else {
            throw NetworkError.badURL
        }
        
        guard let token = AuthenticationManager.shared.accessToken else {
            throw NetworkError.invalidToken
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.httpMethod.rawValue
        urlRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        
        guard let (data, response) = try? await URLSession.shared.data(for: urlRequest) else {
            throw NetworkError.connectionError
        }
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.httpResponse
        }
        
        if httpResponse.statusCode > 299 {
            print(httpResponse.statusCode)
            throw NetworkError.badRequest
        }
        
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(type, from: data)
            return decodedData
        } catch {
            throw NetworkError.JSONDecoder
        }
    }
    
    func buildQueryItems(params: [String: String]) -> [URLQueryItem] {
        params.map{ URLQueryItem(name: $0, value: $1) }
    }
}
