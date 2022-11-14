//
//  PreferencesViewController+DataSource.swift
//  SpotifyClone
//
//  Created by Edson Dario Toledo Gonzalez on 10/11/22.
//

import UIKit

extension PreferencesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.numberOfRowsInSection() ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let row = presenter?.preferences?[indexPath.row] else {
            fatalError()
        }
        
        switch row.type {
        case .userProfile:
            return configureCell(UserProfileCell.self, for: indexPath)
        case .settings:
            return configureCell(SettingsCell.self, for: indexPath)
        case .signOut:
            return configureCell(SignOutCell.self, for: indexPath)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
