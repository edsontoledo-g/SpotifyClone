//
//  SelfConfiguringCell.swift
//  SpotifyClone
//
//  Created by Edson Dario Toledo Gonzalez on 10/11/22.
//

import Foundation

protocol SelfConfiguringHomeCell {
    static var reuseIdentifier: String { get set }
    func configure(with content: AnySpotifyContent)
}
