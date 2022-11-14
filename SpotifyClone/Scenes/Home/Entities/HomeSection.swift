//
//  HomeSection.swift
//  SpotifyClone
//
//  Created by Edson Dario Toledo Gonzalez on 10/11/22.
//

import Foundation

struct HomeSection: Identifiable {
    enum Category {
        case header
        case recentlyPlayed
        case topItems
        case recommendations
        case relatedArtists
    }
    
    var id: Int
    var title: String?
    var category: Category
    var items: [AnySpotifyContent]
    var relatedTo: AnySpotifyContent? = nil
    // var relatedTo: AnySpotifyContent? = nil -> if it's related to any spotify content
    // eg. Artist or album, render the section header with that information (image and name) like in spotify,
    // otherwise just render a simple section header with the title.
}
