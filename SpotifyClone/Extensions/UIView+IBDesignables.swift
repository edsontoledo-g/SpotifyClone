//
//  UIView+IBDesignables.swift
//  SpotifyClone
//
//  Created by Edson Dario Toledo Gonzalez on 10/11/22.
//

import UIKit

@IBDesignable extension UIView {
    @IBInspectable var cornerRadius: CGFloat {
        get { return layer.cornerRadius }
        set {
            layer.cornerRadius = newValue
        }
    }
}

