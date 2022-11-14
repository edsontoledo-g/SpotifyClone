//
//  AnySpotifyContent.swift
//  SpotifyClone
//
//  Created by Edson Dario Toledo Gonzalez on 10/11/22.
//

import Foundation

protocol AnySpotifyContent {
    var uuid: String { get set }
    var type: String { get set }
}
