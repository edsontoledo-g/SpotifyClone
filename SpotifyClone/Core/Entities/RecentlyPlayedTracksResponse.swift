//
//  RecentlyPlayedTracksResponse.swift
//  SpotifyClone
//
//  Created by Edson Dario Toledo Gonzalez on 11/11/22.
//

import Foundation

struct RecentlyPlayedTracksResponse: Decodable {
    var items: [Item]
    
    struct Item: Decodable {
        var track: Track
    }
}
