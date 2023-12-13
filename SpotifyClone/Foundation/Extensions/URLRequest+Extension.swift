//
//  URLRequest+Extension.swift
//  SpotifyClone
//
//  Created by Edson Dario Toledo Gonzalez on 25/08/23.
//

import Foundation

extension URLRequest {
    
    mutating func setHeaders(_ headers: [Request.Header: String]) {
        headers.forEach { headerField, value in
            addValue(value, forHTTPHeaderField: headerField.rawValue)
        }
    }
}
