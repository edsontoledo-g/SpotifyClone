//
//  AuthenticationResponse.swift
//  SpotifyClone
//
//  Created by Edson Dario Toledo Gonzalez on 09/11/22.
//

import Foundation

struct AuthenticationResponse: Decodable {
    var access_token: String
    var expires_in: Int
    var refresh_token: String?
    var scope: String
    var token_type: String
}
