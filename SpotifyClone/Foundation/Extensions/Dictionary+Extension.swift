//
//  Dictionary+Extension.swift
//  SpotifyClone
//
//  Created by Edson Dario Toledo Gonzalez on 24/08/23.
//

import Foundation

extension Dictionary<String, String> {
    
    func buildQueryItems() -> [URLQueryItem] {
        map { URLQueryItem(name: $0, value: $1) }
    }
}
