//
//  Double+Extension.swift
//  SpotifyClone
//
//  Created by Edson Dario Toledo Gonzalez on 22/02/24.
//

import Foundation

extension Double {
    
    func isNumber() -> Bool {
        !isInfinite && !isNaN
    }
}
