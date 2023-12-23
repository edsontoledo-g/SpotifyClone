//
//  DataModels.swift
//  SpotifyClone
//
//  Created by Edson Dario Toledo Gonzalez on 22/12/23.
//

import Foundation
import SwiftData

@Model class RecentSearch {
    var id: String
    var name: String
    var image: String
    var type: String
    
    init(
        id: String,
        name: String,
        image: String,
        type: String
    ) {
        self.id = id
        self.name = name
        self.image = image
        self.type = type
    }
}



extension RecentSearch {
    
    func asAnySpotifyItemUi() -> AnySpotifyItemUi {
        AnySpotifyItemUi(
            id: id,
            name: name,
            image: image,
            type: SpotifyItemType(rawValue: type) ?? .unknown
        )
    }
}

extension Array where Element == RecentSearch {
    
    func asAnySpotifyItemsUi() -> [AnySpotifyItemUi] {
        map { $0.asAnySpotifyItemUi() }
    }
}
