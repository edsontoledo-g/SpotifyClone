//
//  HomeHeaderCell.swift
//  SpotifyClone
//
//  Created by Edson Dario Toledo Gonzalez on 10/11/22.
//

import UIKit

class HomeHeaderCell: UICollectionViewCell, SelfConfiguringHomeCell {
    static var reuseIdentifier = "HomeHeaderCell"
    
    @IBOutlet var headerLabel: UILabel!
    
    var didPressPreferencesButton: (() -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    @IBAction func notificationsButtonPressed(_ sender: UIButton) {
    }
    
    @IBAction func recentlyHeardButtonPressed(_ sender: UIButton) {
    }
    
    @IBAction func preferencesButtonPressed(_ sender: UIButton) {
        didPressPreferencesButton?()
    }
    
    func configure(with content: AnySpotifyContent) {
        if let homeHeaderItem = content as? HomeHeaderItem {
            headerLabel.text = "Hello, \(homeHeaderItem.userName)"
        } else {
            headerLabel.text = "Hello, Unknown"
        }
    }
}
