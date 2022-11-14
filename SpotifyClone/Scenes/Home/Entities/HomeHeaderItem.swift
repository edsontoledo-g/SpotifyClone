//
//  HomeHeaderItem.swift
//  SpotifyClone
//
//  Created by Edson Dario Toledo Gonzalez on 10/11/22.
//

import Foundation

struct HomeHeaderItem: AnySpotifyContent {
    var uuid = UUID().uuidString
    var type: String = "header_item"
    
    var userName: String
}
