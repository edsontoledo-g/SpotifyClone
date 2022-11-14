//
//  SettingsCell.swift
//  SpotifyClone
//
//  Created by Edson Dario Toledo Gonzalez on 10/11/22.
//

import UIKit

class SettingsCell: UITableViewCell, SelfConfiguringPreferencesCell {
    static var reuseIdentifier = "SettingsCell"

    @IBOutlet var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func configure(for user: UserProfile, title: String?) {
        titleLabel.text = title
    }
}
