//
//  UIImage+Rounded.swift
//  SpotifyClone
//
//  Created by Edson Dario Toledo Gonzalez on 12/11/22.
//

import UIKit

extension UIImageView {
    func makeRounded() {
        layer.borderWidth = 1
        layer.masksToBounds = false
        layer.borderColor = UIColor.clear.cgColor
        layer.cornerRadius = self.frame.width / 2
        clipsToBounds = true
    }
    
    func makeSquared() {
        layer.borderWidth = 1
        layer.masksToBounds = false
        layer.borderColor = UIColor.clear.cgColor
        layer.cornerRadius = 0.0
        clipsToBounds = true
    }
}
