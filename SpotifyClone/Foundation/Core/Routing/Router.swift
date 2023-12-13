//
//  Router.swift
//  SpotifyClone
//
//  Created by Edson Dario Toledo Gonzalez on 25/10/23.
//

import SwiftUI

@Observable class Router {
    
    enum Destination: Hashable {
        case artistDetail(id: String)
        case albumDetail(id: String)
    }
    
    var navigationPath = NavigationPath()
    
    func navigate(to destination: Destination) {
        navigationPath.append(destination)
    }
    
    func navigateBack() {
        navigationPath.removeLast()
    }
    
    func navigateToRoot() {
        navigationPath.removeLast(navigationPath.count)
    }
}
