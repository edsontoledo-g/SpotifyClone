//
//  Int+Extension.swift
//  SpotifyClone
//
//  Created by Edson Dario Toledo Gonzalez on 25/12/23.
//

import Foundation

extension Int {
    
    func millisecondsToHoursMinutesAndSeconds() -> String {
        let totalSeconds = self / 1000
        let hours = totalSeconds / 3600
        let minutes = (totalSeconds % 3600) / 60
        let seconds = (totalSeconds % 3600) % 60
        if hours == .zero {
            return "\(minutes) min \(seconds) sec"
        } else {
            return "\(hours) h \(minutes) min"
        }
    }
}
