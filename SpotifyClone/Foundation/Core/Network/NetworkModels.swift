//
//  NetworkModels.swift
//  SpotifyClone
//
//  Created by Edson Dario Toledo Gonzalez on 24/08/23.
//

import Foundation

struct Request {
    var baseUrl: String
    var endpoint: String
    var queryParams: [String: String] = [:]
    var httpMethod: HTTPMethod = .GET
    var headers: [Header: String] = [:]

    var completeUrl: String {
        baseUrl + endpoint
    }
    
    enum HTTPMethod: String {
        case GET
        case POST
    }
    
    enum Header: String {
        case authorization = "Authorization"
    }
}

enum NetworkError: Error {
    case badUrl
    case badRequest
    case serverError
    case unknown
}
